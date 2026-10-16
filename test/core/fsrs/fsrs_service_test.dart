import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:memorize_word/core/db/app_database.dart';
import 'package:memorize_word/core/fsrs/fsrs_service.dart';

const _nowMs = 1760000000000; // 固定"当前时间"（unix ms）

/// 构造一张已有进度的复习卡（review 状态，6 天前学的）。
WordProgressData _reviewRow({
  String wordId = 'w-1',
  int state = 2,
  int due = _nowMs - 86400000,
  double stability = 5.0,
  double difficulty = 5.0,
  int? step,
  int? lastReviewAt = _nowMs - 6 * 86400000,
  int reps = 3,
  int lapses = 0,
}) {
  return WordProgressData(
    id: 'p-1',
    wordId: wordId,
    language: 'en',
    state: state,
    due: due,
    stability: stability,
    difficulty: difficulty,
    step: step,
    elapsedDays: 6,
    scheduledDays: 6,
    reps: reps,
    lapses: lapses,
    lastReviewAt: lastReviewAt,
    updatedAt: _nowMs - 6 * 86400000,
    syncStatus: 0,
  );
}

FsrsService _service() => FsrsService(
      scheduler: fsrs.Scheduler.customRandom(
        math.Random(1),
        enableFuzzing: false,
      ),
    );

void main() {
  group('stableCardId', () {
    test('确定性且可区分', () {
      expect(FsrsService.stableCardId('en|apple|n'),
          FsrsService.stableCardId('en|apple|n'));
      expect(FsrsService.stableCardId('en|apple|n'),
          isNot(FsrsService.stableCardId('en|apply|n')));
      expect(FsrsService.stableCardId(''), 0x811c9dc5); // FNV offset basis
    });
  });

  group('progressToCard / _cardToProgress 往返', () {
    test('字段一一对应', () {
      final svc = _service();
      final row = _reviewRow();
      final card = svc.progressToCard(row);

      expect(card.cardId, FsrsService.stableCardId('w-1'));
      expect(card.state, fsrs.State.review);
      expect(card.stability, 5.0);
      expect(card.difficulty, 5.0);
      expect(card.due.isUtc, isTrue);
      expect(
        card.due.millisecondsSinceEpoch,
        _nowMs - 86400000,
      );
      expect(
        card.lastReview!.millisecondsSinceEpoch,
        _nowMs - 6 * 86400000,
      );
    });
  });

  group('新词首次复习', () {
    test('Good → learning step 1，due = now + 10min（步进 2）', () {
      final svc = _service();
      final r = svc.review(
        progress: null,
        wordId: 'w-new',
        language: 'en',
        ratingValue: 3, // good
        nowMs: _nowMs,
        durationMs: 4000,
      );

      final p = r.progress;
      expect(p.id, isNot(equals('p-1'))); // 新行有 UUID id
      expect(p.state, 1); // learning
      expect(p.step, 1);
      expect(p.reps, 1);
      expect(p.lapses, 0);
      expect(p.due - _nowMs, 10 * 60 * 1000); // learningSteps[1] = 10min
      expect(p.lastReviewAt, _nowMs);
      expect(p.stability, isNotNull);
      expect(p.difficulty, isNotNull);
      expect(p.deletedAt, isNull);
    });

    test('Again → learning step 0，due = now + 1min', () {
      final svc = _service();
      final r = svc.review(
        progress: null,
        wordId: 'w-new',
        language: 'en',
        ratingValue: 1,
        nowMs: _nowMs,
      );

      expect(r.progress.state, 1);
      expect(r.progress.step, 0);
      expect(r.progress.due - _nowMs, 60 * 1000);
    });

    test('Easy → 直接毕业进 review，due ≥ 1 天', () {
      final svc = _service();
      final r = svc.review(
        progress: null,
        wordId: 'w-new',
        language: 'en',
        ratingValue: 4,
        nowMs: _nowMs,
      );

      expect(r.progress.state, 2); // review
      expect(r.progress.step, isNull);
      expect(r.progress.due - _nowMs, greaterThanOrEqualTo(86400000));
    });

    test('learning 最后一步 Good → 毕业 review', () {
      final svc = _service();
      // 先走第一步（step 0 → 1），再在 step 1 上 Good。
      final first = svc.review(
        progress: null,
        wordId: 'w-new',
        language: 'en',
        ratingValue: 3,
        nowMs: _nowMs,
      );
      final second = svc.review(
        progress: first.progress,
        wordId: 'w-new',
        language: 'en',
        ratingValue: 3,
        nowMs: _nowMs + 10 * 60 * 1000,
      );

      expect(second.progress.state, 2); // 毕业
      expect(second.progress.step, isNull);
      expect(second.progress.reps, 2);
      expect(second.progress.due,
          greaterThan(_nowMs + 86400000)); // 多天间隔
    });
  });

  group('复习态卡片', () {
    test('Good → due 顺延且不早于旧 due', () {
      final svc = _service();
      final row = _reviewRow();
      final r = svc.review(
        progress: row,
        wordId: row.wordId,
        language: row.language,
        ratingValue: 3,
        nowMs: _nowMs,
      );

      expect(r.progress.state, 2);
      expect(r.progress.due, greaterThan(row.due));
      expect(r.progress.reps, row.reps + 1);
      expect(r.progress.lapses, 0);
      expect(r.progress.stability, greaterThan(row.stability!));
    });

    test('Again → 进入 relearning，lapses+1，due = +10min', () {
      final svc = _service();
      final row = _reviewRow(lapses: 0);
      final r = svc.review(
        progress: row,
        wordId: row.wordId,
        language: row.language,
        ratingValue: 1,
        nowMs: _nowMs,
      );

      expect(r.progress.state, 3); // relearning
      expect(r.progress.step, 0);
      expect(r.progress.lapses, 1);
      expect(r.progress.due - _nowMs, 10 * 60 * 1000); // relearningSteps[0]
    });
  });

  group('ReviewLog JSON', () {
    test('可 roundtrip 且含 rating/时间/时长', () {
      final svc = _service();
      final r = svc.review(
        progress: null,
        wordId: 'w-new',
        language: 'en',
        ratingValue: 3,
        nowMs: _nowMs,
        durationMs: 5200,
      );

      final map = jsonDecode(r.reviewLogJson) as Map<String, dynamic>;
      final log = fsrs.ReviewLog.fromMap(map);
      expect(log.rating, fsrs.Rating.good);
      expect(log.reviewDuration, 5200);
      expect(log.reviewDateTime.isUtc, isTrue);
      expect(log.cardId, FsrsService.stableCardId('w-new'));
    });
  });

  group('due 单调性', () {
    test('连续复习 due 严格递增（同评级短期重复除外）', () {
      final svc = _service();
      var progress = svc.newProgress(wordId: 'w-x', language: 'en', nowMs: _nowMs);
      var lastDue = _nowMs;
      var t = _nowMs;
      // 走完 learning 两步 + 两轮 review，due 应始终向后推。
      for (final rating in const [3, 3, 3, 3]) {
        t += 11 * 60 * 1000; // 等到期
        final r = svc.review(
          progress: progress,
          wordId: 'w-x',
          language: 'en',
          ratingValue: rating,
          nowMs: t,
        );
        progress = r.progress;
        expect(progress.due, greaterThan(lastDue));
        lastDue = progress.due;
      }
      expect(progress.state, 2);
    });
  });
}
