import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' show Rating;
import 'package:memorize_word/core/fsrs/rating_mapper.dart';

void main() {
  group('rateChoice（选择题）', () {
    test('首次答对 = Good', () {
      expect(rateChoice(const ChoiceAnswer(correct: true)), Rating.good);
    });

    test('此前最近一次也对 = Easy', () {
      expect(
        rateChoice(const ChoiceAnswer(correct: true, consecutiveCorrect: 2)),
        Rating.easy,
      );
      expect(
        rateChoice(const ChoiceAnswer(correct: true, consecutiveCorrect: 5)),
        Rating.easy,
      );
    });

    test('答错 = Again（客观优先，无论连对历史）', () {
      expect(
        rateChoice(const ChoiceAnswer(
            correct: false, consecutiveCorrect: 3)),
        Rating.again,
      );
    });

    test('错后重练答对 = Hard', () {
      expect(
        rateChoice(const ChoiceAnswer(correct: true, isRepractice: true)),
        Rating.hard,
      );
    });

    test('重练标记不影响错误判定', () {
      expect(
        rateChoice(const ChoiceAnswer(correct: false, isRepractice: true)),
        Rating.again,
      );
    });
  });

  group('rateRecall（听写/填空）', () {
    test('拼写全对无提示 = Good', () {
      expect(rateRecall(const RecallAnswer(correct: true)), Rating.good);
    });

    test('用提示 = Hard', () {
      expect(
        rateRecall(const RecallAnswer(correct: true, hintUsed: true)),
        Rating.hard,
      );
    });

    test('编辑距离 1 = Hard', () {
      expect(
        rateRecall(const RecallAnswer(correct: true, errorCount: 1)),
        Rating.hard,
      );
    });

    test('错误 ≥2 = Again（correct=false）', () {
      expect(
        rateRecall(const RecallAnswer(correct: false, errorCount: 2)),
        Rating.again,
      );
      expect(
        rateRecall(const RecallAnswer(correct: false, errorCount: 10)),
        Rating.again,
      );
    });

    test('编辑距离 1 客观算错但 rating = Hard', () {
      expect(
        rateRecall(const RecallAnswer(correct: false, errorCount: 1)),
        Rating.hard,
      );
    });

    test('空答案：调用方传 errorCount = 词长（≥2）= Again', () {
      // 空输入的编辑距离 = 目标词长度，由调用方计算后传入。
      expect(
        rateRecall(const RecallAnswer(correct: false, errorCount: 5)),
        Rating.again,
      );
    });
  });

  group('StudyMode 编码', () {
    test('id 与 study_logs.mode 一致', () {
      expect(StudyMode.newCard.id, 'new_card');
      expect(StudyMode.choice.id, 'choice');
      expect(StudyMode.dictation.id, 'dictation');
      expect(StudyMode.cloze.id, 'cloze');
      expect(StudyMode.placement.id, 'placement');
    });

    test('fromId 往返', () {
      for (final m in StudyMode.values) {
        expect(StudyMode.fromId(m.id), m);
      }
    });

    test('未知 id 抛出', () {
      expect(() => StudyMode.fromId('crossword'), throwsArgumentError);
    });
  });

  test('新卡首呈 = Good', () {
    expect(rateNewCard(), Rating.good);
  });
}
