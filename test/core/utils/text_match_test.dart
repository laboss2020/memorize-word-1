import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/db/app_database.dart';
import 'package:memorize_word/core/utils/text_match.dart';

Word _word({
  required String headword,
  String language = 'en',
  String? reading,
  required String examples,
}) =>
    Word(
      id: 'w1',
      language: language,
      headword: headword,
      reading: reading,
      meanings: '[{"lang":"zh","def":"测试"}]',
      examples: examples,
      difficulty: 1.5,
      level: 'A1',
      freqRank: 1,
    );

void main() {
  group('editDistance', () {
    test('相同为 0，空串为长度', () {
      expect(editDistance('apple', 'apple'), 0);
      expect(editDistance('', 'abc'), 3);
      expect(editDistance('abc', ''), 3);
    });

    test('单字符增删替换', () {
      expect(editDistance('cat', 'cut'), 1);
      expect(editDistance('cat', 'cats'), 1);
      expect(editDistance('cat', 'at'), 1);
    });

    test('多轮替换不因缓冲区复用出错', () {
      expect(editDistance('kitten', 'sitting'), 3);
      expect(editDistance('flaw', 'lawn'), 2);
      expect(editDistance('abcdef', 'azced'), 3);
    });
  });

  group('romajiToKana', () {
    test('基础假名', () {
      expect(romajiToKana('kita'), 'きた');
      expect(romajiToKana('tabemasu'), 'たべます');
    });

    test('促音（双子音）', () {
      expect(romajiToKana('kitta'), 'きった');
      expect(romajiToKana('kitte'), 'きって');
      expect(romajiToKana('zasshi'), 'ざっし');
    });

    test('长音与ん', () {
      expect(romajiToKana('kon\'ya'), 'こんや');
      // IME 式前瞻：nn + 元音 → ん + 下一拍
      expect(romajiToKana('konnitiha'), 'こんにちは');
      expect(romajiToKana('konnichiwa'), 'こんにちわ'); // wa→わ； particle は 属词级例外
      expect(romajiToKana('konna'), 'こんな');
      expect(romajiToKana('nihon'), 'にほん');
      expect(romajiToKana('ko-hi-'), 'こーひー');
    });

    test('拗音', () {
      expect(romajiToKana('shashin'), 'しゃしん');
      expect(romajiToKana('chotto'), 'ちょっと');
      expect(romajiToKana('jugyou'), 'じゅぎょう');
    });

    test('片假名 → 平假名', () {
      expect(katakanaToHiragana('アルバイト'), 'あるばいと');
      expect(katakanaToHiragana('カタカナ'), 'かたかな');
      expect(katakanaToHiragana('テスト'), 'てすと');
    });

    test('归一化：日语罗马字/片假名 → 平假名，英语小写', () {
      expect(normalizeSpelling('アルバイト', 'ja'), 'あるばいと');
      expect(normalizeSpelling('たべる', 'ja'), 'たべる');
      expect(normalizeSpelling('  Apple  ', 'en'), 'apple');
    });
  });

  group('buildCloze', () {
    test('英语：整词匹配，保留原词形', () {
      final w = _word(
        headword: 'run',
        examples:
            '[{"text":"I run every morning.","translation":"我每天早上跑步"}]',
      );
      final cloze = buildCloze(w);
      expect(cloze, isNotNull);
      expect(cloze!.sentence, 'I ＿＿ every morning.');
      expect(cloze.answer, 'run');
      expect(cloze.translation, '我每天早上跑步');
    });

    test('英语：大小写不敏感且答案保留原文（含词形变化）', () {
      final w = _word(
        headword: 'city',
        examples: '[{"text":"New York is a big City.","translation":null}]',
      );
      final cloze = buildCloze(w);
      expect(cloze!.answer, 'City');
      expect(cloze.sentence, 'New York is a big ＿＿.');
    });

    test('英语：词头不在例句中（词形变化不整词匹配）→ 尝试下一句/返回 null', () {
      final w = _word(
        headword: 'run',
        examples: '[{"text":"He runs fast.","translation":null}]',
      );
      expect(buildCloze(w), isNull);
    });

    test('日语：子串匹配', () {
      final w = _word(
        headword: '食べる',
        language: 'ja',
        reading: 'たべる',
        examples: '[{"text":"朝ご飯を食べる。","translation":"吃早饭"}]',
      );
      final cloze = buildCloze(w);
      expect(cloze!.sentence, '朝ご飯を＿＿。');
      expect(cloze.answer, '食べる');
    });

    test('多句：第一句无词则用后续句', () {
      final w = _word(
        headword: 'apple',
        examples:
            '[{"text":"No word here.","translation":null},{"text":"An apple a day.","translation":null}]',
      );
      final cloze = buildCloze(w);
      expect(cloze!.sentence, 'An ＿＿ a day.');
    });
  });
}
