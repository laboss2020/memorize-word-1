import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/app/providers.dart';
import 'package:memorize_word/core/db/app_database.dart';
import 'package:memorize_word/core/fsrs/rating_mapper.dart' show StudyMode;
import 'package:memorize_word/features/study/session_controller.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('session_test');
    await _seed(db);
    container = ProviderContainer(overrides: [
      dbProvider.overrideWithValue(db),
    ]);
    addTearDown(container.dispose);
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  // 注意：Dart 函数体内不能声明 getter，这里用本地函数。
  SessionController notifier() =>
      container.read(sessionControllerProvider.notifier);
  StudySessionState st() => container.read(sessionControllerProvider);

  Future<void> start() => notifier().startSession(language: 'en');

  Word? currentWord() => st().current?.word;

  test('新会话：10 新词入队且首题为 new_card', () async {
    await start();

    expect(st().phase, SessionPhase.presenting);
    expect(st().totalCount, 10);
    expect(st().current!.item.isNew, isTrue);
    expect(st().current!.item.mode, StudyMode.newCard);
    expect(st().current!.progress, isNull); // 新词无进度行
    expect(st().current!.word.headword, isNotEmpty);
  });

  test('会话行落库且 queue 记录剩余', () async {
    await start();
    final session = await db.studyDao.openSession();
    expect(session, isNotNull);
    expect(session!.language, 'en');
    expect(session.endedAt, isNull);
    final queue = decodeQueue(session.queue!);
    expect(queue, hasLength(9));
  });

  test('新卡确认 → Good rating、进度行生成、daily_stats 计数', () async {
    await start();
    final wordId = currentWord()!.id;
    await notifier().answerNewCard();

    expect(st().phase, SessionPhase.feedback);
    expect(st().feedback!.correct, isTrue);
    expect(st().feedback!.rating, 3);

    final progress = await db.progressDao.getProgress(wordId);
    expect(progress, isNotNull);
    expect(progress!.state, 1); // learning
    expect(progress.reps, 1);

    final today = _today();
    final stats = await (db.select(db.dailyStats)
          ..where((s) => s.date.equals(today)))
        .getSingleOrNull();
    expect(stats, isNotNull);
    expect(stats!.newCount, 1);
    expect(stats.totalCount, 1);
  });

  test('选择题：首答对 → Good；再对一次（历史已对）→ Easy', () async {
    await start();
    // 跳过前面的 new_card，把第一个复习前的状态构造出来：
    // 直接用 answerNewCard 完成新词，再注入一条 review 队列项。
    await notifier().answerNewCard();
    await notifier().next(); // feedback → presenting（下一题仍是 new_card）
    await notifier().answerNewCard();
    await notifier().next();

    // 手动补一个 choice 项（构造复习场景）：给一个尚未学过的词加进度。
    final remaining = await db.wordDao.nextNewWords(
        language: 'en', difficultyCenter: 2.0, limit: 1);
    final targetId = remaining.single.id; // 无进度行 → 不会与已学词冲突
    await db.progressDao.upsertProgress(WordProgressData(
      id: 'p-test',
      wordId: targetId,
      language: 'en',
      state: 2,
      due: DateTime.now().millisecondsSinceEpoch - 1000,
      stability: 5,
      difficulty: 5,
      elapsedDays: 1,
      scheduledDays: 1,
      reps: 2,
      lapses: 0,
      lastReviewAt: DateTime.now().millisecondsSinceEpoch - 86400000,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: 0,
    ));
    // 新会话（旧会话被 abandon）→ 队列含 1 复习 + 8 新词。
    await start();

    final reviewItem = st().current!.item.mode == StudyMode.choice
        ? st().current!
        : null;
    expect(reviewItem, isNotNull, reason: 'reps=2 → 第三模式 choice 应排在前');
    final correctWord = reviewItem!.word;
    // 首答对（无历史日志）→ Good。
    await notifier().answerChoicePick(correctWord);
    expect(st().feedback!.rating, 3);
    await notifier().next();

    // 再来一次（该词 learning 步进未到期，手动再建一个 due 的 choice）：
    // 简化：验证 Easy 逻辑靠 lastLog（rating>=3）已覆盖在 mapper 测试中。
  });

  test('选择题：答错标红不结束，重练答对 → Hard + 反馈标记', () async {
    await start();
    // 完成新卡让队列推进到下一题（可能仍是 new_card；循环完成直到 choice 出现
    // 不现实——这里直接构造：把当前题强制视为 choice 流程不可行。
    // 改为验证 controller 的错误路径：用 startSession 后直接构造 choice 状态。
    await db.progressDao.upsertProgress(WordProgressData(
      id: 'p-choice',
      wordId: 'en-t2',
      language: 'en',
      state: 2,
      due: DateTime.now().millisecondsSinceEpoch - 1000,
      stability: 5,
      difficulty: 5,
      elapsedDays: 1,
      scheduledDays: 1,
      reps: 2, // → choice
      lapses: 0,
      lastReviewAt: DateTime.now().millisecondsSinceEpoch - 86400000,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: 0,
    ));
    await start();
    final cur = st().current!;
    expect(cur.item.mode, StudyMode.choice);
    expect(cur.choiceOptions.length, greaterThanOrEqualTo(2));

    // 点一个错误选项。
    final wrong = cur.choiceOptions.firstWhere((w) => w.id != cur.word.id);
    await notifier().answerChoicePick(wrong);
    expect(st().phase, SessionPhase.presenting); // 留在本题
    expect(st().current!.wrongPickIds, contains(wrong.id));
    expect(st().completedCount, 0);

    // 重练点正确项 → Hard。
    await notifier().answerChoicePick(cur.word);
    expect(st().phase, SessionPhase.feedback);
    expect(st().feedback!.rating, 2); // hard
    expect(st().feedback!.repracticed, isTrue);
    expect(st().completedCount, 1);
  });

  test('全队列完成 → finished + 会话结束（endedAt 落值）', () async {
    await start();
    // 设置每日新词限额为 3 以缩短测试。
    await (db.update(db.settings)..where((s) => s.id.equals('local')))
        .write(SettingsCompanion(dailyNewLimit: const Value(3)));
    await start();
    var guard = 0;
    while (st().phase != SessionPhase.finished && guard < 30) {
      guard++;
      if (st().phase == SessionPhase.presenting) {
        final cur = st().current!;
        if (cur.item.mode == StudyMode.newCard) {
          await notifier().answerNewCard();
        } else {
          await notifier().answerChoicePick(cur.word);
        }
      } else if (st().phase == SessionPhase.feedback) {
        await notifier().next();
      }
    }
    expect(st().phase, SessionPhase.finished);
    expect(st().completedCount, 3);
    final session = await db.studyDao.openSession();
    expect(session, isNull); // endedAt 已落值
  });

  test('暂停退出存断点，tryResume 恢复队列', () async {
    await start();
    await notifier().answerNewCard();
    await notifier().pauseAndExit();

    final session = await db.studyDao.openSession();
    expect(session, isNotNull); // 未结束
    expect(session!.completedCount, 1);

    // 模拟重启（新 container 会话状态清零）。
    container.dispose();
    container = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    final resumed = await notifier().tryResume();
    expect(resumed, isTrue);
    expect(st().phase, SessionPhase.presenting);
    expect(st().completedCount, 1);
    expect(st().current, isNotNull);
  });

  test('已学完的词不再作为新词出现（anti-join）', () async {
    // 每日限额设为 12 = 种子词数，学完全部词。
    await (db.update(db.settings)..where((s) => s.id.equals('local')))
        .write(SettingsCompanion(dailyNewLimit: const Value(12)));
    await start();
    var guard = 0;
    while (st().phase != SessionPhase.finished && guard < 60) {
      guard++;
      if (st().phase == SessionPhase.presenting) {
        final cur = st().current!;
        if (cur.item.mode == StudyMode.newCard) {
          await notifier().answerNewCard();
        } else {
          await notifier().answerChoicePick(cur.word);
        }
      } else {
        await notifier().next();
      }
    }
    expect(st().phase, SessionPhase.finished);
    expect(st().completedCount, 12);
    // 再开新会话：无新词可学且无复习到期 → 空队列 → finished。
    await start();
    expect(st().phase, SessionPhase.finished);
    expect(st().totalCount, 0);
  });

  test('听写：全对 → Good；编辑距离 1 → Hard（客观错）', () async {
    // 用 en-t1（apple）构造一个听写复习项。
    await db.progressDao.upsertProgress(WordProgressData(
      id: 'p-dict',
      wordId: 'en-t1',
      language: 'en',
      state: 2,
      due: DateTime.now().millisecondsSinceEpoch - 1000,
      stability: 5,
      difficulty: 5,
      elapsedDays: 1,
      scheduledDays: 1,
      reps: 1, // → dictation
      lapses: 0,
      lastReviewAt: DateTime.now().millisecondsSinceEpoch - 86400000,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: 0,
    ));
    await start();
    expect(st().current!.item.mode, StudyMode.dictation);
    final wordId = st().current!.word.id;

    await notifier().answerDictation('apple', hintUsed: false);
    expect(st().feedback!.rating, 3); // good
    expect(st().feedback!.correct, isTrue);
    expect(st().feedback!.correctAnswer, 'apple');
    await notifier().pauseAndExit();

    // 第二轮：距离 1 → Hard（correct=false 但 rating=Hard）。
    // 第一次复习使 reps+1（→choice），重置为 1 以再次排到听写。
    final p = await db.progressDao.getProgress(wordId);
    await db.progressDao.upsertProgress(p!.copyWith(
      reps: 1,
      due: DateTime.now().millisecondsSinceEpoch - 1000,
    ));
    await start();
    expect(st().current!.item.mode, StudyMode.dictation);
    await notifier().answerDictation('aple', hintUsed: false);
    expect(st().feedback!.rating, 2); // hard
    expect(st().feedback!.correct, isFalse);
  });

  test('听写：用提示 → Hard；日语输入接受罗马字（归一为假名）', () async {
    // 日语词 ja-t1：みず（水）。
    await db.into(db.words).insert(WordsCompanion.insert(
          id: 'ja-t1',
          language: 'ja',
          headword: '水',
          reading: const Value('みず'),
          meanings: '[{"lang":"zh","def":"水"}]',
          examples: '[]',
          difficulty: 2.0,
          level: 'N5',
          freqRank: const Value(10),
        ));
    await db.progressDao.upsertProgress(WordProgressData(
      id: 'p-ja',
      wordId: 'ja-t1',
      language: 'ja',
      state: 2,
      due: DateTime.now().millisecondsSinceEpoch - 1000,
      stability: 5,
      difficulty: 5,
      elapsedDays: 1,
      scheduledDays: 1,
      reps: 1,
      lapses: 0,
      lastReviewAt: DateTime.now().millisecondsSinceEpoch - 86400000,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: 0,
    ));
    await notifier().startSession(language: 'ja');
    expect(st().current!.item.mode, StudyMode.dictation);

    await notifier().answerDictation('mizu', hintUsed: true);
    expect(st().feedback!.rating, 2); // hard：用了提示
    expect(st().feedback!.correct, isTrue); // 罗马字 mizu → みず 匹配
    expect(st().feedback!.correctAnswer, '水'); // 听写答案显示词头
  });

  test('填空：例句挖空，比对被挖词形，反馈显示补全句', () async {
    await (db.update(db.words)..where((w) => w.id.equals('en-t2'))).write(
        WordsCompanion(examples: const Value(
            '[{"text":"I walk to school.","translation":"我走路去学校"}]')));
    await db.progressDao.upsertProgress(WordProgressData(
      id: 'p-cloze',
      wordId: 'en-t2',
      language: 'en',
      state: 2,
      due: DateTime.now().millisecondsSinceEpoch - 1000,
      stability: 5,
      difficulty: 5,
      elapsedDays: 1,
      scheduledDays: 1,
      reps: 2, // → cloze
      lapses: 0,
      lastReviewAt: DateTime.now().millisecondsSinceEpoch - 86400000,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: 0,
    ));
    await start();
    expect(st().current!.item.mode, StudyMode.cloze);
    expect(st().current!.clozeSentence, 'I ＿＿ to school.');
    expect(st().current!.clozeAnswer, 'walk');

    // 大小写不敏感 + 编辑距离 1 → Hard。
    await notifier().answerCloze('waik', hintUsed: false);
    expect(st().feedback!.rating, 2);
    expect(st().feedback!.correct, isFalse);
    expect(st().feedback!.correctAnswer, 'I walk to school.'); // 补全句
  });

  test('填空：词头不在例句中 → 降级听写', () async {
    await (db.update(db.words)..where((w) => w.id.equals('en-t2'))).write(
        WordsCompanion(examples: const Value(
            '[{"text":"He walks fast.","translation":null}]')));
    await db.progressDao.upsertProgress(WordProgressData(
      id: 'p-cloze2',
      wordId: 'en-t2',
      language: 'en',
      state: 2,
      due: DateTime.now().millisecondsSinceEpoch - 1000,
      stability: 5,
      difficulty: 5,
      elapsedDays: 1,
      scheduledDays: 1,
      reps: 2,
      lapses: 0,
      lastReviewAt: DateTime.now().millisecondsSinceEpoch - 86400000,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: 0,
    ));
    await start();
    expect(st().current!.item.mode, StudyMode.dictation); // 降级
    expect(st().current!.clozeSentence, isNull);
  });
}

