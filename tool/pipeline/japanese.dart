import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'model.dart';

/// 日语种子数据：OpenJLPT（JMdict 词条 + JLPT 分级 + Tatoeba 例句，CC-BY-SA-4.0）。
///
/// 释义为英文（OpenJLPT 携带 JMdict 英文 gloss；中文释义二期补齐，UI 需标注来源语言）。
class JapanesePipeline {
  JapanesePipeline({required this.openjlptDir});

  final String openjlptDir; // 含 n5.json..n1.json 的目录

  static const _uuid = Uuid();
  static const _ns = 'f2b4a1d0-8f6e-4a8e-9c1d-3e5a7b9c1d2f';

  Future<List<SeedWord>> build() async {
    // level → (word|reading 去重后) 的种子词，跨级重复取最低级别。
    final byKey = <String, SeedWord>{};
    final rankCounter = <String, int>{};

    for (final level in jlptOrder) {
      final file = File('$openjlptDir/${level.toLowerCase()}.json');
      if (!file.existsSync()) {
        stderr.writeln('WARN missing $file');
        continue;
      }
      final List entries;
      try {
        entries = jsonDecode(await file.readAsString()) as List;
      } catch (e) {
        stderr.writeln('ERROR parsing $file: $e');
        continue;
      }
      for (final e in entries) {
        final word = (e['word'] as String?)?.trim() ?? '';
        final reading = ((e['reading'] as String?) ?? '').trim();
        if (word.isEmpty && reading.isEmpty) continue;
        final headword = word.isEmpty ? reading : word;
        final posKey = ((e['pos'] as List?) ?? const [])
            .map((p) => (p as String).trim())
            .where((p) => p.isNotEmpty)
            .join('/');
        // 数据库 UNIQUE(language, headword, pos)：同词同词性只保留最低级别的一条。
        final key = '$headword|$posKey';
        final rank = rankCounter.update(level, (v) => v + 1, ifAbsent: () => 1);

        final existing = byKey[key];
        if (existing != null) continue; // 低级别已收录

        final meanings = ((e['meanings'] as List?) ?? const [])
            .map((m) => (m as String).trim())
            .where((m) => m.isNotEmpty)
            .toList();
        if (meanings.isEmpty) continue;

        final examples = ((e['examples'] as List?) ?? const [])
            .map((x) => SeedExample(
                  text: ((x['ja'] as String?) ?? '').trim(),
                  translation: ((x['en'] as String?) ?? '').trim().isEmpty
                      ? null
                      : (x['en'] as String).trim(),
                ))
            .where((x) => x.text.isNotEmpty)
            .take(3)
            .toList();

        final pos = ((e['pos'] as List?) ?? const [])
            .map((p) => (p as String).trim())
            .where((p) => p.isNotEmpty)
            .join('/');

        byKey[key] = SeedWord(
          id: _uuid.v5(_ns, 'ja|$headword|$pos'),
          language: 'ja',
          headword: headword,
          reading: reading.isEmpty ? null : reading,
          pos: pos.isEmpty ? null : pos,
          meanings: [SeedMeaning(lang: 'en', def: meanings.join('；'))],
          examples: examples,
          difficulty: jlptDifficulty(level),
          level: level,
          freqRank: rank,
        );
      }
    }

    final words = byKey.values.toList();
    stdout.writeln('Japanese words: ${words.length}');
    return words;
  }
}
