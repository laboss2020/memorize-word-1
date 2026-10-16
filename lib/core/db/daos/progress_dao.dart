import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user.dart' show WordProgress;

part 'progress_dao.g.dart';

/// 学习进度的读写。
@DriftAccessor(tables: [WordProgress])
class ProgressDao extends DatabaseAccessor<AppDatabase> with _$ProgressDaoMixin {
  ProgressDao(super.db);

  Future<WordProgressData?> getProgress(String wordId) {
    return (select(wordProgress)
          ..where((p) => p.wordId.equals(wordId) & p.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Stream<WordProgressData?> watchProgress(String wordId) {
    return (select(wordProgress)
          ..where((p) => p.wordId.equals(wordId) & p.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  Future<void> upsertProgress(WordProgressData row) {
    return into(wordProgress).insertOnConflictUpdate(row);
  }

  /// 到期复习（due 升序，未删除）。[states] 缺省取全部状态。
  Future<List<WordProgressData>> dueReviews({
    required String language,
    required int nowMs,
    required int limit,
    List<int>? states,
  }) {
    return (select(wordProgress)
          ..where((p) =>
              p.language.equals(language) &
              p.due.isSmallerOrEqualValue(nowMs) &
              p.deletedAt.isNull() &
              (states == null
                  ? const Constant(true)
                  : p.state.isIn(states)))
          ..orderBy([(p) => OrderingTerm.asc(p.due)])
          ..limit(limit))
        .get();
  }

  /// 到期总数（含超出今日配额的部分，供顺延与提示）。
  Future<int> dueCount({required String language, required int nowMs}) async {
    final c = countAll();
    final q = selectOnly(wordProgress)
      ..addColumns([c])
      ..where(wordProgress.language.equals(language) &
          wordProgress.due.isSmallerOrEqualValue(nowMs) &
          wordProgress.deletedAt.isNull());
    return q.map((row) => row.read(c) ?? 0).getSingle();
  }

  /// 到期数流（主页任务卡）。nowMs 在创建流时冻结；作答引起的表变更会自动重查。
  Stream<int> watchDueCount({
    required String language,
    required int nowMs,
  }) {
    final c = countAll();
    final q = selectOnly(wordProgress)
      ..addColumns([c])
      ..where(wordProgress.language.equals(language) &
          wordProgress.due.isSmallerOrEqualValue(nowMs) &
          wordProgress.deletedAt.isNull());
    return q.watchSingle().map((row) => row.read(c) ?? 0);
  }

  /// 掌握度分布：learning / review / relearning 计数与成熟词数。
  Future<({int learning, int review, int relearning, int mature})>
      stateCounts(String language) async {
    final row = await customSelect(
      'SELECT '
      'COALESCE(SUM(CASE WHEN state = 1 THEN 1 ELSE 0 END), 0) learning, '
      'COALESCE(SUM(CASE WHEN state = 2 THEN 1 ELSE 0 END), 0) review, '
      'COALESCE(SUM(CASE WHEN state = 3 THEN 1 ELSE 0 END), 0) relearning, '
      'COALESCE(SUM(CASE WHEN state = 2 AND stability >= 21 THEN 1 ELSE 0 END), 0) mature '
      'FROM word_progress WHERE language = ? AND deleted_at IS NULL',
      variables: [Variable(language)],
      readsFrom: {wordProgress},
    ).getSingle();
    return (
      learning: row.read<int>('learning'),
      review: row.read<int>('review'),
      relearning: row.read<int>('relearning'),
      mature: row.read<int>('mature'),
    );
  }

  /// 掌握度分布流（统计页环形图）：未学 / 学习中（含重学）/ 巩固中 / 已掌握。
  /// stability ≥ 21 天视为已掌握（与统计口径一致）。
  Stream<({int fresh, int learning, int young, int mature})> watchMastery(
      String language) {
    return customSelect(
      'SELECT '
      'COALESCE(SUM(CASE WHEN p.id IS NULL THEN 1 ELSE 0 END), 0) fresh, '
      'COALESCE(SUM(CASE WHEN p.state IN (1, 3) THEN 1 ELSE 0 END), 0) learning, '
      'COALESCE(SUM(CASE WHEN p.state = 2 AND p.stability < 21 THEN 1 ELSE 0 END), 0) young, '
      'COALESCE(SUM(CASE WHEN p.state = 2 AND p.stability >= 21 THEN 1 ELSE 0 END), 0) mature '
      'FROM words w LEFT JOIN word_progress p '
      'ON p.word_id = w.id AND p.deleted_at IS NULL '
      'WHERE w.language = ?',
      variables: [Variable(language)],
      readsFrom: {attachedDatabase.words, wordProgress},
    ).watchSingle().map((row) => (
          fresh: row.read<int>('fresh'),
          learning: row.read<int>('learning'),
          young: row.read<int>('young'),
          mature: row.read<int>('mature'),
        ));
  }

  /// 软删除（"不再学"）。
  Future<void> softDelete(String wordId, {required int nowMs}) {
    return (update(wordProgress)..where((p) => p.wordId.equals(wordId))).write(
      WordProgressCompanion(deletedAt: Value(nowMs), updatedAt: Value(nowMs)),
    );
  }
}
