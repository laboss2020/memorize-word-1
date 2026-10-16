/// words 表 JSON 字段（meanings / examples）的解析。
///
/// meanings: [{"lang":"zh","def":"苹果"}]
/// examples: [{"text":"I eat an apple.","translation":"我吃一个苹果。"}]
library;

import 'dart:convert';

class WordMeaning {
  const WordMeaning({required this.lang, required this.def});

  final String lang;
  final String def;
}

class WordExample {
  const WordExample({required this.text, this.translation});

  final String text;
  final String? translation;
}

List<WordMeaning> parseMeanings(String meaningsJson) {
  try {
    final list = jsonDecode(meaningsJson) as List<dynamic>;
    return [
      for (final e in list)
        WordMeaning(
          lang: (e['lang'] as String?) ?? 'zh',
          def: (e['def'] as String?) ?? '',
        ),
    ].where((m) => m.def.isNotEmpty).toList();
  } catch (_) {
    return const [];
  }
}

List<WordExample> parseExamples(String examplesJson) {
  try {
    final list = jsonDecode(examplesJson) as List<dynamic>;
    return [
      for (final e in list)
        WordExample(
          text: (e['text'] as String?) ?? '',
          translation: e['translation'] as String?,
        ),
    ].where((e) => e.text.isNotEmpty).toList();
  } catch (_) {
    return const [];
  }
}

/// 是否有可用例句（决定填空模式是否可用）。
bool hasExamples(String examplesJson) => parseExamples(examplesJson).isNotEmpty;

/// 拼接释义为单行展示文本（如 "苹果；一种水果"）。
String meaningsToLine(List<WordMeaning> meanings) =>
    meanings.map((m) => m.def).join('；');