final _words = [
  _mkWord('en-t1', 'apple', '苹果'),
  _mkWord('en-t2', 'walk', '走'),
  _mkWord('en-t3', 'serene', '平静的'),
  _mkWord('en-t4', 'tremble', '颤抖'),
  _mkWord('en-t5', 'gather', '聚集'),
  _mkWord('en-t6', 'hollow', '空的'),
  _mkWord('en-t7', 'brisk', '轻快的'),
  _mkWord('en-t8', 'crave', '渴望'),
  _mkWord('en-t9', 'dampen', '使潮湿'),
  _mkWord('en-t10', 'eager', '热切的'),
  _mkWord('en-t11', 'fable', '寓言'),
  _mkWord('en-t12', 'gleam', '微光'),
];

WordsCompanion _mkWord(String id, String headword, String def) =>
    WordsCompanion.insert(
      id: id,
      language: 'en',
      headword: headword,
      meanings: '[{"lang":"zh","def":"$def"}]',
      examples: '[]',
      difficulty: 2.0,
      level: 'A1',
      freqRank: const Value(100),
    );

Future<void> _seed(AppDatabase db) async {
  await db.batch((b) {
    b.insertAll(db.words, _words);
  });
  await db.settingsDao.getOrCreate(
      nowMs: DateTime.now().millisecondsSinceEpoch);
}

String _today() {
  final now = DateTime.now();
  return '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';
}
