import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../app/widgets/stepper_tile.dart';
import '../../core/db/app_database.dart';
import '../../core/fsrs/rating_mapper.dart' show StudyMode;
import '../../core/placement/placement_engine.dart';
import '../../core/utils/levels.dart';
import '../../core/utils/word_content.dart';

/// 引导流程：三页介绍（可跳过）→ 选语言 → [定级测试 | 跳过] → 每日目标 → 完成。
enum _Step { intro, language, placement, placementResult, goal }

const _enLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _jaLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key, this.retest = false});

  /// true = 从设置页进入的重新定级：直接开测，完成后只写定级结果。
  final bool retest;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late _Step _step;
  String _language = 'en';
  PageController? _pageCtrl;
  int _introPage = 0;

  // 定级测试状态。
  late PlacementEngine _engine;
  Word? _quizWord;
  List<Word> _options = const [];
  final _usedIds = <String>{};
  final _poolCache = <String, List<Word>>{};
  String? _picked;
  bool _loadingQuestion = false;
  bool _tested = false; // 是否完成过定级（跳过 = false）

  // 每日目标。
  int _newLimit = 10;
  int _reviewLimit = 50;

  List<String> get _levels => _language == 'ja' ? _jaLevels : _enLevels;

  @override
  void initState() {
    super.initState();
    if (widget.retest) {
      // 重新定级：沿用当前学习语言，直接开测。
      final settings = ref.read(settingsProvider).value;
      _language = settings?.learningLang ?? 'en';
      _step = _Step.placement;
      _startPlacement(quiet: true);
    } else {
      _step = _Step.intro;
      _pageCtrl = PageController();
    }
  }

  // ---- 定级测试 ----

  void _startPlacement({bool quiet = false}) {
    void apply() {
      _step = _Step.placement;
      _engine = PlacementEngine(levels: _levels);
      _usedIds.clear();
      _poolCache.clear();
      _quizWord = null;
      _options = const [];
      _picked = null;
    }

    if (quiet) {
      apply(); // initState 中：不触发 setState
    } else {
      setState(apply);
    }
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    if (_loadingQuestion) return;
    _loadingQuestion = true;
    try {
      final db = ref.read(dbProvider);
      final level = _engine.currentLevel;
      var pool = _poolCache[level];
      var word = _nextUnused(pool);
      if (word == null) {
        pool = await db.wordDao.placementPool(_language, level, count: 30);
        if (!mounted) return;
        _poolCache[level] = pool;
        word = _nextUnused(pool);
      }
      if (word == null) {
        // 该档无题可用：视为已通过，升档（引擎到顶会自行结束）。
        _engine.recordAnswer(true);
        if (!mounted) return;
        if (_engine.isDone) {
          setState(() {
            _tested = true;
            _step = _Step.placementResult;
          });
          return;
        }
        await _loadQuestion();
        return;
      }
      final quiz = word; // 非 null：闭包内访问需有效终局部变量
      final distractors = await db.wordDao.distractorsFor(quiz, count: 3);
      if (!mounted) return;
      setState(() {
        _quizWord = quiz;
        _options = [...distractors, quiz]..shuffle();
        _usedIds.add(quiz.id);
        _picked = null;
      });
    } finally {
      _loadingQuestion = false;
    }
  }

  Word? _nextUnused(List<Word>? pool) {
    if (pool == null) return null;
    for (final w in pool) {
      if (!_usedIds.contains(w.id)) return w;
    }
    return null;
  }

  Future<void> _pick(Word option) async {
    final quiz = _quizWord;
    if (quiz == null || _picked != null) return;
    final correct = option.id == quiz.id;
    setState(() => _picked = option.id);

    // 定级只记日志，不进 FSRS、不计入每日统计。
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    await ref.read(dbProvider).studyDao.insertLog(StudyLogsCompanion.insert(
          id: const Uuid().v7(),
          wordId: quiz.id,
          mode: StudyMode.placement.id,
          rating: correct ? 3 : 1,
          correct: correct,
          durationMs: 0,
          studiedAt: nowMs,
          updatedAt: nowMs,
        ));
  }

  Future<void> _nextAfterAnswer() async {
    final quiz = _quizWord;
    if (quiz == null || _picked == null) return;
    _engine.recordAnswer(_picked == quiz.id);
    if (_engine.isDone) {
      setState(() {
        _tested = true;
        _step = _Step.placementResult;
      });
      return;
    }
    await _loadQuestion();
  }

  // ---- 完成 ----

  Future<void> _complete() async {
    final db = ref.read(dbProvider);
    final retest = widget.retest;
    await db.settingsDao.updateSettings(
      SettingsCompanion(
        learningLang: Value(_language),
        placementLevelEn: Value(_language == 'en' && _tested
            ? _engine.resultLevel
            : null),
        placementLevelJa: Value(_language == 'ja' && _tested
            ? _engine.resultLevel
            : null),
        placementDone: Value(_tested),
        // 重新定级不重置每日目标、不重写引导标记。
        dailyNewLimit: retest ? const Value.absent() : Value(_newLimit),
        dailyReviewLimit: retest ? const Value.absent() : Value(_reviewLimit),
        onboarded: retest ? const Value.absent() : const Value(true),
      ),
      nowMs: DateTime.now().millisecondsSinceEpoch,
    );
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _pageCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      _Step.intro => _buildIntro(context),
      _Step.language => _buildLanguage(context),
      _Step.placement => _buildPlacement(context),
      _Step.placementResult => _buildPlacementResult(context),
      _Step.goal => _buildGoal(context),
    };
  }

  // ---- 步骤 1：介绍（3 页，可跳过） ----

  Widget _buildIntro(BuildContext context) {
    final pageCtrl = _pageCtrl!;
    final pages = [
      (
        Icons.school_outlined,
        '科学记单词',
        '间隔重复（FSRS）自动安排每次复习，在快忘记的时候提醒你。',
      ),
      (
        Icons.style_outlined,
        '三种练习模式',
        '选择题认词、听写拼词、例句填空，多角度巩固记忆。',
      ),
      (
        Icons.offline_bolt_outlined,
        '完全离线',
        '词库与学习数据全部保存在本地，无需注册，随时可用。',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageCtrl,
                onPageChanged: (i) => setState(() => _introPage = i),
                children: [
                  for (final (icon, title, desc) in pages)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon,
                              size: 96,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 24),
                          Text(title,
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 12),
                          Text(desc,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < pages.length; i++)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _introPage
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (_introPage < pages.length - 1) {
                        pageCtrl.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut);
                      } else {
                        setState(() => _step = _Step.language);
                      }
                    },
                    child: Text(
                        _introPage < pages.length - 1 ? '下一步' : '开始使用'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _step = _Step.language),
                    child: const Text('跳过'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 步骤 2：选语言 ----

  Widget _buildLanguage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择学习语言')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'en', label: Text('英语'), icon: Icon(Icons.abc)),
                ButtonSegment(
                    value: 'ja',
                    label: Text('日语'),
                    icon: Icon(Icons.translate)),
              ],
              selected: {_language},
              onSelectionChanged: (s) => setState(() => _language = s.first),
            ),
            const SizedBox(height: 48),
            FilledButton.icon(
              onPressed: _startPlacement,
              icon: const Icon(Icons.quiz_outlined),
              label: const Text('开始定级测试（约 1 分钟）'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => setState(() => _step = _Step.goal),
              child: const Text('跳过测试，从入门级开始'),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 步骤 3：定级测试 ----

  Widget _buildPlacement(BuildContext context) {
    final word = _quizWord;
    return Scaffold(
      appBar: AppBar(
        title: Text('定级测试 · ${levelDisplayName(_language, _engine.currentLevel)}'),
        actions: [
          TextButton(
            onPressed: () {
              if (widget.retest) {
                context.go('/home');
              } else {
                setState(() => _step = _Step.goal);
              }
            },
            child: const Text('跳过'),
          ),
        ],
      ),
      body: word == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('选出正确释义（第 ${_engine.askedCount + 1} 题）',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 16),
                  Text(word.headword,
                      style: Theme.of(context).textTheme.headlineMedium),
                  if (word.language == 'ja' && word.reading != null)
                    Text(word.reading!,
                        style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  for (final option in _options) ...[
                    _PlacementOption(
                      option: option,
                      picked: _picked,
                      correctId: word.id,
                      onTap: () => _pick(option),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Spacer(),
                  if (_picked != null)
                    FilledButton(
                      onPressed: _nextAfterAnswer,
                      child: const Text('下一题'),
                    ),
                ],
              ),
            ),
    );
  }

  // ---- 步骤 4：定级结果 ----

  Widget _buildPlacementResult(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('定级结果')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.emoji_events_outlined,
                size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              '建议从「${levelDisplayName(_language, _engine.resultLevel)}」开始',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '之后可在设置中重新测试，或调整每日目标。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: widget.retest
                  ? _complete
                  : () => setState(() => _step = _Step.goal),
              child: const Text('就这样开始'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _startPlacement,
              child: const Text('重新测试'),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 步骤 5：每日目标 ----

  Widget _buildGoal(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('每日目标')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StepperTile(
            title: '每天学新词',
            value: _newLimit,
            min: 3,
            max: 50,
            step: 1,
            unit: '词',
            onChanged: (v) => setState(() => _newLimit = v),
          ),
          StepperTile(
            title: '每天复习上限',
            value: _reviewLimit,
            min: 10,
            max: 200,
            step: 10,
            unit: '词',
            onChanged: (v) => setState(() => _reviewLimit = v),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilledButton(
              onPressed: _complete,
              child: const Text('完成，开始学习'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlacementOption extends StatelessWidget {
  const _PlacementOption({
    required this.option,
    required this.picked,
    required this.correctId,
    required this.onTap,
  });

  final Word option;
  final String? picked;
  final String correctId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final answered = picked != null;
    final isCorrect = option.id == correctId;
    final isPickedWrong = picked == option.id && !isCorrect;
    Color? fill;
    Color? border;
    if (answered && isCorrect) {
      fill = Colors.green.withValues(alpha: 0.15);
      border = Colors.green;
    } else if (isPickedWrong) {
      fill = scheme.errorContainer;
      border = scheme.error;
    }
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: fill,
        side: border == null ? null : BorderSide(color: border, width: 2),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: answered ? null : onTap,
      child: Text(
        meaningsToLine(parseMeanings(option.meanings)),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
