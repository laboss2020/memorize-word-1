import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/db/app_database.dart';
import 'package:memorize_word/core/sync/export_service.dart';
import 'package:memorize_word/core/sync/import_service.dart';
import 'package:memorize_word/core/sync/sync_format.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('sync_test');
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<void> seed() async {
    await db.batch((b) {
      b.insertAll(db.words, [
        WordsCompanion.insert(
          id: 'en-w1',
          language: 'en',
          headword: 'apple',
          meanings: '[{"lang":"zh","def":"苹果"}]',
          examples: '[]',
          difficulty: 1.5,
          level: 'A1',
        ),
        WordsCompanion.insert(
          id: 'en-w2',
          language: 'en',
          headword: 'walk',
          meanings: '[{"lang":"zh","def":"走"}]',
          examples: '[]',
          difficulty: 1.5,
          level: 'A1',
        ),
      ]);
    });
    await db.into(db.wordProgress).insert(WordProgressCompanion.insert(
          id: 'p1',
          wordId: 'en-w1',
          language: 'en',
          state: 2,
          due: 1760000000000,
          elapsedDays: 3,
          scheduledDays: 5,
          reps: 4,
          lapses: 0,
          lastReviewAt: const Value(1759000000000),
          updatedAt: 1760000000000,
        ));
    await db.into(db.studyLogs).insert(StudyLogsCompanion.insert(
          id: 'l1',
          wordId: 'en-w1',
          mode: 'choice',
          rating: 3,
          correct: true,
          durationMs: 1200,
          studiedAt: 1759000000000,
          updatedAt: 1759000000000,
        ));
    await db.into(db.dailyStats).insert(DailyStatsCompanion.insert(
          date: '2026-10-14',
          updatedAt: 1760000000000,
          totalCount: Value(10),
          correctCount: Value(8),
          newCount: Value(5),
          reviewCount: Value(5),
          minutes: Value(3),
        ));
    await db.settingsDao.getOrCreate(nowMs: 1760000000000);
  }

  test('roundtrip：导出 → 清空 → 导入，数据一致', () async {
    await seed();
    final exporter = ExportService(db, tempDir: tempDir);
    final json = await exporter.buildBackupJson();

    // 清空全部用户数据（模拟新设备）。
    await db.batch((b) {
      b.deleteAll(db.wordProgress);
      b.deleteAll(db.studyLogs);
      b.deleteAll(db.dailyStats);
    });

    final report = await ImportService(db).importJson(json);
    expect(report.skippedUnknownWord, 0);
    expect(report.skippedStale, 0);

    final progress = await db.select(db.wordProgress).get();
    expect(progress, hasLength(1));
    expect(progress.single.id, 'p1');
    expect(progress.single.due, 1760000000000);
    expect(progress.single.reps, 4);

    final logs = await db.select(db.studyLogs).get();
    expect(logs, hasLength(1));
    expect(logs.single.mode, 'choice');
    expect(logs.single.correct, isTrue);

    final stats = await db.select(db.dailyStats).get();
    expect(stats.single.date, '2026-10-14');
    expect(stats.single.totalCount, 10);
    expect(stats.single.correctCount, 8);

    final settings = await (db.select(db.settings)
          ..where((s) => s.id.equals('local')))
        .getSingle();
    expect(settings.updatedAt, 1760000000000);
    expect(report.applied, 4); // 1 progress + 1 log + 1 stat + 1 settings
  });

  test('导出文件落盘且可读回', () async {
    await seed();
    final result =
        await ExportService(db, tempDir: tempDir).writeBackupToTemp();
    expect(File(result.path).existsSync(), isTrue);
    expect(result.progressCount, 1);
    expect(result.logCount, 1);
    expect(result.statCount, 1);

    final json =
        jsonDecode(await File(result.path).readAsString()) as Map<String, dynamic>;
    expect(json['format'], backupFormatName);
    final data = parseBackupJson(json);
    expect((data['studyLogs'] as List), hasLength(1));
  });

  test('冲突策略：本地更新则跳过（updatedAt 新者胜）', () async {
    await seed();
    final json = await ExportService(db, tempDir: tempDir).buildBackupJson();

    // 本地把进度行改新：reps=9, updatedAt 更大。
    await (db.update(db.wordProgress)..where((r) => r.id.equals('p1'))).write(
      WordProgressCompanion(reps: const Value(9), updatedAt: const Value(1760000000001)),
    );

    final report = await ImportService(db).importJson(json);
    // 进度行本地更新 → 跳过；日志/统计行时间戳相等（相等也算本地胜）→ 跳过；
    // 设置行始终采用备份值。
    expect(report.skippedStale, 3);
    expect(report.applied, 1);
    final progress = await db.select(db.wordProgress).get();
    expect(progress.single.reps, 9); // 保留本地新值
  });

  test('冲突策略：导入更新则覆盖本地', () async {
    await seed();
    final json = await ExportService(db, tempDir: tempDir).buildBackupJson();
    // 本地把行改旧（更小的 updatedAt）。
    await (db.update(db.wordProgress)..where((r) => r.id.equals('p1'))).write(
      WordProgressCompanion(reps: const Value(2), updatedAt: const Value(1750000000000)),
    );

    final report = await ImportService(db).importJson(json);
    // 进度行备份更新 → 覆盖；日志/统计相等 → 跳过；设置 → 应用。
    expect(report.skippedStale, 2);
    expect(report.applied, 2);
    final progress = await db.select(db.wordProgress).get();
    expect(progress.single.reps, 4); // 备份值覆盖
  });

  test('wordId 不在词库 → 跳过并报告', () async {
    await seed();
    final json = await ExportService(db, tempDir: tempDir).buildBackupJson();
    final data = json['data'] as Map<String, dynamic>;
    (data['studyLogs'] as List).add({
      'id': 'l-ghost',
      'wordId': 'en-ghost',
      'mode': 'choice',
      'rating': 3,
      'correct': true,
      'durationMs': 100,
      'reviewLog': null,
      'studiedAt': 1759000000000,
      'updatedAt': 1759000000000,
      'deletedAt': null,
      'syncStatus': 0,
    });

    final report = await ImportService(db).importJson(json);
    expect(report.skippedUnknownWord, 1);
    final logs = await db.select(db.studyLogs).get();
    expect(logs.map((l) => l.id), isNot(contains('l-ghost')));
  });

  test('坏格式拒绝：format 不符 / 版本过高 / 缺 data', () {
    expect(
      () => parseBackupJson({'format': 'other', 'formatVersion': 1}),
      throwsA(isA<BackupFormatException>()),
    );
    expect(
      () => parseBackupJson({
            'format': backupFormatName,
            'formatVersion': 99,
            'data': {},
          }),
      throwsA(isA<BackupFormatException>()),
    );
    expect(
      () => parseBackupJson({
            'format': backupFormatName,
            'formatVersion': 1,
          }),
      throwsA(isA<BackupFormatException>()),
    );
  });
}
