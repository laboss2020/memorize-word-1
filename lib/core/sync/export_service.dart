import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../db/app_database.dart';
import 'sync_format.dart';

/// 导出统计（UI 提示用）。
class ExportResult {
  const ExportResult({
    required this.path,
    required this.progressCount,
    required this.logCount,
    required this.statCount,
  });

  final String path;
  final int progressCount;
  final int logCount;
  final int statCount;
}

/// 导出用户数据为 JSON（词库不导出，wordId 为确定性 UUIDv5）。
class ExportService {
  ExportService(this._db, {required this.tempDir});

  final AppDatabase _db;
  final Directory tempDir;

  /// 构建备份 JSON（纯数据，测试用）。
  Future<Map<String, dynamic>> buildBackupJson() async {
    final settings = await (_db.select(_db.settings)
          ..where((s) => s.id.equals('local')))
        .getSingleOrNull();
    final progress = await _db.select(_db.wordProgress).get();
    final logs = await _db.select(_db.studyLogs).get();
    final stats = await _db.select(_db.dailyStats).get();

    return {
      'format': backupFormatName,
      'formatVersion': backupFormatVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'data': {
        'settings': settings == null ? null : _settingsToJson(settings),
        'wordProgress': [for (final r in progress) _progressToJson(r)],
        'studyLogs': [for (final r in logs) _logToJson(r)],
        'dailyStats': [for (final r in stats) _statToJson(r)],
      },
    };
  }

  /// 写入临时文件并返回结果（UI 拿路径去分享/保存）。
  Future<ExportResult> writeBackupToTemp() async {
    final json = await buildBackupJson();
    final now = DateTime.now();
    final name = 'memorize-word-backup-'
        '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}-'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}.json';
    final file = File(p.join(tempDir.path, name));
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(json));
    final data = json['data'] as Map<String, dynamic>;
    return ExportResult(
      path: file.path,
      progressCount: (data['wordProgress'] as List).length,
      logCount: (data['studyLogs'] as List).length,
      statCount: (data['dailyStats'] as List).length,
    );
  }

  Map<String, dynamic> _settingsToJson(Setting s) => {
        'id': s.id,
        'nativeLang': s.nativeLang,
        'learningLang': s.learningLang,
        'dailyNewLimit': s.dailyNewLimit,
        'dailyReviewLimit': s.dailyReviewLimit,
        'reminderEnabled': s.reminderEnabled,
        'reminderTime': s.reminderTime,
        'placementDone': s.placementDone,
        'placementLevelEn': s.placementLevelEn,
        'placementLevelJa': s.placementLevelJa,
        'dailyGoalMinutes': s.dailyGoalMinutes,
        'onboarded': s.onboarded,
        'updatedAt': s.updatedAt,
        'deletedAt': s.deletedAt,
        'syncStatus': s.syncStatus,
      };

  Map<String, dynamic> _progressToJson(WordProgressData r) => {
        'id': r.id,
        'wordId': r.wordId,
        'language': r.language,
        'state': r.state,
        'due': r.due,
        'stability': r.stability,
        'difficulty': r.difficulty,
        'step': r.step,
        'elapsedDays': r.elapsedDays,
        'scheduledDays': r.scheduledDays,
        'reps': r.reps,
        'lapses': r.lapses,
        'lastReviewAt': r.lastReviewAt,
        'updatedAt': r.updatedAt,
        'deletedAt': r.deletedAt,
        'syncStatus': r.syncStatus,
      };

  Map<String, dynamic> _logToJson(StudyLog r) => {
        'id': r.id,
        'wordId': r.wordId,
        'mode': r.mode,
        'rating': r.rating,
        'correct': r.correct,
        'durationMs': r.durationMs,
        'reviewLog': r.reviewLog,
        'studiedAt': r.studiedAt,
        'updatedAt': r.updatedAt,
        'deletedAt': r.deletedAt,
        'syncStatus': r.syncStatus,
      };

  Map<String, dynamic> _statToJson(DailyStat r) => {
        'date': r.date,
        'newCount': r.newCount,
        'reviewCount': r.reviewCount,
        'correctCount': r.correctCount,
        'totalCount': r.totalCount,
        'minutes': r.minutes,
        'updatedAt': r.updatedAt,
      };
}
