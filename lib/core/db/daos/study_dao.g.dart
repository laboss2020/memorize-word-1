// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_dao.dart';

// ignore_for_file: type=lint
mixin _$StudyDaoMixin on DatabaseAccessor<AppDatabase> {
  $StudyLogsTable get studyLogs => attachedDatabase.studyLogs;
  $DailyStatsTable get dailyStats => attachedDatabase.dailyStats;
  $StudySessionsTable get studySessions => attachedDatabase.studySessions;
  StudyDaoManager get managers => StudyDaoManager(this);
}

class StudyDaoManager {
  final _$StudyDaoMixin _db;
  StudyDaoManager(this._db);
  $$StudyLogsTableTableManager get studyLogs =>
      $$StudyLogsTableTableManager(_db.attachedDatabase, _db.studyLogs);
  $$DailyStatsTableTableManager get dailyStats =>
      $$DailyStatsTableTableManager(_db.attachedDatabase, _db.dailyStats);
  $$StudySessionsTableTableManager get studySessions =>
      $$StudySessionsTableTableManager(_db.attachedDatabase, _db.studySessions);
}
