/// 主页数据流：到期数、断点会话、建议卡输入（今日统计与连续打卡在 app/providers.dart）。
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart';
import '../../core/utils/study_day.dart';

/// 到期复习数（nowMs 在流创建时冻结；作答后自动重查）。
final dueCountProvider = StreamProvider.autoDispose.family<int, String>(
    (ref, language) {
  return ref.watch(dbProvider).progressDao.watchDueCount(
      language: language, nowMs: DateTime.now().millisecondsSinceEpoch);
});

/// 未结束会话（断点续学入口）。
final openSessionProvider = StreamProvider.autoDispose<StudySession?>((ref) {
  return ref.watch(dbProvider).studyDao.watchOpenSession();
});

/// 近 7 天正确率（%）；无答题记录为 null。
final recentAccuracyProvider = StreamProvider.autoDispose<double?>((ref) {
  final fromDate = studyDayBefore(localStudyDay(DateTime.now()), 6);
  return ref.watch(dbProvider).studyDao.watchRecentDays(fromDate).map((days) {
    final total = days.fold<int>(0, (a, d) => a + d.totalCount);
    if (total == 0) return null;
    final correct = days.fold<int>(0, (a, d) => a + d.correctCount);
    return correct / total * 100;
  });
});

/// 距上次学习天数（今天学过 = 0；近一年从未学 = null）。
final daysSinceLastStudyProvider = StreamProvider.autoDispose<int?>((ref) {
  final fromDate = studyDayBefore(localStudyDay(DateTime.now()), 365);
  return ref
      .watch(dbProvider)
      .studyDao
      .watchRecentDays(fromDate)
      .map((days) {
    if (days.isEmpty) return null;
    final last = days.map((d) => d.date).reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
    final today = DateTime.parse(localStudyDay(DateTime.now()));
    return today.difference(DateTime.parse(last)).inDays;
  });
});
