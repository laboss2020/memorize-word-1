import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/utils/word_content.dart';

void main() {
  group('parseMeanings', () {
    test('新格式多语言释义', () {
      final ms = parseMeanings(
          '[{"lang":"en","def":"to meet"},{"lang":"zh","def":"见面"}]');
      expect(ms.length, 2);
      expect(ms[0].lang, 'en');
      expect(ms[1].def, '见面');
    });

    test('非法 JSON / 空 def 过滤', () {
      expect(parseMeanings('not json'), isEmpty);
      expect(parseMeanings('[{"lang":"zh","def":""}]'), isEmpty);
    });
  });

  group('parseExamples', () {
    test('新格式 translations 对象', () {
      final es = parseExamples(
          '[{"text":"I run.","translations":{"zh":"我跑","ja":"走る"}}]');
      expect(es.single.text, 'I run.');
      expect(es.single.translations['zh'], '我跑');
      expect(es.single.translations['ja'], '走る');
    });

    test('新格式 translations 数组', () {
      final es = parseExamples(
          '[{"text":"I run.","translations":[{"lang":"zh","text":"我跑"}]}]');
      expect(es.single.translations['zh'], '我跑');
    });

    test('旧格式 translation 兼容读取（归为 zh）', () {
      final es = parseExamples('[{"text":"I run.","translation":"我跑"}]');
      expect(es.single.translations['zh'], '我跑');
    });

    test('非法 JSON / 空 text 过滤', () {
      expect(parseExamples('broken'), isEmpty);
      expect(parseExamples('[{"text":"","translation":"x"}]'), isEmpty);
    });
  });

  group('selectMeanings', () {
    const json =
        '[{"lang":"en","def":"to meet"},{"lang":"zh","def":"见面"}]';

    test("mode 'zh'：只取中文", () {
      final ms = selectMeanings(json, glossMode: 'zh', learningLang: 'ja');
      expect(ms.map((m) => m.lang), ['zh']);
    });

    test("mode 'alt'：学日语取英文", () {
      final ms = selectMeanings(json, glossMode: 'alt', learningLang: 'ja');
      expect(ms.map((m) => m.lang), ['en']);
    });

    test("mode 'alt'：学英语取日文，无日文数据回退全部", () {
      final ms =
          selectMeanings(json, glossMode: 'alt', learningLang: 'en');
      expect(ms.map((m) => m.lang), ['en', 'zh']);
    });

    test("mode 'both'：中文在前 + 辅助语言", () {
      final ms = selectMeanings(json, glossMode: 'both', learningLang: 'ja');
      expect(ms.map((m) => m.lang), ['zh', 'en']);
    });

    test('所选语言无数据时回退全部', () {
      final ms = selectMeanings(
          '[{"lang":"en","def":"to meet"}]',
          glossMode: 'zh',
          learningLang: 'ja');
      expect(ms.map((m) => m.lang), ['en']);
    });
  });

  group('translationFor', () {
    test('按模式取翻译，缺失时回退', () {
      const json =
          '[{"text":"I run.","translations":{"zh":"我跑","en":"I run."}}]';
      final e = parseExamples(json).single;
      expect(
          translationFor(e, glossMode: 'zh', learningLang: 'en'), '我跑');
      expect(
          translationFor(e, glossMode: 'alt', learningLang: 'ja'), 'I run.');
      expect(
          translationFor(e, glossMode: 'both', learningLang: 'ja'), '我跑');
    });

    test('无翻译返回 null', () {
      const json = '[{"text":"I run.","translations":{}}]';
      final e = parseExamples(json).single;
      expect(
          translationFor(e, glossMode: 'zh', learningLang: 'en'), isNull);
    });
  });

  test('altGlossLang', () {
    expect(altGlossLang('ja'), 'en');
    expect(altGlossLang('en'), 'ja');
  });
}
