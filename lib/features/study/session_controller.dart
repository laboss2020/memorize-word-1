/// 学习会话状态机：加载队列 → 逐题呈现 → 即时反馈 → 汇总/断点。
///
/// 队列来自 scheduler.buildTodayQueue（复习配额与新词配额交错），
/// 断点持久化到 study_sessions（endedAt IS NULL = 进行中，可续学）。
/// 每个队列项完结时产生恰好 1 条 FSRS rating；中间错选只记 study_logs。
library;

import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:fsrs/fsrs.dart' show Rating;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart';
import '../../core/fsrs/fsrs_service.dart';
import '../../core/fsrs/rating_mapper.dart';
import '../../core/fsrs/scheduler.dart';
import '../../core/utils/levels.dart';
import '../../core/utils/study_day.dart';
import '../../core/utils/text_match.dart';
import '../../core/utils/word_content.dart';

enum SessionPhase { loading, presenting, feedback, finished, error }

/// 当前队列项的呈现数据。
class SessionItemState {
  const SessionItemState({
    required this.item,
    required this.word,
    required this.progress,
    this.choiceOptions = const [],
    this.wrongPickIds = const {},
    this.clozeSentence,
    this.clozeAnswer,
    this.clozeTranslation,
  });

  final QueueItem item;
  final Word word;
  final WordProgressData? progress; // null = 新词首呈
  final List<Word> choiceOptions; // choice 模式的选项（含正确项）
  final Set<String> wrongPickIds; // 本题答错的选项（UI 标红）

  /// 填空模式：挖空句 / 被挖词形 / 句子翻译（例句不可挖空时为 null → 降级听写）。
  final String? clozeSentence;
  final String? clozeAnswer;
  final String? clozeTranslation;

  SessionItemState copyWith({Set<String>? wrongPickIds}) => SessionItemState(
        item: item,
        word: word,
        progress: progress,
        choiceOptions: choiceOptions,
        wrongPickIds: wrongPickIds ?? this.wrongPickIds,
        clozeSentence: clozeSentence,
        clozeAnswer: clozeAnswer,
        clozeTranslation: clozeTranslation,
      );
}

/// 答题反馈（feedback 阶段展示）。
class ItemFeedback {
  const ItemFeedback({
    required this.correct,
    required this.rating,
    required this.repracticed,
    this.correctAnswer,
  });

  final bool correct;
  final int rating; // 1-4
  final bool repracticed; // 首答错、重练后通过
  final String? correctAnswer; // choice 答错时展示的释义
}

/// 会话整体状态。
class StudySessionState {
  const StudySessionState({
    this.phase = SessionPhase.loading,
    this.pending = const [],
    this.completedCount = 0,
    this.correctCount = 0,
    this.current,
    this.feedback,
    this.sessionId,
    this.language = 'en',
    this.itemShownAtMs,
    this.sessionElapsedMs = 0,
    this.bumpedMinutes = 0,
    this.errorMessage,
  });

  final SessionPhase phase;
  final List<QueueItem> pending; // 未开始的队列项
  final int completedCount;
  final int correctCount; // 首答即对的题数（汇总页正确率）
  final SessionItemState? current;
  final ItemFeedback? feedback;
  final String? sessionId;
  final String language;

  /// 当前题的呈现时刻（答题计时）。
  final int? itemShownAtMs;
  final int sessionElapsedMs; // 已累计答题毫秒数
  final int bumpedMinutes; // 已写入 daily_stats 的分钟数

  final String? errorMessage;

