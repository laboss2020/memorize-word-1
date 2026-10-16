import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user.dart';

part 'study_dao.g.dart';

/// 学习日志、每日统计、会话断点。
@DriftAccessor(tables: [StudyLogs, DailyStats, StudySessions])
class StudyDao extends DatabaseAccessor<AppDatabase> with _$StudyDaoMixin {
  StudyDao(super.db);

  Future<void> insertLog(StudyLogsCompanion entry) {
    return into(studyLogs).insert(entry);
  }

  /// 单词历史（详情页时间线）。
  Stream<List<StudyLog>> watchWordLogs(String wordId, {int limit = 20}) {
    return (select(studyLogs)
          ..where((l) => l.wordId.equals(wordId) & l.deletedAt.isNull())
          ..orderBy([(l) => OrderingTerm.desc(l.studiedAt)])
          ..limit(limit))
        .watch();
  }

  /// 单词最近一条日志（选择题 Easy 判定用：上次是否答对）。
  Future<StudyLog?> lastLog(String wordId) {
    return (select(studyLogs)
          ..where((l) => l.wordId.equals(wordId) & l.deletedAt.isNull())
          ..orderBy([(l) => OrderingTerm.desc(l.studiedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 累计当天统计（本地学习日）。newCount/reviewCount/correctCount/minutes 为增量。
  Future<void> bumpDailyStats({
    required String date,
    required int newCount,
    required int reviewCount,
    required int correctCount,
    required int minutes,
    required int nowMs,
  }) {
    return customInsert(
      'INSERT INTO daily_stats (date, new_count, review_count, correct_count, '
      'total_count, minutes, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?) '
      'ON CONFLICT(date) DO UPDATE SET '
      'new_count = new_count + ?, review_count = review_count + ?, '
      'correct_count = correct_count + ?, total_count = total_count + ?, '
      'minutes = minutes + ?, updated_at = ?',
      variables: [
        Variable(date),
        Variable(newCount),
        Variable(reviewCount),
        Variable(correctCount),
        Variable(newCount + reviewCount),
        Variable(minutes),
        Variable(nowMs),
        Variable(newCount),
        Variable(reviewCount),
        Variable(correctCount),
        Variable(newCount + reviewCount),
        Variable(minutes),
        Variable(nowMs),
      ],
      updates: {dailyStats},
    );
  }

  /// 近 n 天的每日统计（按日升序，缺失日不含在内）。
  Stream<List<DailyStat>> watchRecentDays(String fromDate) {
    return (select(dailyStats)
          ..where((s) => s.date.isBiggerOrEqualValue(fromDate))
          ..orderBy([(s) => OrderingTerm.asc(s.date)]))
        .watch();
  }

  /// 累计统计（daily_stats 全表求和）。
  Stream<({int total, int correct, int minutes, int newWords, int reviews})>
      watchTotals() {
    return customSelect(
      'SELECT COALESCE(SUM(total_count), 0) total, '
      'COALESCE(SUM(correct_count), 0) correct, '
      'COALESCE(SUM(minutes), 0) minutes, '
      'COALESCE(SUM(new_count), 0) new_words, '
      'COALESCE(SUM(review_count), 0) reviews FROM daily_stats',
      readsFrom: {dailyStats},
    ).watchSingle().map((row) => (
          total: row.read<int>('total'),
          correct: row.read<int>('correct'),
          minutes: row.read<int>('minutes'),
          newWords: row.read<int>('new_words'),
          reviews: row.read<int>('reviews'),
        ));
  }

  /// 某一天的统计行（无则 null）。
  Stream<DailyStat?> watchDailyStat(String date) {
    return (select(dailyStats)..where((s) => s.date.equals(date)))
        .watchSingleOrNull();
  }

  /// 连续打卡：最近有学习的日期集合（从今天往回数）。
  Future<List<String>> activeDates(String fromDate) {
    return customSelect(
      'SELECT DISTINCT date FROM daily_stats '
      'WHERE date >= ? AND total_count > 0 ORDER BY date DESC',
      variables: [Variable(fromDate)],
      readsFrom: {dailyStats},
    ).map((row) => row.read<String>('date')).get();
  }

  // ---- 会话断点 ----

  /// 打开新会话前清理历史遗留的未结束会话。
  Future<void> abandonOpenSessions({required int nowMs}) {
    return (update(studySessions)..where((s) => s.endedAt.isNull())).write(
      StudySessionsCompanion(endedAt: Value(nowMs), updatedAt: Value(nowMs)),
    );
  }

  Future<void> startSession(StudySessionsCompanion session) {
    return into(studySessions).insert(session);
  }

  /// 打断点会话（endedAt IS NULL），没有则返回 null。
  Future<StudySession?> openSession() {
    return (select(studySessions)..where((s) => s.endedAt.isNull()))
        .getSingleOrNull();
  }

  /// 未结束会话流（主页"继续学习(n)"）。
  Stream<StudySession?> watchOpenSession() {
    return (select(studySessions)..where((s) => s.endedAt.isNull()))
        .watchSingleOrNull();
  }

  Future<void> updateSession({
    required String id,
    String? queue,
    int? completedCount,
    required int nowMs,
  }) {
    return (update(studySessions)..where((s) => s.id.equals(id))).write(
      StudySessionsCompanion(
        queue: queue == null ? const Value.absent() : Value(queue),
        completedCount:
            completedCount == null ? const Value.absent() : Value(completedCount),
        updatedAt: Value(nowMs),
      ),
    );
  }

  Future<void> endSession({required String id, required int nowMs}) {
    return (update(studySessions)..where((s) => s.id.equals(id))).write(
      StudySessionsCompanion(endedAt: Value(nowMs), updatedAt: Value(nowMs)),
    );
  }
}
