import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';

import 'model.dart';

/// 英语种子数据：ECDICT（词/音标/中文释义/频率）+ CEFR 分级 + Tatoeba CC0 例句。
class EnglishPipeline {
  EnglishPipeline({
    required this.ecdictCsv,
    required this.cefrWordsCsv,
    required this.cefrWordPosCsv,
    required this.tatoebaCsv,
    this.maxWords = 20000,
    this.maxExamplesPerWord = 3,
  });

  final String ecdictCsv;
  final String cefrWordsCsv;
  final String cefrWordPosCsv;
  final String tatoebaCsv;
  final int maxWords;
  final int maxExamplesPerWord;

  static const _uuid = Uuid();
  // 自定义 namespace（uuid5），固定常量保证跨设备一致。
  static const _ns = 'f2b4a1d0-8f6e-4a8e-9c1d-3e5a7b9c1d2f';

  Future<List<SeedWord>> build() async {
    // 1. ECDICT → 按频率截断的候选词。
    final rows = await _parseEcdict();
    stdout.writeln('ECDICT rows with rank & Chinese: ${rows.length}');

    final cefr = await _loadCefrLevels();
    final heads = rows.map((r) => r.word.toLowerCase()).toSet();

    // 2. Tatoeba 例句索引（只为我们选中的词找例句，短句优先）。
    final wordIndex = await _buildTatoebaIndex(heads);

    // 3. 组装种子词。
    final words = <SeedWord>[];
    final seen = <String>{};
    for (final r in rows.take(maxWords)) {
      final head = r.word.toLowerCase();
      if (!seen.add(head)) continue; // 同形（大小写）只保留一条

      final cefrLevel = _lookupLevel(cefr, head, r.exchange);
      final String level;
      if (cefrLevel != null) {
        level = cefrLevel;
      } else {
        final rank = r.rank;
        level = switch (rank) {
          <= 500 => 'A1',
          <= 3000 => 'A2',
          <= 8000 => 'B1',
          <= 15000 => 'B2',
          _ => 'C1',
        };
      }

      words.add(SeedWord(
        id: _uuid.v5(_ns, 'en|$head|${r.pos ?? ''}'),
        language: 'en',
        headword: r.word,
        phonetic: r.phonetic,
        pos: r.pos,
        meanings: [SeedMeaning(lang: 'zh', def: r.translation)],
        examples: wordIndex[head] ?? const [],
        difficulty: cefrDifficulty(level),
        level: level,
        freqRank: r.rank,
        tags: {
          if (r.exchange != null) 'exchange': r.exchange,
          if (r.collins != null) 'collins': r.collins,
          if (r.oxford != null) 'oxford': r.oxford,
        },
      ));
    }
    return words;
  }

  // ---- ECDICT ----

  Future<List<_EcdictRow>> _parseEcdict() async {
    final converter = const CsvDecoder();
    final out = <_EcdictRow>[];
    var first = true;
    await for (final row
        in File(ecdictCsv).openRead().transform(utf8.decoder).transform(converter)) {
      if (first) {
        first = false;
        continue;
      }
      if (row.length < 11) continue;
      final word = (row[0] as String).trim();
      if (word.isEmpty || word.contains(' ')) continue; // 只要单个词
      final translation = (row[3] as String).trim();
      if (!translation.contains(RegExp(r'[一-鿿]'))) continue; // 需有中文释义
      final frq = int.tryParse((row[9] as String).trim()) ?? 0;
      final bnc = int.tryParse((row[8] as String).trim()) ?? 0;
      final rank = frq > 0 ? frq : (bnc > 0 ? bnc : 0);
      if (rank <= 0) continue;
      final exchange = (row[10] as String).trim();
      out.add(_EcdictRow(
        word: word,
        phonetic: (row[1] as String).trim(),
        translation: translation,
        pos: _extractPos(translation),
        collins: int.tryParse((row[5] as String).trim()),
        oxford: int.tryParse((row[6] as String).trim()),
        rank: rank,
        exchange: exchange.isEmpty ? null : exchange,
      ));
    }
    out.sort((a, b) => a.rank.compareTo(b.rank));
    return out;
  }