  int get totalCount =>
      completedCount + pending.length + (current == null ? 0 : 1);

  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  StudySessionState copyWith({
    SessionPhase? phase,
    List<QueueItem>? pending,
    int? completedCount,
    int? correctCount,
    SessionItemState? current,
    bool clearCurrent = false,
    ItemFeedback? feedback,
    bool clearFeedback = false,
    String? sessionId,
    String? language,
    int? itemShownAtMs,
    bool clearItemShownAt = false,
    int? sessionElapsedMs,
    int? bumpedMinutes,
    String? errorMessage,
  }) {
    return StudySessionState(
      phase: phase ?? this.phase,
      pending: pending ?? this.pending,
      completedCount: completedCount ?? this.completedCount,
      correctCount: correctCount ?? this.correctCount,
      current: clearCurrent ? null : (current ?? this.current),
      feedback: clearFeedback ? null : (feedback ?? this.feedback),
      sessionId: sessionId ?? this.sessionId,
      language: language ?? this.language,
      itemShownAtMs:
          clearItemShownAt ? null : (itemShownAtMs ?? this.itemShownAtMs),
      sessionElapsedMs: sessionElapsedMs ?? this.sessionElapsedMs,
      bumpedMinutes: bumpedMinutes ?? this.bumpedMinutes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// 队列项 JSON 编解码（study_sessions.queue）。
String encodeQueue(List<QueueItem> items) => jsonEncode([
      for (final i in items)
        {'wordId': i.wordId, 'mode': i.mode.id, 'isNew': i.isNew},
    ]);

List<QueueItem> decodeQueue(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return [
    for (final e in list)
      QueueItem(
        wordId: e['wordId'] as String,
        mode: StudyMode.fromId(e['mode'] as String),
        isNew: (e['isNew'] as bool?) ?? false,
      ),
  ];
}

/// 全局会话控制器（进出 /study 不销毁；start/resume 重置状态）。
final sessionControllerProvider =
    NotifierProvider<SessionController, StudySessionState>(
        SessionController.new);

class SessionController extends Notifier<StudySessionState> {
  static const _uuid = Uuid();
  late FsrsService _fsrs;

  AppDatabase get _db => ref.read(dbProvider);

  @override
  StudySessionState build() {
    _fsrs = FsrsService();
    return const StudySessionState();
  }

  /// 新会话：清理遗留断点 → 取复习/新词 → 构队列 → 落库 → 呈现首题。
  Future<void> startSession({required String language}) async {
    try {
      state = StudySessionState(
          phase: SessionPhase.loading, language: language);
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      await _db.studyDao.abandonOpenSessions(nowMs: nowMs);
      final settings = await _db.settingsDao.getOrCreate(nowMs: nowMs);

      final queue =
          await _buildQueue(language: language, settings: settings, nowMs: nowMs);
      if (queue.isEmpty) {
        state = state.copyWith(phase: SessionPhase.finished);
        return;
      }

      final sessionId = _uuid.v7();
      await _db.studyDao.startSession(StudySessionsCompanion.insert(
        id: sessionId,
        language: language,
        startedAt: nowMs,
        queue: Value(encodeQueue(queue.sublist(1))),
        updatedAt: nowMs,
      ));

      final current = await _loadItem(queue.first, language);
      if (current == null) throw StateError('词不存在: ${queue.first.wordId}');
      state = StudySessionState(
        phase: SessionPhase.presenting,
        pending: queue.sublist(1),
        sessionId: sessionId,
        language: language,
        current: current,
        itemShownAtMs: DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      state = StudySessionState(phase: SessionPhase.error, errorMessage: '$e');
    }
  }

  /// 续学：存在未结束会话时恢复队列。返回是否成功恢复。
  Future<bool> tryResume() async {
    try {
      final session = await _db.studyDao.openSession();
      if (session == null || session.queue == null) return false;
      final pending = decodeQueue(session.queue!);
      if (pending.isEmpty) {
        await _db.studyDao.endSession(
            id: session.id, nowMs: DateTime.now().millisecondsSinceEpoch);
        return false;
      }
      final current = await _loadItem(pending.first, session.language);
      if (current == null) return false;
      state = StudySessionState(
        phase: SessionPhase.presenting,
        pending: pending.sublist(1),
        completedCount: session.completedCount,
        sessionId: session.id,
        language: session.language,
        current: current,
        itemShownAtMs: DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 退出（存断点，不结束会话）：当前未答完的题放回队首；补记时长。
  Future<void> pauseAndExit() async {
    final s = state;
    if (s.sessionId == null) return;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final remaining = [
      if (s.current != null) s.current!.item,
      ...s.pending,
    ];
    await _db.studyDao.updateSession(
      id: s.sessionId!,
      queue: encodeQueue(remaining),
      completedCount: s.completedCount,
      nowMs: nowMs,
    );
    await _flushMinutes(s, nowMs);
  }

  /// 新卡首呈：看过词义后确认，固定 Good。
  Future<void> answerNewCard() async {
    final cur = state.current;
    if (cur == null || cur.item.mode != StudyMode.newCard) return;
    if (state.phase != SessionPhase.presenting) return;
    await _finalize(rating: rateNewCard().value, correct: true);
  }

  /// 听写提交。日语接受假名读音或词头本身（罗马字输入归一为假名比对）。
  Future<void> answerDictation(String input, {required bool hintUsed}) async {
    final cur = state.current!;
    final word = cur.word;
    final targets = <String>[
      if (word.language == 'ja' && word.reading != null && word.reading != word.headword)
        word.reading!,
      word.headword,
    ];
    await _answerRecall(input, hintUsed: hintUsed, targets: targets);
  }

  /// 填空提交（比对被挖掉的词形；日语同样接受读音）。
  Future<void> answerCloze(String input, {required bool hintUsed}) async {
    final cur = state.current!;
    final answer = cur.clozeAnswer;
    if (answer == null) return;
    final word = cur.word;
    final targets = <String>[
      if (word.language == 'ja' && word.reading != null && word.reading != answer)
        word.reading!,
      answer,
    ];
    await _answerRecall(input, hintUsed: hintUsed, targets: targets);
  }

  Future<void> _answerRecall(
    String input, {
    required bool hintUsed,
    required List<String> targets,
  }) async {
    final cur = state.current;
    if (cur == null) return;
    if (state.phase != SessionPhase.presenting) return;
    final language = cur.word.language;
    final typed = normalizeSpelling(input, language);
    var errorCount = -1;
    for (final t in targets) {
      final d = editDistance(typed, normalizeSpelling(t, language));
      if (errorCount < 0 || d < errorCount) errorCount = d;
      if (errorCount == 0) break;
    }
    final rating = rateRecall(
        RecallAnswer(correct: errorCount == 0, hintUsed: hintUsed, errorCount: errorCount));
    String? override;
    if (cur.item.mode == StudyMode.cloze) {
      // 反馈里显示整句（挖空处填上答案）。
      final answer = cur.clozeAnswer;
      final sentence = cur.clozeSentence;
      override = (sentence != null && answer != null)
          ? sentence.replaceFirst('＿＿', answer)
          : cur.word.headword;
    }
    await _finalize(
      rating: rating.value,
      correct: errorCount == 0,
      answerOverride: override ?? cur.word.headword,
    );
  }

  /// 选择题点选一个选项。
  Future<void> answerChoicePick(Word picked) async {
    final cur = state.current;
    if (cur == null || cur.item.mode != StudyMode.choice) return;
    if (state.phase != SessionPhase.presenting) return;

    final correct = picked.id == cur.word.id;
    if (!correct) {
      // 错误：记日志、标红并留在本题重练（不产生 FSRS rating）。
      await _logWrongPick(cur, nowMs: DateTime.now().millisecondsSinceEpoch);
      state = state.copyWith(
        current: cur.copyWith(wrongPickIds: {...cur.wrongPickIds, picked.id}),
      );
      return;
    }

    // 答对：按错答次数定 rating（每项只产生 1 条 FSRS rating）。
    final wrongCount = cur.wrongPickIds.length;
    final Rating ratingValue;
    if (wrongCount == 0) {
      final lastRating = await _db.studyDao.lastLog(cur.word.id);
      final previousCorrect = lastRating != null && lastRating.rating >= 3;
      ratingValue = rateChoice(ChoiceAnswer(
          correct: true, consecutiveCorrect: previousCorrect ? 2 : 1));
    } else if (wrongCount == 1) {
      ratingValue = rateChoice(
          const ChoiceAnswer(correct: true, isRepractice: true)); // hard
    } else {
      ratingValue = Rating.again;
    }
    await _finalize(rating: ratingValue.value, correct: wrongCount == 0);
  }

  /// 反馈页"下一题"：推进队列；耗尽时回收步进到期卡或结束会话。
  Future<void> next() async {
    final s = state;
    if (s.phase != SessionPhase.feedback) return;
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    if (s.sessionId != null) {
      await _db.studyDao.updateSession(
        id: s.sessionId!,
        queue: encodeQueue(s.pending),
        completedCount: s.completedCount,
        nowMs: nowMs,
      );
    }

    if (s.pending.isNotEmpty) {
      await _presentItem(s, s.pending.first, remaining: s.pending.sublist(1));
      return;
    }

    // 队列耗尽：回收会话内到期的 learning/relearning 步进卡（due≤now）。
    final refill = await _db.progressDao.dueReviews(
      language: s.language,
      nowMs: nowMs,
      limit: 30,
    );
    final currentId = s.feedback != null || s.current != null
        ? _lastWordId
        : null;
    final refillItems = [
      for (final p in refill)
        if (p.wordId != currentId)
          QueueItem(
              wordId: p.wordId,
              mode: StudyMode.choice,
              isNew: false), // 步进复习统一用选择题重测
    ];
    if (refillItems.isNotEmpty) {
      await _presentItem(s, refillItems.first, remaining: refillItems.sublist(1));
      return;
    }

    await _db.studyDao.endSession(id: s.sessionId!, nowMs: nowMs);
    await _flushMinutes(s, nowMs);
    state = s.copyWith(
      phase: SessionPhase.finished,
      clearFeedback: true,
      clearCurrent: true,
    );
  }

  // ---- 内部 ----

  String? _lastWordId; // 刚完结题的词（回收步进卡时避免立即重复）

  Future<void> _presentItem(
    StudySessionState s,
    QueueItem item, {
    required List<QueueItem> remaining,
  }) async {
    final current = await _loadItem(item, s.language);
    if (current == null) {
      // 词缺失：跳过并尝试下一项。
      if (remaining.isNotEmpty) {
        await _presentItem(s, remaining.first, remaining: remaining.sublist(1));
        return;
      }
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      if (s.sessionId != null) {
        await _db.studyDao.endSession(id: s.sessionId!, nowMs: nowMs);
      }
      state = s.copyWith(
          phase: SessionPhase.finished,
          clearFeedback: true,
          clearCurrent: true);
      return;
    }
    state = s.copyWith(
      phase: SessionPhase.presenting,
      pending: remaining,
      clearFeedback: true,
      current: current,
      itemShownAtMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// 取复习（learning/relearning 全收 + review 限配额）与新词，交调度器交错。
  Future<List<QueueItem>> _buildQueue({
    required String language,
    required Setting settings,
    required int nowMs,
  }) async {
    final learningDue = await _db.progressDao.dueReviews(
        language: language, nowMs: nowMs, limit: 100, states: [1, 3]);
    final reviewDue = await _db.progressDao.dueReviews(
        language: language,
        nowMs: nowMs,
        limit: settings.dailyReviewLimit,
        states: [2]);
    final merged = [...learningDue, ...reviewDue]
      ..sort((a, b) => a.due.compareTo(b.due));

    // 新词难度中心：定级结果或默认入门。
    final level =
        language == 'ja' ? settings.placementLevelJa : settings.placementLevelEn;
    final center = level != null ? levelDifficulty(language, level) : 1.5;

    final newWords = await _db.wordDao.nextNewWords(
        language: language,
        difficultyCenter: center,
        limit: settings.dailyNewLimit);

    final reviewIds = [for (final p in merged) p.wordId];
    final newIds = [for (final w in newWords) w.id];
    final wordMap = {
      for (final w
          in await _db.wordDao.wordsByIds({...reviewIds, ...newIds}.toList()))
        w.id: w,
    };

    final reviewWords = [
      for (final p in merged)
        if (wordMap[p.wordId] != null)
          QueueWord(
            wordId: p.wordId,
            reps: p.reps,
            hasExamples: hasExamples(wordMap[p.wordId]!.examples),
          ),
    ];
    final newQueueWords = [
      for (final w in newWords)
        if (wordMap[w.id] != null) QueueWord(wordId: w.id),
    ];
    return buildTodayQueue(dueReviews: reviewWords, newWords: newQueueWords);
  }

  Future<SessionItemState?> _loadItem(QueueItem item, String language) async {
    final word = await _db.wordDao.getWord(item.wordId);
    if (word == null) return null; // 词不在库（异常数据）：由调用方跳过
    final progress = await _db.progressDao.getProgress(word.id);
    var options = const <Word>[];
    String? clozeSentence;
    String? clozeAnswer;
    String? clozeTranslation;
    var mode = item.mode;

    if (mode == StudyMode.choice) {
      final distractors = await _db.wordDao.distractorsFor(word, count: 3);
      options = [...distractors, word]..shuffle();
    } else if (mode == StudyMode.cloze) {
      final cloze = buildCloze(word);
      if (cloze == null) {
        mode = StudyMode.dictation; // 无可挖空例句：降级听写
      } else {
        clozeSentence = cloze.sentence;
        clozeAnswer = cloze.answer;
        clozeTranslation = cloze.translation;
      }
    }
    final effective = mode == item.mode
        ? item
        : QueueItem(wordId: item.wordId, mode: mode, isNew: item.isNew);
    return SessionItemState(
      item: effective,
      word: word,
      progress: progress,
      choiceOptions: options,
      clozeSentence: clozeSentence,
      clozeAnswer: clozeAnswer,
      clozeTranslation: clozeTranslation,
    );
  }

  /// 队列项完结：FSRS 结算 + 最终日志 + 统计 + 反馈态。
  Future<void> _finalize({
    required int rating,
    required bool correct,
    String? answerOverride,
  }) async {
    final s = state;
    final cur = s.current!;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    _lastWordId = cur.word.id;

    final result = _fsrs.review(
      progress: cur.progress,
      wordId: cur.word.id,
      language: cur.word.language,
      ratingValue: rating,
      nowMs: nowMs,
    );
    await _db.progressDao.upsertProgress(result.progress);
    await _db.studyDao.insertLog(StudyLogsCompanion.insert(
      id: _uuid.v7(),
      wordId: cur.word.id,
      mode: cur.item.mode.id,
      rating: rating,
      correct: correct,
      durationMs: nowMs - (s.itemShownAtMs ?? nowMs),
      reviewLog: Value(result.reviewLogJson),
      studiedAt: nowMs,
      updatedAt: nowMs,
    ));
    await _db.studyDao.bumpDailyStats(
      date: localStudyDay(DateTime.now()),
      newCount: cur.item.isNew ? 1 : 0,
      reviewCount: cur.item.isNew ? 0 : 1,
      correctCount: correct ? 1 : 0,
      minutes: 0,
      nowMs: nowMs,
    );

    final shownAt = s.itemShownAtMs;
    state = s.copyWith(
      phase: SessionPhase.feedback,
      completedCount: s.completedCount + 1,
      correctCount: s.correctCount + (correct ? 1 : 0),
      sessionElapsedMs:
          s.sessionElapsedMs + (shownAt == null ? 0 : nowMs - shownAt),
      feedback: ItemFeedback(
        correct: correct,
        rating: rating,
        repracticed:
            cur.item.mode == StudyMode.choice && cur.wrongPickIds.isNotEmpty,
        correctAnswer: answerOverride ??
            meaningsToLine(parseMeanings(cur.word.meanings)),
      ),
    );
  }

  /// 中间错选记日志（rating 固定 again，不进 FSRS）。
  Future<void> _logWrongPick(SessionItemState cur, {required int nowMs}) async {
    await _db.studyDao.insertLog(StudyLogsCompanion.insert(
      id: _uuid.v7(),
      wordId: cur.word.id,
      mode: cur.item.mode.id,
      rating: 1,
      correct: false,
      durationMs: 0,
      studiedAt: nowMs,
      updatedAt: nowMs,
    ));
  }

  /// 结束/退出时把累计毫秒折算成分钟补写 daily_stats（只补未写部分）。
  Future<void> _flushMinutes(StudySessionState s, int nowMs) async {
    final minutes = s.sessionElapsedMs ~/ 60000;
    final delta = minutes - s.bumpedMinutes;
    if (delta <= 0) return;
    await _db.studyDao.bumpDailyStats(
      date: localStudyDay(DateTime.now()),
      newCount: 0,
      reviewCount: 0,
      correctCount: 0,
      minutes: delta,
      nowMs: nowMs,
    );
  }
}
