/// 统计页数据流：每日序列、累计数、掌握度分布。
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart';
import '../../core/utils/study_day.dart';

/// 近一年每日统计（按日升序；缺失日不含，由 UI 补零）。
/// 柱状图/折线取近 30 天，热力图取近一年，共用这一条流。
final dailySeriesProvider = StreamProvider.autoDispose<List<DailyStat>>((ref) {
  final fromDate = studyDayBefore(localStudyDay(DateTime.now()), 366);
  return ref.watch(dbProvider).studyDao.watchRecentDays(fromDate);
});

/// 累计统计。
final totalsProvider = StreamProvider.autoDispose<
    ({int total, int correct, int minutes, int newWords, int reviews})>((ref) {
  return ref.watch(dbProvider).studyDao.watchTotals();
});

/// 掌握度分布（按当前学习语言）。
final masteryProvider = StreamProvider.autoDispose<
    ({int fresh, int learning, int young, int mature})>((ref) {
  final language = ref.watch(settingsProvider).value?.learningLang ?? 'en';
  return ref.watch(dbProvider).progressDao.watchMastery(language);
});
