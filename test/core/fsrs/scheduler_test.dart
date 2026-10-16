import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/fsrs/rating_mapper.dart' show StudyMode;
import 'package:memorize_word/core/fsrs/scheduler.dart';

List<QueueWord> _words(int n, {bool hasExamples = true}) =>
    List.generate(n, (i) => QueueWord(wordId: 'r$i', reps: i, hasExamples: hasExamples));

List<QueueWord> _new(int n) => List.generate(
    n, (i) => QueueWord(wordId: 'n$i', reps: 0, hasExamples: true));

void main() {
  group('buildTodayQueue', () {
    test('空输入 → 空队列', () {
      expect(buildTodayQueue(dueReviews: [], newWords: []), isEmpty);
    });

    test('纯复习：保持 due 顺序，模式按 reps 轮换', () {
      final items = buildTodayQueue(dueReviews: _words(6), newWords: []);
      expect(items, hasLength(6));
      expect(items.every((i) => !i.isNew), isTrue);
      expect(items.map((i) => i.wordId),
          ['r0', 'r1', 'r2', 'r3', 'r4', 'r5']);
      // reps=0→choice, 1→dictation, 2→cloze, 3→choice, ...
      expect(items.map((i) => i.mode), [
        StudyMode.choice,
        StudyMode.dictation,
        StudyMode.cloze,
        StudyMode.choice,
        StudyMode.dictation,
        StudyMode.cloze,
      ]);
    });

    test('纯新词：全部 new_card', () {
      final items = buildTodayQueue(dueReviews: [], newWords: _new(3));
      expect(items.map((i) => i.mode), everyElement(StudyMode.newCard));
      expect(items.every((i) => i.isNew), isTrue);
    });

    test('1:3 交错：每 3 个复习插 1 个新词', () {
      final items = buildTodayQueue(dueReviews: _words(9), newWords: _new(3));
      // 模式：r r r n r r r n r r r n
      final ids = items.map((i) => i.wordId).toList();
      expect(ids, ['r0', 'r1', 'r2', 'n0', 'r3', 'r4', 'r5', 'n1', 'r6', 'r7', 'r8', 'n2']);
      // 首项是复习（复习优先）
      expect(items.first.isNew, isFalse);
    });

    test('复习不足 3n 时新词殿后', () {
      final items = buildTodayQueue(dueReviews: _words(2), newWords: _new(4));
      final ids = items.map((i) => i.wordId).toList();
      expect(ids, ['r0', 'r1', 'n0', 'n1', 'n2', 'n3']);
    });

    test('新词不足时剩余复习连续排完', () {
      final items = buildTodayQueue(dueReviews: _words(5), newWords: _new(1));
      final ids = items.map((i) => i.wordId).toList();
      expect(ids, ['r0', 'r1', 'r2', 'n0', 'r3', 'r4']);
    });

    test('无例句的词填空降级为选择题', () {
      final items = buildTodayQueue(
        dueReviews: [
          const QueueWord(wordId: 'a', reps: 2, hasExamples: false),
          const QueueWord(wordId: 'b', reps: 2, hasExamples: true),
        ],
        newWords: [],
      );
      expect(items[0].mode, StudyMode.choice); // 降级
      expect(items[1].mode, StudyMode.cloze); // 保留
    });

    test('reps 轮换索引超出模式表时取模循环', () {
      final items = buildTodayQueue(
        dueReviews: [QueueWord(wordId: 'a', reps: 10)],
        newWords: [],
      );
      expect(items.single.mode, StudyMode.dictation); // 10 % 3 == 1
    });
  });
}
