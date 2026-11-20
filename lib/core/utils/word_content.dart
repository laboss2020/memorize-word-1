/// words 表 JSON 字段（meanings / examples）的解析与按释义语言过滤。
///
/// meanings: [{"lang":"zh","def":"苹果"}]（同一词可带多语言释义）
/// examples: [{"text":"I eat an apple.","translations":{"zh":"我吃一个苹果。"}}]
/// （旧格式 {"translation":"..."} 兼容读取，无 lang 标注）
library;

import 'dart:convert';

class WordMeaning {
  const WordMeaning({required this.lang, required this.def});

  final String lang;
  final String def;
}

class WordExample {
  const WordExample({required this.text, this.translations = const {}});

  final String text;

  /// 各语言翻译（lang → text），如 {'zh': '...', 'en': '...'}。
  final Map<String, String> translations;
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
          translations: _parseTranslations(e),
        ),
    ].where((e) => e.text.isNotEmpty).toList();
  } catch (_) {
    return const [];
  }
}

Map<String, String> _parseTranslations(Map<String, dynamic> e) {
  final out = <String, String>{};
  // 新格式：translations 数组 [{"lang":"zh","text":"..."}]
  final list = e['translations'];
  if (list is List<dynamic>) {
    for (final t in list) {
      if (t is Map) {
        final lang = t['lang'] as String?;
        final text = (t['text'] as String?)?.trim() ?? '';
        if (lang != null && text.isNotEmpty) out[lang] = text;
      }
    }
  }
  // 新格式变体：translations 对象 {"zh":"..."}
  if (list is Map) {
    list.forEach((lang, text) {
      final t = (text as String?)?.trim() ?? '';
      if (t.isNotEmpty) out[lang as String] = t;
    });
  }
  // 旧格式：translation 单字符串（无 lang；日语词历史数据为英文翻译）
  final legacy = (e['translation'] as String?)?.trim() ?? '';
  if (legacy.isNotEmpty) out.putIfAbsent('zh', () => legacy);
  return out;
}

/// 是否有可用例句（决定填空模式是否可用）。
bool hasExamples(String examplesJson) => parseExamples(examplesJson).isNotEmpty;

/// 学习语言的辅助释义语言：学日语→英文，学英语→日文。
String altGlossLang(String learningLang) => learningLang == 'ja' ? 'en' : 'ja';

/// 按释义语言模式过滤释义。
///
/// [glossMode]：'zh'=中文；'alt'=辅助语言；'both'=中文+辅助（中文在前）。
/// 所选语言无数据时回退显示全部（避免空白）。
List<WordMeaning> selectMeanings(
  String meaningsJson, {
  required String glossMode,
  required String learningLang,
}) {
  final all = parseMeanings(meaningsJson);
  final alt = altGlossLang(learningLang);
  final wanted = switch (glossMode) {
    'alt' => [alt],
    'both' => ['zh', alt],
    _ => ['zh'],
  };
  final picked = [for (final lang in wanted) ...all.where((m) => m.lang == lang)];
  return picked.isNotEmpty ? picked : all;
}

/// 拼接释义为单行展示文本（如 "苹果；一种水果"）。
String meaningsToLine(List<WordMeaning> meanings) =>
    meanings.map((m) => m.def).join('；');

/// 便捷：按设置过滤后拼接为单行释义。
String meaningsLine(
  String meaningsJson, {
  required String glossMode,
  required String learningLang,
}) =>
    meaningsToLine(selectMeanings(meaningsJson,
        glossMode: glossMode, learningLang: learningLang));

/// 按释义语言模式取例句翻译（'both' 时优先中文，缺失回退辅助语言/任意）。
String? translationFor(
  WordExample example, {
  required String glossMode,
  required String learningLang,
}) {
  final tr = example.translations;
  if (tr.isEmpty) return null;
  final alt = altGlossLang(learningLang);
  return switch (glossMode) {
    'alt' => tr[alt] ?? tr.values.first,
    'both' => tr['zh'] ?? tr[alt] ?? tr.values.first,
    _ => tr['zh'] ?? tr.values.first,
  };
}
