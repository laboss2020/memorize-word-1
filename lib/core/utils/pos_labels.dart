/// 词性标注本地化：把词库 pos 串（'/' 分隔的词性码）按释义语言转为可读标签。
///
/// 词性码集大体通用（en 为 ECDICT 码：n/v/adj…；ja 为 JMdict 码：
/// v5u/adj-i…），按释义语言查表即可，无需区分学习语言。
/// 未知代码原样保留；glossMode 非 zh/en/ja 时回退中文。
library;

String posLabel(String pos, String glossMode) {
  final labels = <String>[];
  for (final raw in pos.split('/')) {
    final t = raw.trim();
    if (t.isEmpty) continue;
    labels.add(_label(t, glossMode));
  }
  return labels.isEmpty ? pos : labels.join('·');
}

String _label(String token, String glossMode) {
  final table = switch (glossMode) {
    'en' => _en,
    'ja' => _ja,
    _ => _zh,
  };
  return table[token] ?? _v5(token, glossMode) ?? token;
}

/// 五段动词族（v5u/v5k/v5r…）：前缀判断，免去逐个列举。
String? _v5(String token, String glossMode) {
  if (!token.startsWith('v5')) return null;
  return switch (glossMode) {
    'en' => 'godan verb',
    'ja' => '五段動詞',
    _ => '五段动词',
  };
}

const _zh = {
  'n': '名词',
  'v': '动词',
  'vi': '不及物动词',
  'vt': '及物动词',
  'adj': '形容词',
  'adv': '副词',
  'pron': '代词',
  'num': '数词',
  'prep': '介词',
  'art': '冠词',
  'aux': '助动词',
  'conj': '连词',
  'int': '叹词',
  'exp': '惯用语',
  'pref': '前缀',
  'suf': '后缀',
  'n-pref': '名词前缀',
  'n-suf': '名词后缀',
  'ctr': '量词',
  'pn': '代词',
  'prt': '助词',
  'v1': '一段动词',
  'v1-s': '一段动词',
  'vk': 'カ变动词',
  'vs': 'サ变动词',
  'vs-i': 'サ变动词',
  'vs-s': 'サ变动词',
  'vz': 'サ变动词',
  'adj-i': 'イ形容词',
  'adj-ix': 'イ形容词',
  'adj-na': 'ナ形容词',
  'adj-nari': 'ナ形容词',
  'adj-t': 'ナ形容词',
  'adj-no': 'ノ形容词',
  'adj-f': '形容词',
  'adj-pn': '连体词',
  'adv-to': '副词',
  'aux-v': '助动词',
  'aux-adj': '助形容词',
};

const _en = {
  'n': 'noun',
  'v': 'verb',
  'vi': 'intransitive verb',
  'vt': 'transitive verb',
  'adj': 'adjective',
  'adv': 'adverb',
  'pron': 'pronoun',
  'num': 'numeral',
  'prep': 'preposition',
  'art': 'article',
  'aux': 'auxiliary verb',
  'conj': 'conjunction',
  'int': 'interjection',
  'exp': 'expression',
  'pref': 'prefix',
  'suf': 'suffix',
  'n-pref': 'noun prefix',
  'n-suf': 'noun suffix',
  'ctr': 'counter',
  'pn': 'pronoun',
  'prt': 'particle',
  'v1': 'ichidan verb',
  'v1-s': 'ichidan verb',
  'vk': 'kuru verb',
  'vs': 'suru verb',
  'vs-i': 'suru verb',
  'vs-s': 'suru verb',
  'vz': 'suru verb',
  'adj-i': 'i-adjective',
  'adj-ix': 'i-adjective',
  'adj-na': 'na-adjective',
  'adj-nari': 'na-adjective',
  'adj-t': 'na-adjective',
  'adj-no': 'no-adjective',
  'adj-f': 'adjective',
  'adj-pn': 'pre-noun adjective',
  'adv-to': 'adverb',
  'aux-v': 'auxiliary verb',
  'aux-adj': 'auxiliary adjective',
};

const _ja = {
  'n': '名詞',
  'v': '動詞',
  'vi': '自動詞',
  'vt': '他動詞',
  'adj': '形容詞',
  'adv': '副詞',
  'pron': '代名詞',
  'num': '数詞',
  'prep': '前置詞',
  'art': '冠詞',
  'aux': '助動詞',
  'conj': '接続詞',
  'int': '感動詞',
  'exp': '慣用句',
  'pref': '接頭辞',
  'suf': '接尾辞',
  'n-pref': '名詞接頭辞',
  'n-suf': '名詞接尾辞',
  'ctr': '助数詞',
  'pn': '代名詞',
  'prt': '助詞',
  'v1': '一段動詞',
  'v1-s': '一段動詞',
  'vk': 'カ変動詞',
  'vs': 'サ変動詞',
  'vs-i': 'サ変動詞',
  'vs-s': 'サ変動詞',
  'vz': 'サ変動詞',
  'adj-i': 'イ形容詞',
  'adj-ix': 'イ形容詞',
  'adj-na': 'ナ形容詞',
  'adj-nari': 'ナ形容詞',
  'adj-t': 'ナ形容詞',
  'adj-no': 'ノ形容詞',
  'adj-f': '形容詞',
  'adj-pn': '連体詞',
  'adv-to': '副詞',
  'aux-v': '助動詞',
  'aux-adj': '助形容詞',
};
