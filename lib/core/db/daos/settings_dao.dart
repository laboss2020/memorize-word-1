import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user.dart';

part 'settings_dao.g.dart';

/// 应用设置（单行 id='local'，首次读取时初始化）。
@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<Setting> getOrCreate({required int nowMs}) async {
    final existing =
        await (select(settings)..where((s) => s.id.equals('local'))).getSingleOrNull();
    if (existing != null) return existing;
    final row = Setting(
      id: 'local',
      nativeLang: 'zh',
      learningLang: 'en',
      dailyNewLimit: 10,
      dailyReviewLimit: 50,
      reminderEnabled: true,
      reminderTime: '20:00',
      placementDone: false,
      placementLevelEn: null,
      placementLevelJa: null,
      dailyGoalMinutes: 15,
      onboarded: false,
      updatedAt: nowMs,
      deletedAt: null,
      syncStatus: 0,
    );
    await into(settings).insert(row, mode: InsertMode.insertOrIgnore);
    return row;
  }

  Stream<Setting> watchSettings({required int nowMs}) async* {
    // 确保行存在后再持续监听。
    await getOrCreate(nowMs: nowMs);
    yield* (select(settings)..where((s) => s.id.equals('local'))).watchSingle();
  }

  Future<void> updateSettings(SettingsCompanion patch, {required int nowMs}) {
    return (update(settings)..where((s) => s.id.equals('local'))).write(
      patch.copyWith(updatedAt: Value(nowMs)),
    );
  }
}
