import 'dart:convert';
import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

import 'model.dart';

/// 生成 assets/db/seed_v1.sqlite。
///
/// 表结构与 lib/core/db/tables 中的 drift 定义保持一致（列名/类型/约束），
/// App 端种子导入按列名 INSERT OR IGNORE ... SELECT。
/// sqlite3 通过 native assets 自动提供（sqlite3 3.x 的 build hook）。
class SeedWriter {
  SeedWriter({required this.outputPath, this.seedVersion = 1});

  final String outputPath;
  final int seedVersion;

  void write({
    required List<SeedWord> english,
    required List<SeedWord> japanese,
  }) {
    final file = File(outputPath);
    if (file.existsSync()) file.deleteSync();

    final db = sqlite3.open(outputPath);
    try {
      db.execute('PRAGMA journal_mode = OFF');

      db.execute('''
        CREATE TABLE words (
          id TEXT NOT NULL PRIMARY KEY,
          language TEXT NOT NULL,
          headword TEXT NOT NULL,
          reading TEXT NULL,
          pos TEXT NULL,
          phonetic TEXT NULL,
          meanings TEXT NOT NULL,
          examples TEXT NOT NULL,
          difficulty REAL NOT NULL,
          level TEXT NOT NULL,
          freq_rank INTEGER NULL,
          tags TEXT NULL,
          UNIQUE (language, headword, pos)
        )''');
      db.execute('CREATE INDEX idx_words_lang_diff ON words (language, difficulty)');
      db.execute('CREATE INDEX idx_words_lang_headword ON words (language, headword)');
      db.execute('''
        CREATE TABLE decks (
          id TEXT NOT NULL PRIMARY KEY,
          language TEXT NOT NULL,
          name TEXT NOT NULL,
          sort_order INTEGER NOT NULL
        )''');
      db.execute('''
        CREATE TABLE deck_words (
          deck_id TEXT NOT NULL,
          word_id TEXT NOT NULL,
          sort_order INTEGER NOT NULL,
          PRIMARY KEY (deck_id, word_id)
        )''');
      db.execute('CREATE TABLE meta (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)');

      final all = [...english, ...japanese];
      db.execute('BEGIN');
      final stmt = db.prepare(
        'INSERT INTO words (id, language, headword, reading, pos, phonetic, '
        'meanings, examples, difficulty, level, freq_rank, tags) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
      try {
        for (final w in all) {
          stmt.execute([
            w.id,
            w.language,
            w.headword,
            w.reading,
            w.pos,
            w.phonetic,
            jsonEncode(w.meanings.map((m) => m.toJson()).toList()),
            jsonEncode(w.examples.map((e) => e.toJson()).toList()),
            w.difficulty,
            w.level,
            w.freqRank,
            w.tags == null ? null : jsonEncode(w.tags),
          ]);
        }
      } finally {
        stmt.close();
      }

      // 词书：英语 CEFR 六级 / 日语 JLPT 五级。
      final deckStmt = db.prepare(
          'INSERT INTO decks (id, language, name, sort_order) VALUES (?, ?, ?, ?)');
      final linkStmt = db.prepare(
          'INSERT INTO deck_words (deck_id, word_id, sort_order) VALUES (?, ?, ?)');
      try {
        final decks = <(String, String, String, int)>[
          for (var i = 0; i < levelOrder.length; i++)
            (
              'en-cefr-${levelOrder[i].toLowerCase()}',
              'en',
              '英语 ${levelOrder[i]}',
              i
            ),
          for (var i = 0; i < jlptOrder.length; i++)
            ('ja-jlpt-${jlptOrder[i].toLowerCase()}', 'ja', '日语 ${jlptOrder[i]}', i),
        ];
        final freqOfWord = {
          for (final w in all) w.id: w.freqRank ?? 1 << 30,
        };
        for (final (id, lang, name, sort) in decks) {
          deckStmt.execute([id, lang, name, sort]);
        }
        final perDeck = <String, List<SeedWord>>{};
        for (final w in all) {
          final deckId = w.language == 'en'
              ? 'en-cefr-${w.level.toLowerCase()}'
              : 'ja-jlpt-${w.level.toLowerCase()}';
          perDeck.putIfAbsent(deckId, () => []).add(w);
        }
        for (final e in perDeck.entries) {
          final wordsInDeck = e.value
            ..sort((a, b) => (freqOfWord[a.id] ?? 0).compareTo(freqOfWord[b.id] ?? 0));
          for (var i = 0; i < wordsInDeck.length; i++) {
            linkStmt.execute([e.key, wordsInDeck[i].id, i]);
          }
        }
        // levelOfWord 供按档位校验使用（当前仅统计报告）。
      } finally {
        deckStmt.close();
        linkStmt.close();
      }

      db.execute(
          "INSERT INTO meta (key, value) VALUES ('seed_version', '$seedVersion')");
      db.execute('COMMIT');
      db.execute('VACUUM');

      _report(db, all);
    } finally {
      db.close();
    }
  }

  void _report(Database db, List<SeedWord> all) {
    final sizeMb = (File(outputPath).lengthSync() / 1024 / 1024).toStringAsFixed(1);
    stdout.writeln('=== seed report ===');
    stdout.writeln('file: $outputPath ($sizeMb MB)');
    stdout.writeln('seed_version: $seedVersion');
    for (final lang in ['en', 'ja']) {
      final n = all.where((w) => w.language == lang).length;
      final withEx = all
          .where((w) => w.language == lang && w.examples.isNotEmpty)
          .length;
      final byLevel = <String, int>{};
      for (final w in all.where((w) => w.language == lang)) {
        byLevel[w.level] = (byLevel[w.level] ?? 0) + 1;
      }
      stdout.writeln('$lang: $n words, examples on $withEx (${(withEx * 100 / n).toStringAsFixed(0)}%)');
      final levels = byLevel.keys.toList()..sort();
      stdout.writeln('  levels: ${levels.map((l) => '$l=${byLevel[l]}').join(' ')}');
    }
  }
}
