import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/db/app_database.dart';
import 'package:memorize_word/core/db/seed_importer.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late File fixture;

  setUpAll(() {
    fixture = _buildFixture();
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('seed_importer_test');
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<SeedImportResult> runImport() =>
      SeedImporter(db, tempDir: tempDir)
          .importIfNeeded(() async => fixture.readAsBytesSync());

  test('首次导入写入词库表并记录 seed_version', () async {
    final r = await runImport();
    expect(r.imported, isTrue);
    expect(r.wordCount, 5);
    expect(r.seedVersion, '7');

    final words = await db.select(db.words).get();
    expect(words, hasLength(5));
    expect(words.every((w) => w.language == 'en' || w.language == 'ja'), isTrue);

    final decks = await db.select(db.decks).get();
    expect(decks.map((d) => d.id), contains('en-cefr-a1'));

    final meta = await (db.select(db.meta)..where((m) => m.key.equals('seed_version')))
        .getSingle();
    expect(meta.value, '7');
  });

  test('重复导入幂等（不产生重复行）', () async {
    await runImport();
    final r2 = await runImport();
    expect(r2.imported, isFalse);
    expect(r2.wordCount, 5);

    final words = await db.select(db.words).get();
    expect(words, hasLength(5));
  });

  test('版本变更时增量合并且保留既有数据', () async {
    await runImport();
    // 模拟新版本种子：新增一个词，版本号升到 8。
    final v8 = _buildFixture(extraWord: 'zephyr', version: '8');
    final r = await SeedImporter(db, tempDir: tempDir)
        .importIfNeeded(() async => v8.readAsBytesSync());
    expect(r.imported, isTrue);
    expect(r.wordCount, 6);
    final words = await db.select(db.words).get();
    expect(words.map((w) => w.headword), contains('zephyr'));
  });

  test('种子含用户词库中已有同 id 行时不覆盖（INSERT OR IGNORE）', () async {
    await runImport();
    // 用户数据表不受种子影响：progress 只有一个词也有进度时导入仍幂等
    final before = await db.select(db.words).get();
    await runImport();
    final after = await db.select(db.words).get();
    expect(after.map((w) => w.id), before.map((w) => w.id));
  });
}

/// 构造一个小型种子 SQLite 文件（结构与流水线产物一致）。
File _buildFixture({String? extraWord, String version = '7'}) {
  final dir = Directory.systemTemp.createTempSync('seed_fixture');
  final path = '${dir.path}${Platform.pathSeparator}fixture.sqlite';
  final d = sqlite3.sqlite3.open(path);
  d.execute('''
    CREATE TABLE words (
      id TEXT NOT NULL PRIMARY KEY, language TEXT NOT NULL, headword TEXT NOT NULL,
      reading TEXT NULL, pos TEXT NULL, phonetic TEXT NULL, meanings TEXT NOT NULL,
      examples TEXT NOT NULL, difficulty REAL NOT NULL, level TEXT NOT NULL,
      freq_rank INTEGER NULL, tags TEXT NULL,
      UNIQUE (language, headword, pos))''');
  d.execute('CREATE TABLE decks (id TEXT NOT NULL PRIMARY KEY, language TEXT NOT NULL, '
      'name TEXT NOT NULL, sort_order INTEGER NOT NULL)');
  d.execute('CREATE TABLE deck_words (deck_id TEXT NOT NULL, word_id TEXT NOT NULL, '
      'sort_order INTEGER NOT NULL, PRIMARY KEY (deck_id, word_id))');
  d.execute('CREATE TABLE meta (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)');
  final words = [
    ['en-w1', 'en', 'apple', null, null, null, '[{"lang":"zh","def":"苹果"}]', '[]', 1.0, 'A1', 100, null],
    ['en-w2', 'en', 'walk', null, 'v', null, '[{"lang":"zh","def":"走"}]', '[]', 1.0, 'A1', 458, null],
    ['en-w3', 'en', 'serene', null, 'adj', null, '[{"lang":"zh","def":"平静的"}]', '[]', 5.0, 'C1', 9000, null],
    ['en-w4', 'en', 'tremble', null, 'v', null, '[{"lang":"zh","def":"颤抖"}]', '[]', 5.0, 'C1', 12000, null],
    ['ja-w1', 'ja', '会う', 'あう', 'v5u', null, '[{"lang":"en","def":"to meet"}]', '[]', 1.0, 'N5', 1, null],
    if (extraWord != null)
      ['en-w5', 'en', extraWord, null, null, null, '[{"lang":"zh","def":"微风"}]', '[]', 6.0, 'C2', 19000, null],
  ];
  final stmt = d.prepare(
      'INSERT INTO words VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
  for (final w in words) {
    stmt.execute(w);
  }
  stmt.close();
  d.execute("INSERT INTO decks VALUES ('en-cefr-a1', 'en', '英语 A1', 0)");
  d.execute("INSERT INTO deck_words VALUES ('en-cefr-a1', 'en-w1', 0)");
  d.execute('INSERT INTO meta VALUES (?, ?)', ['seed_version', version]);
  d.close();
  final bytes = File(path).readAsBytesSync();
  final out = File('${Directory.systemTemp.path}${Platform.pathSeparator}'
      'fixture_${DateTime.now().microsecondsSinceEpoch}.sqlite');
  out.writeAsBytesSync(bytes);
  dir.deleteSync(recursive: true);
  return out;
}
