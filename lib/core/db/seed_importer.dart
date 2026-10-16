import 'dart:io';

import 'package:drift/drift.dart';

import 'app_database.dart';

/// 种子导入结果。
class SeedImportResult {
  const SeedImportResult({
    required this.imported,
    required this.seedVersion,
    required this.wordCount,
  });

  final bool imported; // false = 版本一致已跳过
  final String seedVersion;
  final int wordCount;
}

/// 首启种子导入：把 assets/db/seed_v1.sqlite 中的词库表批量拷入主库。
///
/// 幂等：比较 meta.seed_version，一致且词表非空则跳过。
/// 词库表为只读区，用户数据永不触碰。
class SeedImporter {
  SeedImporter(this.db, {required Directory tempDir})
      : _tempPath = '${tempDir.path}${Platform.pathSeparator}seed_asset.sqlite';

  final AppDatabase db;
  final String _tempPath;

  /// [loadSeed] 返回 assets 中种子文件的字节（注入以便测试）。
  Future<SeedImportResult> importIfNeeded(
    Future<Uint8List> Function() loadSeed,
  ) async {
    final bytes = await loadSeed();
    final file = File(_tempPath);
    await file.writeAsBytes(bytes, flush: true);

    await db.customStatement('ATTACH DATABASE ? AS seed', [file.path]);
    try {
      final seedVersion = await _readMeta('seed', 'seed_version') ?? '1';
      final localVersion = await _readMeta('main', 'seed_version');
      final wordCount = await _wordCount();

      if (localVersion == seedVersion && wordCount > 0) {
        return SeedImportResult(
          imported: false,
          seedVersion: seedVersion,
          wordCount: wordCount,
        );
      }

      await db.transaction(() async {
        await db.customStatement(
          'INSERT OR IGNORE INTO words (id, language, headword, reading, pos, '
          'phonetic, meanings, examples, difficulty, level, freq_rank, tags) '
          'SELECT id, language, headword, reading, pos, phonetic, meanings, '
          'examples, difficulty, level, freq_rank, tags FROM seed.words');
        await db.customStatement(
          'INSERT OR IGNORE INTO decks (id, language, name, sort_order) '
          'SELECT id, language, name, sort_order FROM seed.decks');
        await db.customStatement(
          'INSERT OR IGNORE INTO deck_words (deck_id, word_id, sort_order) '
          'SELECT deck_id, word_id, sort_order FROM seed.deck_words');
        await db.meta.insertOnConflictUpdate(MetaCompanion.insert(
          key: 'seed_version',
          value: seedVersion,
        ));
      });

      final total = await _wordCount();
      return SeedImportResult(
        imported: true,
        seedVersion: seedVersion,
        wordCount: total,
      );
    } finally {
      await db.customStatement('DETACH DATABASE seed');
    }
  }

  Future<String?> _readMeta(String schema, String key) async {
    final rows = await db
        .customSelect('SELECT value FROM $schema.meta WHERE key = ?',
            variables: [Variable(key)], readsFrom: {db.meta})
        .get();
    return rows.isEmpty ? null : rows.first.readNullable<String>('value');
  }

  Future<int> _wordCount() async {
    final c = countAll();
    final q = db.selectOnly(db.words)..addColumns([c]);
    return await q.map((row) => row.read(c) ?? 0).getSingle();
  }
}
