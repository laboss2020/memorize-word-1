import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/progress_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/study_dao.dart';
import 'daos/word_dao.dart';
import 'tables/user.dart';
import 'tables/words.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    // 词库（种子，只读）
    Words,
    Decks,
    DeckWords,
    // 用户数据
    WordProgress,
    StudyLogs,
    Settings,
    DailyStats,
    StudySessions,
    Meta,
  ],
  daos: [WordDao, ProgressDao, StudyDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  static AppDatabase? _instance;

  /// 应用级单例。
  factory AppDatabase.instance() => _instance ??= AppDatabase(driftDatabase(
        name: 'memorize_word',
      ));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // 后续版本在此添加 stepByStep 迁移。
        },
      );

  /// 首次打开时确认用户数据行为空（全新安装）。
  Future<bool> get isEmpty async {
    final c = countAll();
    final q = selectOnly(words)..addColumns([c]);
    return (await q.map((row) => row.read(c) ?? 0).getSingle()) == 0;
  }
}
