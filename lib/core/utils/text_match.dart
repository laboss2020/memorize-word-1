/// 听写/填空的文本比对工具：归一化、编辑距离、例句挖空。
library;

import '../../core/db/app_database.dart' show Word;
import 'word_content.dart';

/// Levenshtein 编辑距离（小文本够用）。
int editDistance(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  var cur = List<int>.filled(b.length + 1, 0);
  for (var i = 0; i < a.length; i++) {
    cur[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
      cur[j + 1] = [
        cur[j] + 1,
        prev[j + 1] + 1,
        prev[j] + cost,
      ].reduce((x, y) => x < y ? x : y);
    }
    final t = prev;
    prev = cur;
    cur = t; // 复用缓冲区，下一轮覆盖
  }
  return prev[b.length];
}

/// 拼写比对归一化：英语小写去空白；日语假名归一（罗马字→假名、片假名→平假名）。
String normalizeSpelling(String input, String language) {
  final trimmed = input.trim();
  if (language == 'ja') {
    return katakanaToHiragana(romajiToKana(trimmed));
  }
  return trimmed.toLowerCase();
}

/// 片假名 → 平假名（0x30A1-0x30F6 区间平移 0x60）。
String katakanaToHiragana(String s) {
  final buf = StringBuffer();
  for (final ch in s.runes) {
    if (ch >= 0x30A1 && ch <= 0x30F6) {
      buf.writeCharCode(ch - 0x60);
    } else {
      buf.writeCharCode(ch);
    }
  }
  return buf.toString();
}

/// 常见罗马字 → 平假名（覆盖五十音 + 常见拗音；不完美但满足无日文输入法兜底）。
const _romajiDigraphs = {
  'kya': 'きゃ', 'kyu': 'きゅ', 'kyo': 'きょ',
  'sha': 'しゃ', 'shu': 'しゅ', 'sho': 'しょ',
  'cha': 'ちゃ', 'chu': 'ちゅ', 'cho': 'ちょ',
  'nya': 'にゃ', 'nyu': 'にゅ', 'nyo': 'にょ',
  'hya': 'ひゃ', 'hyu': 'ひゅ', 'hyo': 'ひょ',
  'mya': 'みゃ', 'myu': 'みゅ', 'myo': 'みょ',
  'rya': 'りゃ', 'ryu': 'りゅ', 'ryo': 'りょ',
  'gya': 'ぎゃ', 'gyu': 'ぎゅ', 'gyo': 'ぎょ',
  'ja': 'じゃ', 'ju': 'じゅ', 'jo': 'じょ',
  'bya': 'びゃ', 'byu': 'びゅ', 'byo': 'びょ',
  'pya': 'ぴゃ', 'pyu': 'ぴゅ', 'pyo': 'ぴょ',
  'fya': 'ふゃ',
  'jya': 'じゃ', 'jyu': 'じゅ', 'jyo': 'じょ',
  'shi': 'し', 'chi': 'ち', 'tsu': 'つ',
  'she': 'しぇ', 'che': 'ちぇ', 'tsa': 'つぁ', 'tso': 'つぉ',
};

