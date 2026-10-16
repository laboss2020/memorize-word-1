import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.settingsDao.getOrCreate(
        nowMs: DateTime.now().millisecondsSinceEpoch);
  });

  tearDown(() async {
    await db.close();
  });

  WordsCompanion wordRow(String id, String headword,
          {String language = 'en'}) =>
      WordsCompanion.insert(
        id: id,
        language: language,
        headword: headword,
        meanings: '[{"lang":"zh","def":"测试"}]',
        examples: '[]',
        difficulty: 2.0,
        level: 'A1',
        freqRank: const Value(1),
      );

  group('watchTotals', () {
    test('空表返回全 0（COALESCE 兜底）', () async {
      final totals = await db.studyDao.watchTotals().first;
      expect(totals.total, 0);
      expect(totals.correct, 0);
      expect(totals.minutes, 0);
      expect(totals.newWords, 0);
      expect(totals.reviews, 0);
    });

    test('多日求和', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.studyDao.bumpDailyStats(
          date: '2026-10-01',
          newCount: 10,
          reviewCount: 20,
          correctCount: 25,
          minutes: 15,
          nowMs: now);
      await db.studyDao.bumpDailyStats(
          date: '2026-10-02',
          newCount: 5,
          reviewCount: 10,
          correctCount: 12,
          minutes: 8,
          nowMs: now);
      final totals = await db.studyDao.watchTotals().first;
      expect(totals.total, 45);
      expect(totals.correct, 37);
      expect(totals.minutes, 23);
      expect(totals.newWords, 15);
      expect(totals.reviews, 30);
    });
  });

  group('watchMastery', () {
    test('无进度时全部为未学；按语言过滤', () async {
      await db.batch((b) {
        b.insertAll(db.words, [
          wordRow('en-1', 'apple'),
          wordRow('en-2', 'walk'),
          wordRow('ja-1', '水', language: 'ja'),
        ]);
      });
      final m = await db.progressDao.watchMastery('en').first;
      expect(m.fresh, 2);
      expect(m.learning, 0);
      expect(m.young, 0);
      expect(m.mature, 0);

      final ja = await db.progressDao.watchMastery('ja').first;
      expect(ja.fresh, 1);
    });

    test('按 state 与 stability 分桶（fresh/learning/young/mature）', () async {
      await db.batch((b) {
        b.insertAll(db.words, [
          wordRow('en-1', 'apple'),
          wordRow('en-2', 'walk'),
          wordRow('en-3', 'serene'),
          wordRow('en-4', 'tremble'),
          wordRow('en-5', 'gather'),
        ]);
      });
      final now = DateTime.now().millisecondsSinceEpoch;
      WordProgressData progress(String wordId, int state, double stability) =>
          WordProgressData(
            id: 'p-$wordId',
            wordId: wordId,
            language: 'en',
            state: state,
            due: now + 86400000,
            stability: stability,
            difficulty: 5,
            elapsedDays: 1,
            scheduledDays: 1,
            reps: 2,
            lapses: 0,
            lastReviewAt: now,
            updatedAt: now,
            syncStatus: 0,
          );
      await db.progressDao.upsertProgress(progress('en-1', 1, 0.5)); // learning
      await db.progressDao.upsertProgress(progress('en-2', 3, 0.1)); // relearning → learning 桶
      await db.progressDao.upsertProgress(progress('en-3', 2, 10)); // young
      await db.progressDao.upsertProgress(progress('en-4', 2, 30)); // mature
      // en-5 无进度 → fresh。

      final m = await db.progressDao.watchMastery('en').first;
      expect(m.fresh, 1);
      expect(m.learning, 2);
      expect(m.young, 1);
      expect(m.mature, 1);
    });

    test('软删除的进度不算已学（回到 fresh）', () async {
      await db.batch((b) {
        b.insertAll(db.words, [wordRow('en-1', 'apple')]);
      });
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.progressDao.upsertProgress(WordProgressData(
        id: 'p-1',
        wordId: 'en-1',
        language: 'en',
        state: 2,
        due: now,
        stability: 30,
        difficulty: 5,
        elapsedDays: 1,
        scheduledDays: 30,
        reps: 5,
        lapses: 0,
        lastReviewAt: now,
        updatedAt: now,
        syncStatus: 0,
      ));
      await db.progressDao.softDelete('en-1', nowMs: now);
      final m = await db.progressDao.watchMastery('en').first;
      expect(m.fresh, 1);
      expect(m.mature, 0);
    });
  });
}
