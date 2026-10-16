import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/placement/placement_engine.dart';

const _enLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

PlacementEngine engine({
  List<String> levels = _enLevels,
  int? startIndex,
  int maxQuestions = 20,
}) =>
    PlacementEngine(
        levels: levels, startIndex: startIndex ?? -1, maxQuestions: maxQuestions);

void main() {
  group('起始档', () {
    test('默认中间档（6 档 → index 2 = B1）', () {
      final e = engine();
      expect(e.currentLevel, 'B1');
    });

    test('5 档（日语）→ 中间档 N3', () {
      final e = engine(levels: ['N5', 'N4', 'N3', 'N2', 'N1']);
      expect(e.currentLevel, 'N3');
    });

    test('显式起始档生效', () {
      final e = engine(startIndex: 0);
      expect(e.currentLevel, 'A1');
    });
  });

  group('升档与完成', () {
    test('连续 2 对升档，到顶后结束取最高档', () {
      final e = engine();
      // B1 → B2 → C1 → 确认 C2（顶档）即完成。
      for (var i = 0; i < 8; i++) {
        e.recordAnswer(true);
      }
      expect(e.isDone, isTrue);
      expect(e.resultLevel, 'C2');
      expect(e.askedCount, 8);
    });

    test('单对不成升档（对错交替不推进）', () {
      final e = engine();
      e.recordAnswer(true);
      e.recordAnswer(false);
      e.recordAnswer(true);
      e.recordAnswer(false);
      expect(e.isDone, isFalse);
      expect(e.currentLevel, 'B1');
    });
  });

  group('降档与结束', () {
    test('中间档连续 2 错 → 低一档（A2）', () {
      final e = engine();
      e.recordAnswer(false);
      e.recordAnswer(false);
      expect(e.isDone, isTrue);
      expect(e.resultLevel, 'A2');
    });

    test('先确认后失败：确认档被保留', () {
      final e = engine();
      // B1 确认 → B2 连续 2 错 → 结果 B1（B2-1）。
      e.recordAnswer(true);
      e.recordAnswer(true);
      expect(e.currentLevel, 'B2');
      e.recordAnswer(false);
      e.recordAnswer(false);
      expect(e.isDone, isTrue);
      expect(e.resultLevel, 'B1');
    });

    test('A1 连续 2 错 → 停在 A1', () {
      final e = engine(startIndex: 0);
      e.recordAnswer(false);
      e.recordAnswer(false);
      expect(e.isDone, isTrue);
      expect(e.resultLevel, 'A1');
    });
  });

  group('题量上限', () {
    test('达到上限强制结束：答对中取当前档', () {
      final e = engine(maxQuestions: 3);
      e.recordAnswer(true);
      e.recordAnswer(false);
      e.recordAnswer(true);
      expect(e.isDone, isTrue);
      expect(e.resultLevel, 'B1'); // 当前档，最后一题答对
    });

    test('达到上限强制结束：答错中取低一档', () {
      final e = engine(maxQuestions: 2);
      e.recordAnswer(true);
      e.recordAnswer(false);
      expect(e.isDone, isTrue);
      expect(e.resultLevel, 'A2'); // B1-1
    });

    test('答错计答对交替永不收敛，由上限兜底', () {
      final e = engine();
      for (var i = 0; i < 20; i++) {
        e.recordAnswer(i % 2 == 0);
      }
      expect(e.isDone, isTrue);
      expect(e.askedCount, 20);
    });
  });

  test('结束后再记录无效果', () {
    final e = engine();
    e.recordAnswer(false);
    e.recordAnswer(false);
    expect(e.isDone, isTrue);
    e.recordAnswer(true);
    expect(e.askedCount, 2);
    expect(e.resultLevel, 'A2');
  });
}
