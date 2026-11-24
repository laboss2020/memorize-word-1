/// 例句分词：为「点词查字典」把例句切成可查/不可查的 token 序列。
///
/// 英文按字母词切分（标点归入普通文本）；日语无空格，
/// 对词库词形集合做贪心最长匹配，命中段可查、其余原样输出。
library;

/// 例句中的一个片段。[lookupKey] 非空表示该片段可在词库中查询。
class ExampleToken {
  const ExampleToken(this.text, {this.lookupKey});

  final String text;
  final String? lookupKey;

  bool get isLookup => lookupKey != null;
}

/// 英文词形还原候选（查词兜底）：原形优先，再试常见规则变形。
/// 不规则变形（went/gone 等）不在覆盖范围。
List<String> inflectionCandidates(String word) {
  final w = word.toLowerCase();
  final candidates = <String>[w];
  void add(String c) {
    if (c.length >= 2 && !candidates.contains(c)) candidates.add(c);
  }

  if (w.endsWith("'s") || w.endsWith("’s")) {
    add(w.substring(0, w.length - 2));
  }
  if (w.endsWith('ies') && w.length > 4) {
    add('${w.substring(0, w.length - 3)}y');
  }
  if (w.endsWith('ied') && w.length > 4) {
    add('${w.substring(0, w.length - 3)}y'); // cried→cry
  }
  if (w.endsWith('es') && w.length > 3) {
    add(w.substring(0, w.length - 2));
    add(w.substring(0, w.length - 1)); // 去 s（如 goes→go）
  }
  if (w.endsWith('s') && !w.endsWith('ss') && w.length > 2) {
    add(w.substring(0, w.length - 1));
  }
  if (w.endsWith('ing') && w.length > 5) {
    final stem = w.substring(0, w.length - 3);
    add(stem);
    add('${stem}e'); // taking→take
    add(stem.substring(0, stem.length - 1)); // running→runn→run（双写）
  }
  if (w.endsWith('ed') && w.length > 3) {
    final stem = w.substring(0, w.length - 2);
    add(stem);
    add('${stem}e'); // hated→hate
    add(stem.substring(0, stem.length - 1)); // stopped→stopp→stop（双写）
    add(w.substring(0, w.length - 1)); // used→use
  }
  if (w.endsWith('d') && !w.endsWith('ed') && w.length > 3) {
    add(w.substring(0, w.length - 1)); // used→use
  }
  return candidates;
}

final _enWord = RegExp(r"[A-Za-z’']+");

/// 把 [text] 切成 token 序列。[knownHeads] 为该语言词库的词形集合
/// （en：小写 headword；ja：headword + reading）。
List<ExampleToken> tokenizeExample(
    String text, String language, Set<String> knownHeads) {
  if (language == 'ja') return _tokenizeJa(text, knownHeads);
  final tokens = <ExampleToken>[];
  var last = 0;
  for (final m in _enWord.allMatches(text)) {
    if (m.start > last) {
      tokens.add(ExampleToken(text.substring(last, m.start)));
    }
    final word = m.group(0)!;
    final key = word.toLowerCase().replaceAll('’', "'");
    tokens.add(ExampleToken(word,
        lookupKey: knownHeads.contains(key) ? key : null));
    last = m.end;
  }
  if (last < text.length) tokens.add(ExampleToken(text.substring(last)));
  return tokens;
}

/// 日语：从每个位置起做贪心最长匹配（最长 [maxLen] 字符），
/// 命中 knownHeads 的段成为可查 token。
List<ExampleToken> _tokenizeJa(String text, Set<String> knownHeads) {
  const maxLen = 12;
  final tokens = <ExampleToken>[];
  final buf = StringBuffer();
  var i = 0;
  void flush() {
    if (buf.isNotEmpty) {
      tokens.add(ExampleToken(buf.toString()));
      buf.clear();
    }
  }

  while (i < text.length) {
    String? hit;
    for (var len = maxLen; len >= 1; len--) {
      if (i + len > text.length) continue;
      final sub = text.substring(i, i + len);
      if (knownHeads.contains(sub)) {
        hit = sub;
        break;
      }
    }
    if (hit == null) {
      buf.write(text[i]);
      i++;
    } else {
      flush();
      tokens.add(ExampleToken(hit, lookupKey: hit));
      i += hit.length;
    }
  }
  flush();
  return tokens;
}