const _romajiSingles = {
  'a': 'あ', 'i': 'い', 'u': 'う', 'e': 'え', 'o': 'お',
  'ka': 'か', 'ki': 'き', 'ku': 'く', 'ke': 'け', 'ko': 'こ',
  'sa': 'さ', 'su': 'す', 'se': 'せ', 'so': 'そ',
  'ta': 'た', 'te': 'て', 'to': 'と',
  'na': 'な', 'ni': 'に', 'nu': 'ぬ', 'ne': 'ね', 'no': 'の',
  'ha': 'は', 'hi': 'ひ', 'fu': 'ふ', 'he': 'へ', 'ho': 'ほ',
  'ma': 'ま', 'mi': 'み', 'mu': 'む', 'me': 'め', 'mo': 'も',
  'ya': 'や', 'yu': 'ゆ', 'yo': 'よ',
  'ra': 'ら', 'ri': 'り', 'ru': 'る', 're': 'れ', 'ro': 'ろ',
  'wa': 'わ', 'wi': 'ゐ', 'we': 'ゑ', 'wo': 'を',
  'ga': 'が', 'gi': 'ぎ', 'gu': 'ぐ', 'ge': 'げ', 'go': 'ご',
  'za': 'ざ', 'zi': 'じ', 'ji': 'じ', 'zu': 'ず', 'ze': 'ぜ', 'zo': 'ぞ',
  'si': 'し', 'ti': 'ち', 'tu': 'つ', 'hu': 'ふ',
  'da': 'だ', 'di': 'ぢ', 'du': 'づ', 'de': 'で', 'do': 'ど',
  'ba': 'ば', 'bi': 'び', 'bu': 'ぶ', 'be': 'べ', 'bo': 'ぼ',
  'pa': 'ぱ', 'pi': 'ぴ', 'pu': 'ぷ', 'pe': 'ぺ', 'po': 'ぽ',
  'nn': 'ん', "n'": 'ん',
};

String romajiToKana(String input) {
  final lower = input.toLowerCase();
  final buf = StringBuffer();
  var i = 0;
  while (i < lower.length) {
    // 双子音促音（kk, tt...）→ っ + 后续
    if (i + 1 < lower.length &&
        lower[i] == lower[i + 1] &&
        lower[i] != 'n' &&
        _isConsonant(lower[i])) {
      buf.write('っ');
      i++;
      continue;
    }
    var matched = false;
    // 三字符拗音 → 双字符 → 单字符
    for (final len in const [3, 2, 1]) {
      if (i + len > lower.length) continue;
      final piece = lower.substring(i, i + len);
      // IME 式前瞻：nn 后跟元音时，第一个 n 是拨音ん，第二个 n 与元音组成下一拍
      // （konnitiha → こんにちは；konna → こんな 不受影响）
      if (piece == 'nn' &&
          i + 2 < lower.length &&
          'aiueo'.contains(lower[i + 2])) {
        continue; // 落到单字符分支，由兜底逻辑输出ん
      }
      final kana = _romajiDigraphs[piece] ?? _romajiSingles[piece];
      if (kana != null) {
        buf.write(kana);
        i += len;
        matched = true;
        break;
      }
    }
    if (!matched) {
      // 单独 n / 长音符
      if (lower[i] == 'n') {
        buf.write('ん');
        i++;
      } else if (lower[i] == '-') {
        buf.write('ー');
        i++;
      } else {
        buf.write(lower[i]);
        i++;
      }
    }
  }
  return buf.toString();
}

bool _isConsonant(String ch) =>
    'bcdfghjklmnpqrstvwxyz'.contains(ch);

/// 填空题构造：在例句中定位词条并挖空。
/// 返回 (sentence 挖空句, answer 被挖掉的词形, translation)；无法定位返回 null。
({String sentence, String answer, String? translation})? buildCloze(Word word) {
  final examples = parseExamples(word.examples);
  for (final e in examples) {
    final answer = _locateAndBlank(e.text, word.headword, word.language);
    if (answer != null) {
      return (sentence: answer.$1, answer: answer.$2, translation: e.translation);
    }
  }
  return null;
}

/// 在句中查找目标词（英语按整词/小写、日语按子串），挖空后返回（挖空句, 答案）。
(String, String)? _locateAndBlank(
    String sentence, String headword, String language) {
  if (language == 'ja') {
    final idx = sentence.indexOf(headword);
    if (idx < 0) return null;
    return (
      sentence.replaceRange(idx, idx + headword.length, '＿＿'),
      headword,
    );
  }
  // 英语：整词匹配（大小写不敏感），保留原词形作为答案。
  final pattern = RegExp('\\b${RegExp.escape(headword)}\\b', caseSensitive: false);
  final m = pattern.firstMatch(sentence);
  if (m == null) return null;
  return (
    sentence.replaceRange(m.start, m.end, '＿＿'),
    sentence.substring(m.start, m.end),
  );
}
