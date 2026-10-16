/// 流水线中间模型：一条待入库的种子单词。
class SeedWord {
  SeedWord({
    required this.id,
    required this.language,
    required this.headword,
    required this.meanings,
    required this.difficulty,
    required this.level,
    this.reading,
    this.pos,
    this.phonetic,
    this.freqRank,
    this.tags,
    List<SeedExample> examples = const [],
  }) : examples = List.of(examples);

  final String id;
  final String language; // 'en' | 'ja'
  final String headword;
  final String? reading; // 日语读音
  final String? pos;
  final String? phonetic;
  final List<SeedMeaning> meanings;
  final List<SeedExample> examples;
  final double difficulty; // 1.0-6.0
  final String level; // A1..C2 / N5..N1
  final int? freqRank;
  final Map<String, Object?>? tags;
}

class SeedMeaning {
  const SeedMeaning({required this.lang, required this.def});

  final String lang; // 'zh' | 'en'
  final String def;

  Map<String, String> toJson() => {'lang': lang, 'def': def};
}

class SeedExample {
  const SeedExample({required this.text, this.translation});

  final String text;
  final String? translation;

  Map<String, String?> toJson() => {'text': text, 'translation': translation};
}

const levelOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const jlptOrder = ['N5', 'N4', 'N3', 'N2', 'N1'];

/// CEFR 档位名 → 难度值 1.0-6.0。
double cefrDifficulty(String level) =>
    (levelOrder.indexOf(level) + 1).clamp(1, 6).toDouble();

/// JLPT 档位名 → 难度值 1.0-5.0。
double jlptDifficulty(String level) =>
    (jlptOrder.indexOf(level) + 1).clamp(1, 5).toDouble();
