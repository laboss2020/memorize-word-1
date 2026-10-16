/// fsrs 包封装：WordProgress（drift 行）↔ fsrs Card 互转与复习调度。
///
/// 与 DB 解耦：所有方法纯计算，由上层（SessionController）负责持久化。
/// FSRS Card 没有 reps/lapses/elapsedDays/scheduledDays 字段，由本封装维护。
library;

import 'dart:convert';

import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:uuid/uuid.dart';

import '../db/app_database.dart' show WordProgressData;

/// word_progress → fsrs Card 的转换与复习调度。
class FsrsService {
  FsrsService({fsrs.Scheduler? scheduler})
      : _scheduler = scheduler ?? fsrs.Scheduler();

  final fsrs.Scheduler _scheduler;

  static const _uuid = Uuid();

  /// 新词的初始进度行（尚未复习；state=learning, step=0, due=now）。
  /// "新词"本应无行；首次复习时用本行落库。
  WordProgressData newProgress({
    required String wordId,
    required String language,
    required int nowMs,
  }) {
    final nowUtc = DateTime.fromMillisecondsSinceEpoch(nowMs, isUtc: true);
    final card = fsrs.Card(cardId: stableCardId(wordId), due: nowUtc);
    return _cardToProgress(card,
        wordId: wordId,
        language: language,
        nowMs: nowMs,
        previous: null);
  }

  fsrs.Card progressToCard(WordProgressData progress) {
    return fsrs.Card(
      cardId: stableCardId(progress.wordId),
      state: fsrs.State.fromValue(progress.state),
      step: progress.step,
      stability: progress.stability,
      difficulty: progress.difficulty,
      due: DateTime.fromMillisecondsSinceEpoch(progress.due, isUtc: true),
      lastReview: progress.lastReviewAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(progress.lastReviewAt!,
              isUtc: true),
    );
  }

  /// 应用一次复习，返回更新后的进度行（未落库）与 fsrs ReviewLog JSON。
  ///
  /// [progress] 为 null 表示新词（无进度行）。
  ({WordProgressData progress, String reviewLogJson}) review({
    WordProgressData? progress,
    required String wordId,
    required String language,
    required int ratingValue,
    required int nowMs,
    int? durationMs,
  }) {
    final nowUtc = DateTime.fromMillisecondsSinceEpoch(nowMs, isUtc: true);
    final card =
        progress == null ? newCardFor(wordId, nowMs) : progressToCard(progress);
    final rating = fsrs.Rating.fromValue(ratingValue);

    final (card: reviewed, reviewLog: log) = _scheduler.reviewCard(card,
        rating,
        reviewDateTime: nowUtc,
        reviewDuration: durationMs);

    final updated = _cardToProgress(reviewed,
        wordId: wordId,
        language: language,
        nowMs: nowMs,
        previous: progress);
    return (progress: updated, reviewLogJson: jsonEncode(log.toMap()));
  }

  /// 用 wordId 构造一张全新卡片（learning, step 0）。
  fsrs.Card newCardFor(String wordId, int nowMs) {
    return fsrs.Card(
      cardId: stableCardId(wordId),
      due: DateTime.fromMillisecondsSinceEpoch(nowMs, isUtc: true),
    );
  }

  /// wordId → 稳定 int（FNV-1a 32 位），供 fsrs Card.cardId / ReviewLog 关联。
  /// String.hashCode 跨隔离区不稳定，不可用。
  static int stableCardId(String wordId) {
    var h = 0x811c9dc5;
    for (final unit in wordId.codeUnits) {
      h ^= unit;
      h = (h * 0x01000193) & 0xFFFFFFFF;
    }
    return h;
  }

  WordProgressData _cardToProgress(
    fsrs.Card card, {
    required String wordId,
    required String language,
    required int nowMs,
    required WordProgressData? previous,
  }) {
    final lastReviewMs = card.lastReview?.millisecondsSinceEpoch;
    final elapsedDays = previous?.lastReviewAt == null || lastReviewMs == null
        ? 0
        : ((lastReviewMs - previous!.lastReviewAt!) / 86400000).floor();
    final scheduledDays =
        ((card.due.millisecondsSinceEpoch - nowMs) / 86400000).floor();
    final enteredRelearning =
        previous != null && previous.state == 2 && card.state == fsrs.State.relearning;

    return WordProgressData(
      id: previous?.id ?? _uuid.v7(),
      wordId: wordId,
      language: language,
      state: card.state.value,
      due: card.due.millisecondsSinceEpoch,
      stability: card.stability,
      difficulty: card.difficulty,
      step: card.step,
      elapsedDays: elapsedDays < 0 ? 0 : elapsedDays,
      scheduledDays: scheduledDays < 0 ? 0 : scheduledDays,
      reps: (previous?.reps ?? 0) + 1,
      lapses: (previous?.lapses ?? 0) + (enteredRelearning ? 1 : 0),
      lastReviewAt: lastReviewMs,
      updatedAt: nowMs,
      deletedAt: previous?.deletedAt,
      syncStatus: previous?.syncStatus ?? 0,
    );
  }
}
