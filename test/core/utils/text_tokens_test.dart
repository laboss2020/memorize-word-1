import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/utils/text_tokens.dart';

void main() {
  group('tokenizeExample（英文）', () {
    final heads = {'i', 'have', 'a', 'apple', 'cat'};

    test('切词 + 标点归入普通 token', () {
      final tokens = tokenizeExample('I have a cat.', 'en', heads);
      expect(tokens.map((t) => t.text).join(), 'I have a cat.');
      final lookups = tokens.where((t) => t.isLookup).map((t) => t.lookupKey);
      expect(lookups, ['i', 'have', 'a', 'cat']);
    });

    test('词库未命中的词不可点', () {
      final tokens = tokenizeExample('A zebra runs.', 'en', heads);
      final zebra = tokens.firstWhere((t) => t.text == 'zebra');
      expect(zebra.isLookup, isFalse);
    });

    test('大小写归一（She → she 需词库含小写）', () {
      final tokens = tokenizeExample('I like her.', 'en', {'i', 'like'});
      final like = tokens.firstWhere((t) => t.text == 'like');
      expect(like.lookupKey, 'like');
    });

    test('撇号词整体保留（缩写不拆开）', () {
      final tokens = tokenizeExample("It's fine.", 'en', {'it'});
      final its = tokens.firstWhere((t) => t.text == "It's");
      expect(its.isLookup, isFalse); // 词库无 it's → 不可点
      final fine = tokens.firstWhere((t) => t.text == 'fine');
      expect(fine.isLookup, isFalse);
    });

    test('空集合全不可点但文本不丢', () {
      final tokens = tokenizeExample('Hello, world!', 'en', {});
      expect(tokens.map((t) => t.text).join(), 'Hello, world!');
      expect(tokens.any((t) => t.isLookup), isFalse);
    });
  });

  group('tokenizeExample（日语贪心最长匹配）', () {
    final heads = {'水', '飲む', 'みず', 'を'};

    test('headword 命中切分，未命中段不可点', () {
      final tokens = tokenizeExample('水を飲む', 'ja', heads);
      final lookups = tokens.where((t) => t.isLookup).map((t) => t.text);
      expect(lookups, ['水', 'を', '飲む']);
      expect(tokens.map((t) => t.text).join(), '水を飲む');
    });

    test('reading 命中（かな文本）', () {
      final tokens = tokenizeExample('みずをのむ', 'ja', heads);
      final lookups = tokens.where((t) => t.isLookup).map((t) => t.text);
      expect(lookups, ['みず', 'を']);
    });

    test('长词优先（贪心最长匹配）', () {
      final heads2 = {'食', '食べる'};
      final tokens = tokenizeExample('食べる', 'ja', heads2);
      expect(tokens.first.isLookup, isTrue);
      expect(tokens.first.text, '食べる'); // 不拆成「食」+「べる」
    });
  });

  group('inflectionCandidates（英文词形还原）', () {
    test('原形在首位', () {
      expect(inflectionCandidates('apple').first, 'apple');
      expect(inflectionCandidates('Apple').first, 'apple');
    });

    test('复数/三单', () {
      expect(inflectionCandidates('cats'), contains('cat'));
      expect(inflectionCandidates('goes'), contains('go'));
      expect(inflectionCandidates('boxes'), contains('box'));
    });

    test('过去式/进行时（含双写与 e 结尾还原）', () {
      expect(inflectionCandidates('stopped'), contains('stop'));
      expect(inflectionCandidates('hated'), contains('hate'));
      expect(inflectionCandidates('used'), contains('use'));
      expect(inflectionCandidates('running'), contains('run'));
      expect(inflectionCandidates('taking'), contains('take'));
      expect(inflectionCandidates('cried'), contains('cry'));
    });

    test('所有候选非空且不含原词重复', () {
      final c = inflectionCandidates('see');
      expect(c, everyElement(isNotEmpty));
      expect(c.toSet().length, c.length);
    });
  });
}
