import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'sync_format.dart';

/// 导入结果报告（UI 提示用）。
class ImportReport {
  const ImportReport({
    required this.applied,
    required this.skippedStale,
    required this.skippedUnknownWord,
  });

  /// 应用（新增或覆盖）的行数。
  final int applied;

  /// 本地已有更新版本而跳过的行数。
  final int skippedStale;

  /// wordId 不在本地词库而跳过的行数。
  final int skippedUnknownWord;
}

/// 导入备份 JSON：逐表 upsert，冲突策略 updatedAt 新者胜；
/// wordId 不在本地词库的行跳过并计数。
class ImportService {
  ImportService(this._db);

  final AppDatabase _db;

  Future<ImportReport> importJson(Map<String, dynamic> json) async {
    final data = parseBackupJson(json);
    var applied = 0;
    var stale = 0;
    var unknown = 0;

    await _db.transaction(() async {
      // ---- settings（单行，可缺省） ----
      // 设置行直接采用备份值：新设备首启也会生成更新的设置行，
      // 若按 updatedAt 新者胜，设置永远迁移不过去；导入是显式恢复动作。
      final settingsJson = data['settings'];
      if (settingsJson is Map<String, dynamic>) {
        final incoming = _settingsFromJson(settingsJson);
        await _db.into(_db.settings).insertOnConflictUpdate(incoming);
        applied++;
      }

      // ---- wordProgress ----
      final progressRows = (data['wordProgress'] as List?) ?? const [];
      for (final row in progressRows) {
        final p = (row as Map).cast<String, dynamic>();
        if (!await _wordExists(reqString(p, 'wordId'))) {
          unknown++;
          continue;
        }
        final id = reqString(p, 'id');
        final updatedAt = reqInt(p, 'updatedAt');
        final existing = await (_db.select(_db.wordProgress)
              ..where((r) => r.id.equals(id)))
            .getSingleOrNull();
        // 同一词可能有不同 id 的行（异常备份）：按 wordId 再查一次。
        final byWord = existing ??
            await (_db.select(_db.wordProgress)
                  ..where((r) => r.wordId.equals(reqString(p, 'wordId'))))
                .getSingleOrNull();
        if (byWord != null && byWord.updatedAt >= updatedAt) {
          stale++;
          continue;
        }
        if (byWord == null) {
          await _db.into(_db.wordProgress).insert(_progressCompanion(p));
        } else {
          await (_db.update(_db.wordProgress)
                ..where((r) => r.id.equals(byWord.id)))
              .write(_progressCompanion(p));
        }
        applied++;
      }

      // ---- studyLogs ----
      final logRows = (data['studyLogs'] as List?) ?? const [];
      for (final row in logRows) {
        final l = (row as Map).cast<String, dynamic>();
        if (!await _wordExists(reqString(l, 'wordId'))) {
          unknown++;
          continue;
        }
        final id = reqString(l, 'id');
        final updatedAt = reqInt(l, 'updatedAt');
        final existing = await (_db.select(_db.studyLogs)
              ..where((r) => r.id.equals(id)))
            .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          stale++;
          continue;
        }
        await _db.into(_db.studyLogs).insertOnConflictUpdate(_logCompanion(l));
        applied++;
      }

      // ---- dailyStats ----
      final statRows = (data['dailyStats'] as List?) ?? const [];
      for (final row in statRows) {
        final s = (row as Map).cast<String, dynamic>();
        final date = reqString(s, 'date');
        final updatedAt = reqInt(s, 'updatedAt');
        final existing = await (_db.select(_db.dailyStats)
              ..where((r) => r.date.equals(date)))
            .getSingleOrNull();
        if (existing != null && existing.updatedAt >= updatedAt) {
          stale++;
          continue;
        }
        await _db
            .into(_db.dailyStats)
            .insertOnConflictUpdate(_statCompanion(s));
        applied++;
      }
    });

    return ImportReport(
      applied: applied,
      skippedStale: stale,
      skippedUnknownWord: unknown,
    );
  }

  Future<bool> _wordExists(String wordId) async {
    final row = await (_db.select(_db.words)..where((w) => w.id.equals(wordId)))
        .getSingleOrNull();
    return row != null;
  }

  Setting _settingsFromJson(Map<String, dynamic> p) => Setting(
        id: reqString(p, 'id'),
        nativeLang: optString(p, 'nativeLang') ?? 'zh',
        learningLang: optString(p, 'learningLang') ?? 'en',
        dailyNewLimit: optInt(p, 'dailyNewLimit') ?? 10,
        dailyReviewLimit: optInt(p, 'dailyReviewLimit') ?? 50,
        reminderEnabled: optBool(p, 'reminderEnabled') ?? true,
        reminderTime: optString(p, 'reminderTime') ?? '20:00',
        placementDone: optBool(p, 'placementDone') ?? false,
        placementLevelEn: optString(p, 'placementLevelEn'),
        placementLevelJa: optString(p, 'placementLevelJa'),
        dailyGoalMinutes: optInt(p, 'dailyGoalMinutes') ?? 15,
        onboarded: optBool(p, 'onboarded') ?? false,
        updatedAt: reqInt(p, 'updatedAt'),
        deletedAt: optInt(p, 'deletedAt'),
        syncStatus: optInt(p, 'syncStatus') ?? 0,
      );

  WordProgressCompanion _progressCompanion(Map<String, dynamic> p) =>
      WordProgressCompanion.insert(
        id: reqString(p, 'id'),
        wordId: reqString(p, 'wordId'),
        language: reqString(p, 'language'),
        state: reqInt(p, 'state'),
        due: reqInt(p, 'due'),
        stability: Value(optDouble(p, 'stability')),
        difficulty: Value(optDouble(p, 'difficulty')),
        step: Value(optInt(p, 'step')),
        elapsedDays: reqInt(p, 'elapsedDays'),
        scheduledDays: reqInt(p, 'scheduledDays'),
        reps: reqInt(p, 'reps'),
        lapses: reqInt(p, 'lapses'),
        lastReviewAt: Value(optInt(p, 'lastReviewAt')),
        updatedAt: reqInt(p, 'updatedAt'),
        deletedAt: Value(optInt(p, 'deletedAt')),
        syncStatus: Value(optInt(p, 'syncStatus') ?? 0),
      );

  StudyLogsCompanion _logCompanion(Map<String, dynamic> p) =>
      StudyLogsCompanion.insert(
        id: reqString(p, 'id'),
        wordId: reqString(p, 'wordId'),
        mode: reqString(p, 'mode'),
        rating: reqInt(p, 'rating'),
        correct: reqBool(p, 'correct'),
        durationMs: reqInt(p, 'durationMs'),
        reviewLog: Value(optString(p, 'reviewLog')),
        studiedAt: reqInt(p, 'studiedAt'),
        updatedAt: reqInt(p, 'updatedAt'),
        deletedAt: Value(optInt(p, 'deletedAt')),
        syncStatus: Value(optInt(p, 'syncStatus') ?? 0),
      );

  DailyStatsCompanion _statCompanion(Map<String, dynamic> p) =>
      DailyStatsCompanion.insert(
        date: reqString(p, 'date'),
        updatedAt: reqInt(p, 'updatedAt'),
        newCount: Value(optInt(p, 'newCount') ?? 0),
        reviewCount: Value(optInt(p, 'reviewCount') ?? 0),
        correctCount: Value(optInt(p, 'correctCount') ?? 0),
        totalCount: Value(optInt(p, 'totalCount') ?? 0),
        minutes: Value(optInt(p, 'minutes') ?? 0),
      );
}
