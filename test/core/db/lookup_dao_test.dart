import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/db/app_database.dart';

/// 点词查字典（lookupByHeadword/headwordForms）与已学单词列表查询。
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

  WordsCompanion wordRow(
    String id,
    String headword, {
    String language = 'en',
    String? pos,
    String? phonetic,
    int? freqRank,
  }) =>
      WordsCompanion.insert(
        id: id,
        language: language,
        headword: headword,
        pos: Value(pos),
        phonetic: Value(phonetic),
        meanings: '[{"lang":"zh","def":"测试-$id"}]',
        examples: '[]',
        difficulty: 2.0,
        level: 'A1',
        freqRank: Value(freqRank),
      );

  WordProgressData progress(String wordId,
      {int state = 2, double stability = 5, required int lastReviewAt}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return WordProgressData(
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
      lastReviewAt: lastReviewAt,
      updatedAt: now,
      syncStatus: 0,
    );
  }

  group('lookupByHeadword', () {
    test('精确命中（忽略大小写），取频率序第一个', () async {
      await db.batch((b) {
        b.insertAll(db.words, [
          wordRow('en-1', 'Apple', freqRank: 2),
          wordRow('en-2', 'apple', freqRank: 1),
        ]);
      });
      final w = await db.wordDao.lookupByHeadword('en', 'APPLE');
      expect(w, isNotNull);
      expect(w!.id, 'en-2');
    });

    test('未命中返回 null', () async {
      await db.batch((b) {
        b.insertAll(db.words, [wordRow('en-1', 'apple')]);
      });
      expect(await db.wordDao.lookupByHeadword('en', 'zebra'), isNull);
      expect(await db.wordDao.lookupByHeadword('ja', 'apple'), isNull);
    });
  });

  group('headwordForms', () {
    test('en 小写化；ja 含 headword 与 reading', () async {
      await db.batch((b) {
        b.insertAll(db.words, [
          wordRow('en-1', 'Apple'),
          WordsCompanion.insert(
            id: 'ja-1',
            language: 'ja',
            headword: '水',
            reading: const Value('みず'),
            meanings: '[{"lang":"zh","def":"水"}]',
            examples: '[]',
            difficulty: 2.0,
            level: 'N5',
          ),
        ]);
      });
      final en = await db.wordDao.headwordForms('en');
      expect(en, {'apple'});
      final ja = await db.wordDao.headwordForms('ja');
      expect(ja, containsAll(['水', 'みず']));
    });
  });

  group('watchLearnedWords / watchLearnedCount', () {
    test('按最近学习倒序、语言过滤、计数一致', () async {
      await db.batch((b) {
        b.insertAll(db.words, [
          wordRow('en-1', 'apple', pos: 'n', phonetic: 'ˈæpl'),
          wordRow('en-2', 'walk', pos: 'v'),
          wordRow('ja-1', '水', language: 'ja'),
        ]);
      });
      await db.progressDao.upsertProgress(
          progress('en-1', lastReviewAt: 100));
      await db.progressDao.upsertProgress(
          progress('en-2', state: 1, lastReviewAt: 200));

      final list = await db.progressDao.watchLearnedWords(language: 'en').first;
      expect(list.map((e) => e.$1.id), ['en-2', 'en-1']);
      expect(list[0].$2.state, 1);

      final count = await db.progressDao.watchLearnedCount('en').first;
      expect(count, 2);
      final jaCount = await db.progressDao.watchLearnedCount('ja').first;
      expect(jaCount, 0);
    });

    test('筛选：学习中/巩固中/已掌握（stability≥21）', () async {
      await db.batch((b) {
        b.insertAll(db.words, [
          wordRow('en-1', 'apple'),
          wordRow('en-2', 'walk'),
          wordRow('en-3', 'serene'),
        ]);
      });
      await db.progressDao
          .upsertProgress(progress('en-1', state: 1, lastReviewAt: 100));
      await db.progressDao.upsertProgress(progress('en-2',
          state: 2, stability: 10, lastReviewAt: 200));
      await db.progressDao.upsertProgress(progress('en-3',
          state: 2, stability: 30, lastReviewAt: 300));

      final learning =
          await db.progressDao.watchLearnedWords(language: 'en', filter: 1).first;
      expect(learning.map((e) => e.$1.id), ['en-1']);
      final young =
          await db.progressDao.watchLearnedWords(language: 'en', filter: 2).first;
      expect(young.map((e) => e.$1.id), ['en-2']);
      final mature =
          await db.progressDao.watchLearnedWords(language: 'en', filter: 3).first;
      expect(mature.map((e) => e.$1.id), ['en-3']);
      final all =
          await db.progressDao.watchLearnedWords(language: 'en').first;
      expect(all, hasLength(3));
    });

    test('软删除的词不出现', () async {
      await db.batch((b) {
        b.insertAll(db.words, [wordRow('en-1', 'apple')]);
      });
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.progressDao.upsertProgress(progress('en-1', lastReviewAt: now));
      await db.progressDao.softDelete('en-1', nowMs: now);
      final list = await db.progressDao.watchLearnedWords(language: 'en').first;
      expect(list, isEmpty);
      expect(await db.progressDao.watchLearnedCount('en').first, 0);
    });
  });
}
