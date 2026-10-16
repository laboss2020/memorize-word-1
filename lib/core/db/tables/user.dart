import 'package:drift/drift.dart';

/// 用户学习进度（FSRS 卡片状态）。
///
/// 一词一行，state 使用 fsrs 包的 State 编码：1=learning, 2=review, 3=relearning。
/// 未学过的词没有本表行（"新词"即无行）。
@TableIndex(name: 'idx_progress_due', columns: {#due})
@TableIndex(name: 'idx_progress_lang_state', columns: {#language, #state})
class WordProgress extends Table {
  TextColumn get id => text()(); // UUIDv7
  TextColumn get wordId => text()();

  @override
  List<Set<Column>> get uniqueKeys => [{wordId}];

  TextColumn get language => text()();
  IntColumn get state => integer()();
  IntColumn get due => integer()(); // 下次到期 unix ms（UTC）
  RealColumn get stability => real().nullable()();
  RealColumn get difficulty => real().nullable()(); // FSRS 难度 1-10
  IntColumn get step => integer().nullable()(); // learning/relearning 步进索引
  IntColumn get elapsedDays => integer()();
  IntColumn get scheduledDays => integer()();
  IntColumn get reps => integer()();
  IntColumn get lapses => integer()();
  IntColumn get lastReviewAt => integer().nullable()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()(); // 软删除
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 学习日志：每次答题一条；fsrs ReviewLog JSON 同时存于此，也是统计数据源。
@TableIndex(name: 'idx_logs_word_time', columns: {#wordId, #studiedAt})
@TableIndex(name: 'idx_logs_studied_at', columns: {#studiedAt})
class StudyLogs extends Table {
  TextColumn get id => text()(); // UUIDv7
  TextColumn get wordId => text()();
  TextColumn get mode => text()(); // new_card|choice|dictation|cloze|placement
  IntColumn get rating => integer()(); // fsrs Rating: 1-4
  BoolColumn get correct => boolean()(); // 客观对错
  IntColumn get durationMs => integer()();
  TextColumn get reviewLog => text().nullable()(); // fsrs ReviewLog JSON
  IntColumn get studiedAt => integer()(); // unix ms（UTC）
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 应用设置（单行模式：id='local'）。
class Settings extends Table {
  TextColumn get id => text().clientDefault(() => 'local')();
  TextColumn get nativeLang => text().withDefault(const Constant('zh'))(); // 界面语言
  TextColumn get learningLang => text().withDefault(const Constant('en'))(); // 当前学习语言
  IntColumn get dailyNewLimit => integer().withDefault(const Constant(10))();
  IntColumn get dailyReviewLimit => integer().withDefault(const Constant(50))();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get reminderTime => text().withDefault(const Constant('20:00'))(); // HH:mm 本地时区
  BoolColumn get placementDone => boolean().withDefault(const Constant(false))();
  TextColumn get placementLevelEn => text().nullable()(); // 如 'B1'
  TextColumn get placementLevelJa => text().nullable()(); // 如 'N3'
  IntColumn get dailyGoalMinutes => integer().withDefault(const Constant(15))();
  BoolColumn get onboarded => boolean().withDefault(const Constant(false))();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 每日统计汇总（本地学习日 YYYY-MM-DD 为主键）。
class DailyStats extends Table {
  TextColumn get date => text()(); // 'YYYY-MM-DD'
  IntColumn get newCount => integer().withDefault(const Constant(0))();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get totalCount => integer().withDefault(const Constant(0))();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {date};
}

/// 学习会话断点（随时停止/继续）：endedAt 为 NULL 表示进行中。
class StudySessions extends Table {
  TextColumn get id => text()(); // UUIDv7
  TextColumn get language => text()();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  TextColumn get queue => text().nullable()(); // 剩余队列 JSON [{wordId,mode}]
  IntColumn get completedCount => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// schema/种子版本等元数据。
class Meta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
