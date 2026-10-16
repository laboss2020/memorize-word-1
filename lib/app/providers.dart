import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../core/db/app_database.dart';
import '../core/db/seed_importer.dart';
import '../core/notifications/reminder_service.dart';
import '../core/utils/study_day.dart';

/// 数据库单例。
final dbProvider = Provider<AppDatabase>((ref) => AppDatabase.instance());

/// 每日复习提醒服务（应用级单例；平台不可用时内部降级为 no-op）。
final reminderServiceProvider = Provider<ReminderService>((ref) {
  return ReminderService();
});

/// 首启种子导入（keepAlive：整个应用生命周期只跑一次）。
final seedImportProvider = FutureProvider<SeedImportResult>((ref) async {
  final db = ref.watch(dbProvider);
  final tempDir = await getTemporaryDirectory();
  final importer = SeedImporter(db, tempDir: tempDir);
  return importer.importIfNeeded(() async {
    final data = await rootBundle.load('assets/db/seed_v1.sqlite');
    return data.buffer.asUint8List();
  });
});

/// 应用设置流（首次读取时自动初始化默认行）。
final settingsProvider = StreamProvider<Setting>((ref) {
  final db = ref.watch(dbProvider);
  return db.settingsDao
      .watchSettings(nowMs: DateTime.now().millisecondsSinceEpoch);
});

/// 单词详情流。
final wordProvider = StreamProvider.autoDispose.family<Word?, String>(
    (ref, id) {
  return ref.watch(dbProvider).wordDao.watchWord(id);
});

/// 单词学习进度流。
final progressProvider =
    StreamProvider.autoDispose.family<WordProgressData?, String>((ref, wordId) {
  return ref.watch(dbProvider).progressDao.watchProgress(wordId);
});

/// 单词学习日志流。
final wordLogsProvider =
    StreamProvider.autoDispose.family<List<StudyLog>, String>((ref, wordId) {
  return ref.watch(dbProvider).studyDao.watchWordLogs(wordId);
});

/// 今日（本地学习日）统计行，无则 null。
final todayStatsProvider = StreamProvider.autoDispose<DailyStat?>((ref) {
  return ref.watch(dbProvider).studyDao.watchDailyStat(localStudyDay(DateTime.now()));
});

/// 连续打卡天数（以近一年 dailyStats 为源，主页与统计页共用）。
final streakProvider = StreamProvider.autoDispose<int>((ref) {
  final fromDate = studyDayBefore(localStudyDay(DateTime.now()), 365);
  return ref
      .watch(dbProvider)
      .studyDao
      .watchRecentDays(fromDate)
      .map((days) => computeStreak({for (final d in days) d.date}));
});