  /// 从中文释义提取词性标记（释义行的 "n. " 前缀），如 "n./v."。
  /// ECDICT translation 内的多行以字面 `\n`（反斜杠+n）分隔。
  String? _extractPos(String translation) {
    final found = <String>[];
    final re = RegExp(r'(?:(?<=^)|(?<=\\n)|(?<= ))(n|vi|vt|adj|adv|prep|conj|pron|art|int|num)\.');
    for (final m in re.allMatches(translation)) {
      final tag = m.group(1)!;
      final norm = switch (tag) {
        'vi' || 'vt' => 'v',
        _ => tag,
      };
      if (!found.contains(norm)) found.add(norm);
      if (found.length >= 3) break;
    }
    return found.isEmpty ? null : found.join('/');
  }

  // ---- CEFR ----

  /// word(小写) → 最低 CEFR 档名。
  Future<Map<String, String>> _loadCefrLevels() async {
    stdout.writeln('loading CEFR dataset...');
    // words.csv: word_id, word, stem_word_id
    final converter = const CsvDecoder();
    final wordToId = <String, String>{};
    await for (final row
        in File(cefrWordsCsv).openRead().transform(utf8.decoder).transform(converter)) {
      if ((row[0] as String) == 'word_id') continue;
      wordToId[(row[1] as String).toLowerCase()] = row[0] as String;
    }
    // word_pos.csv: word_pos_id, word_id, pos_tag_id, lemma_word_id, freq, level
    // 一个词取其各词性下的最低 level。
    final minLevel = <String, int>{}; // word_id -> level
    await for (final row
        in File(cefrWordPosCsv).openRead().transform(utf8.decoder).transform(converter)) {
      if ((row[0] as String) == 'word_pos_id') continue;
      final wordId = row[1] as String;
      final level = int.tryParse((row[5] as String).trim());
      if (level == null || level < 1 || level > 6) continue;
      final cur = minLevel[wordId];
      if (cur == null || level < cur) minLevel[wordId] = level;
    }
    final byWord = <String, String>{};
    for (final e in wordToId.entries) {
      final lvl = minLevel[e.value];
      if (lvl != null) byWord[e.key] = levelOrder[lvl - 1];
    }
    return byWord;
  }

  String? _lookupLevel(Map<String, String> cefr, String head, String? exchange) {
    final direct = cefr[head];
    if (direct != null) return direct;
    // 兜底：通过屈折形式找词表中对应档位（words.csv 也含屈折形式）。
    if (exchange != null) {
      for (final part in exchange.split('/')) {
        final form = part.split(':').last.toLowerCase();
        final lv = cefr[form];
        if (lv != null) return lv;
      }
    }
    return null;
  }

  // ---- Tatoeba ----

  /// 词(小写) → 例句列表（句子按长度升序逐个分配，短句优先）。
  Future<Map<String, List<SeedExample>>> _buildTatoebaIndex(Set<String> heads) async {
    stdout.writeln('indexing Tatoeba CC0 sentences...');
    final index = <String, List<SeedExample>>{};
    final remaining = Set.of(heads);
    final sentences = <(int, String)>[];
    await for (final line in File(tatoebaCsv)
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      final parts = line.split('\t');
      if (parts.length < 3 || parts[1] != 'eng') continue;
      final tokens = _tokenize(parts[2]);
      if (tokens == null) continue;
      sentences.add((tokens.length, parts[2]));
    }
    sentences.sort((a, b) => a.$1.compareTo(b.$1));

    for (final (_, text) in sentences) {
      final tokens = _tokenize(text)!;
      for (final t in tokens) {
        if (remaining.remove(t)) {
          (index[t] ??= []).add(SeedExample(text: text));
        } else {
          // 已有例句的词也可能出现在本句中，但不重复添加。
        }
      }
      if (remaining.isEmpty) break;
    }
    stdout.writeln('example coverage: ${index.length} / ${heads.length} words');
    return index;
  }

  /// 句长 6-25 个词、仅含拉丁字母的句子；返回小写 token 列表，否则 null。
  List<String>? _tokenize(String text) {
    if (text.length < 10 || text.length > 140) return null;
    final cleaned = text.toLowerCase().replaceAll(RegExp(r"[^a-z' -]"), ' ');
    final tokens = cleaned.split(RegExp(r'\s+')).where((t) => t.length >= 2).toList();
    if (tokens.length < 6 || tokens.length > 25) return null;
    return tokens;
  }
}

class _EcdictRow {
  const _EcdictRow({
    required this.word,
    required this.translation,
    required this.rank,
    this.phonetic,
    this.pos,
    this.collins,
    this.oxford,
    this.exchange,
  });

  final String word;
  final String translation;
  final int rank;
  final String? phonetic;
  final String? pos;
  final int? collins;
  final int? oxford;
  final String? exchange;
}
