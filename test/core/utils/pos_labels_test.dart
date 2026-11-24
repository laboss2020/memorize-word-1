import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/utils/pos_labels.dart';

void main() {
  group('posLabel', () {
    test('中文释义：en 词性码', () {
      expect(posLabel('n', 'zh'), '名词');
      expect(posLabel('n/v', 'zh'), '名词·动词');
      expect(posLabel('adj/adv', 'zh'), '形容词·副词');
    });

    test('中文释义：ja JMdict 码', () {
      expect(posLabel('adj-i', 'zh'), 'イ形容词');
      expect(posLabel('v5u/vt', 'zh'), '五段动词·及物动词');
      expect(posLabel('v1/vi', 'zh'), '一段动词·不及物动词');
      expect(posLabel('n/vs/vt', 'zh'), '名词·サ变动词·及物动词');
    });

    test('英文释义', () {
      expect(posLabel('n/v', 'en'), 'noun·verb');
      expect(posLabel('adj-i', 'en'), 'i-adjective');
      expect(posLabel('v5r', 'en'), 'godan verb');
      expect(posLabel('vs', 'en'), 'suru verb');
    });

    test('日文释义', () {
      expect(posLabel('n', 'ja'), '名詞');
      expect(posLabel('v5k', 'ja'), '五段動詞');
      expect(posLabel('adj-na', 'ja'), 'ナ形容詞');
    });

    test('未知代码原样保留（zh 回退默认表）', () {
      expect(posLabel('xyz', 'zh'), 'xyz');
      expect(posLabel('xyz/n', 'en'), 'xyz·noun');
    });

    test('空段跳过；全空回退原串', () {
      expect(posLabel('n//v', 'zh'), '名词·动词');
      expect(posLabel('/', 'zh'), '/');
    });

    test('glossMode 非 zh/en/ja 回退中文', () {
      expect(posLabel('n', 'fr'), '名词');
    });
  });
}
