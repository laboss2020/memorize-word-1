import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart' show Word;
import '../../core/fsrs/rating_mapper.dart' show StudyMode;
import '../../core/tts/tts_service.dart';
import '../../core/utils/word_content.dart';
import 'session_controller.dart';

/// 全屏学习会话：进度条 + 模式分发 + 即时反馈；退出 = 存断点。
class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});

  @override
  ConsumerState<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {
  final _tts = TtsService();
  String? _spokenWordId;

  @override
  void initState() {
    super.initState();
    // 首次进入：尝试续学；无可续会话则开新会话。
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureSession());
  }

  Future<void> _ensureSession() async {
    final notifier = ref.read(sessionControllerProvider.notifier);
    final phase = ref.read(sessionControllerProvider).phase;
    if (phase != SessionPhase.loading && phase != SessionPhase.finished) {
      return; // 已有进行中的会话状态（中途返回）
    }
    final resumed = await notifier.tryResume();
    if (resumed) return;
    final settings = ref.read(settingsProvider).value;
    await notifier.startSession(language: settings?.learningLang ?? 'en');
  }

  Future<void> _speak(String text, String language, String wordId) async {
    if (_spokenWordId == wordId) return;
    _spokenWordId = wordId;
    await _tts.speak(text, language: language);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionControllerProvider);
    final notifier = ref.read(sessionControllerProvider.notifier);

    // 新卡/听写/填空：切到新题时自动播报发音（听写只给声音不给文字）。
    ref.listen<StudySessionState>(sessionControllerProvider, (prev, next) {
      final cur = next.current;
      if (next.phase != SessionPhase.presenting || cur == null) return;
      final m = cur.item.mode;
      if (m != StudyMode.newCard &&
          m != StudyMode.dictation &&
          m != StudyMode.cloze) {
        return;
      }
      final key = '${cur.word.id}#${next.completedCount}';
      if (key == _spokenWordId) return;
      _spokenWordId = key;
      _tts.speak(cur.word.headword, language: next.language);
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitToHome(notifier);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _exitToHome(notifier),
          ),
          title: switch (state.phase) {
            SessionPhase.finished => const Text('本次完成'),
            _ => Text(state.sessionId == null ? '学习' : '学习 · ${state.language == 'ja' ? '日语' : '英语'}'),
          },
        ),
        body: switch (state.phase) {
          SessionPhase.loading => const Center(child: CircularProgressIndicator()),
          SessionPhase.error => _ErrorView(
              message: state.errorMessage ?? '加载失败',
              onRetry: () => notifier.startSession(language: state.language),
            ),
          SessionPhase.finished => _SummaryView(state: state),
          _ => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(value: state.progress),
                      ),
                      const SizedBox(width: 12),
                      Text('${state.completedCount}/${state.totalCount}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (state.current?.item.mode) {
                    StudyMode.newCard => _NewCardView(
                        item: state.current!,
                        onConfirm: notifier.answerNewCard,
                        onSpeak: () => _speak(state.current!.word.headword,
                            state.language, '${state.current!.word.id}#manual')),
                    StudyMode.choice => _ChoiceView(
                        item: state.current!,
                        feedback: state.feedback,
                        onPick: notifier.answerChoicePick,
                        onNext: notifier.next,
                        onSpeak: () => _speak(state.current!.word.headword,
                            state.language, '${state.current!.word.id}#manual')),
                    StudyMode.dictation => _DictationView(
                        key: ValueKey(
                            'dictation-${state.current!.word.id}-${state.completedCount}'),
                        item: state.current!,
                        feedback: state.feedback,
                        onSubmit: notifier.answerDictation,
                        onNext: notifier.next,
                        onSpeak: () => _speak(state.current!.word.headword,
                            state.language, '${state.current!.word.id}#manual')),
                    StudyMode.cloze => _ClozeView(
                        key: ValueKey(
                            'cloze-${state.current!.word.id}-${state.completedCount}'),
                        item: state.current!,
                        feedback: state.feedback,
                        onSubmit: notifier.answerCloze,
                        onNext: notifier.next,
                        onSpeak: () => _speak(state.current!.word.headword,
                            state.language, '${state.current!.word.id}#manual')),
                    _ => const Center(child: CircularProgressIndicator()),
                  },
                ),
              ],
            ),
        },
      ),
    );
  }

  Future<void> _exitToHome(SessionController notifier) async {
    await notifier.pauseAndExit();
    if (mounted) context.go('/home');
  }
}

// ---- 新卡首呈 ----

class _NewCardView extends StatelessWidget {
  const _NewCardView({required this.item, required this.onConfirm, required this.onSpeak});

  final SessionItemState item;
  final VoidCallback onConfirm;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final word = item.word;
    final meanings = parseMeanings(word.meanings);
    final examples = parseExamples(word.examples);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('新词', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(word.headword,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              IconButton.filledTonal(
                onPressed: onSpeak,
                icon: const Icon(Icons.volume_up),
              ),
            ],
          ),
          if (word.reading != null || word.phonetic != null) ...[
            const SizedBox(height: 4),
            Text(word.reading ?? '/${word.phonetic}/',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
          const SizedBox(height: 16),
          for (final m in meanings)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• ${m.def}',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          const SizedBox(height: 24),
          for (final e in examples) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.text),
                    if (e.translation != null) ...[
                      const SizedBox(height: 4),
                      Text(e.translation!,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),
          FilledButton(onPressed: onConfirm, child: const Text('记住了，继续')),
        ],
      ),
    );
  }
}

// ---- 选择题 ----

class _ChoiceView extends StatelessWidget {
  const _ChoiceView({
    required this.item,
    required this.feedback,
    required this.onPick,
    required this.onNext,
    required this.onSpeak,
  });

  final SessionItemState item;
  final ItemFeedback? feedback;
  final ValueChanged<Word> onPick;
  final VoidCallback onNext;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final word = item.word;
    final isFeedback = feedback != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('选出正确释义',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(word.headword,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              IconButton.filledTonal(
                onPressed: onSpeak,
                icon: const Icon(Icons.volume_up),
              ),
            ],
          ),
          if (word.reading != null || word.phonetic != null) ...[
            const SizedBox(height: 4),
            Text(word.reading ?? '/${word.phonetic}/',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
          const SizedBox(height: 24),
          for (final option in item.choiceOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionButton(
                option: option,
                markedWrong: item.wrongPickIds.contains(option.id),
                showCorrect: isFeedback && option.id == word.id,
                disabled: isFeedback || item.wrongPickIds.contains(option.id),
                onTap: () => onPick(option),
              ),
            ),
          if (feedback != null) ...[
            const SizedBox(height: 8),
            _FeedbackCard(feedback: feedback!, onNext: onNext),
          ],
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.option,
    required this.markedWrong,
    required this.showCorrect,
    required this.disabled,
    required this.onTap,
  });

  final Word option;
  final bool markedWrong;
  final bool showCorrect;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color? fill;
    Color? border;
    if (showCorrect) {
      fill = Colors.green.withValues(alpha: 0.15);
      border = Colors.green;
    } else if (markedWrong) {
      fill = scheme.errorContainer;
      border = scheme.error;
    }
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: fill,
        side: border == null ? null : BorderSide(color: border, width: 2),
        disabledForegroundColor: scheme.onSurface,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: disabled ? null : onTap,
      child: Text(
        meaningsToLine(parseMeanings(option.meanings)),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

// ---- 听写 ----

class _DictationView extends StatefulWidget {
  const _DictationView({
    super.key,
    required this.item,
    required this.feedback,
    required this.onSubmit,
    required this.onNext,
    required this.onSpeak,
  });

  final SessionItemState item;
  final ItemFeedback? feedback;
  final void Function(String input, {required bool hintUsed}) onSubmit;
  final VoidCallback onNext;
  final VoidCallback onSpeak;

  @override
  State<_DictationView> createState() => _DictationViewState();
}

class _DictationViewState extends State<_DictationView> {
  final _controller = TextEditingController();
  bool _hintUsed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _targetText {
    final word = widget.item.word;
    // 日语听写主要考读音；提示也按读音给。
    return word.language == 'ja' ? (word.reading ?? word.headword) : word.headword;
  }

  void _submit() {
    if (widget.feedback != null) return;
    widget.onSubmit(_controller.text, hintUsed: _hintUsed);
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.item.word;
    final feedback = widget.feedback;
    final isJa = word.language == 'ja';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('听写：听发音拼写单词',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 24),
          Center(
            child: IconButton.filledTonal(
              iconSize: 48,
              padding: const EdgeInsets.all(20),
              onPressed: widget.onSpeak,
              icon: const Icon(Icons.volume_up),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('点击重听', style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            autofocus: true,
            enabled: feedback == null,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: isJa ? '输入读音（假名/罗马字）' : '输入拼写',
            ),
          ),
          if (isJa) ...[
            const SizedBox(height: 12),
            _KanaPad(controller: _controller, enabled: feedback == null),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: feedback == null && !_hintUsed
                    ? () => setState(() => _hintUsed = true)
                    : null,
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('提示'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: feedback == null ? _submit : null,
                child: const Text('提交'),
              ),
            ],
          ),
          if (_hintUsed && feedback == null) ...[
            const SizedBox(height: 8),
            Text('提示：${firstCharHint(_targetText)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          ],
          if (feedback != null) ...[
            const SizedBox(height: 16),
            _FeedbackCard(feedback: feedback, onNext: widget.onNext),
          ],
        ],
      ),
    );
  }
}

// ---- 填空 ----

class _ClozeView extends StatefulWidget {
  const _ClozeView({
    super.key,
    required this.item,
    required this.feedback,
    required this.onSubmit,
    required this.onNext,
    required this.onSpeak,
  });

  final SessionItemState item;
  final ItemFeedback? feedback;
  final void Function(String input, {required bool hintUsed}) onSubmit;
  final VoidCallback onNext;
  final VoidCallback onSpeak;

  @override
  State<_ClozeView> createState() => _ClozeViewState();
}

class _ClozeViewState extends State<_ClozeView> {
  final _controller = TextEditingController();
  bool _hintUsed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _targetText {
    final item = widget.item;
    if (item.word.language == 'ja') {
      return item.word.reading ?? item.clozeAnswer ?? '';
    }
    return item.clozeAnswer ?? '';
  }

  void _submit() {
    if (widget.feedback != null) return;
    widget.onSubmit(_controller.text, hintUsed: _hintUsed);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final feedback = widget.feedback;
    final isJa = item.word.language == 'ja';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('填空：补全句中缺失的词',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.clozeSentence ?? '',
                      style: Theme.of(context).textTheme.titleMedium),
                  if (item.clozeTranslation != null) ...[
                    const SizedBox(height: 8),
                    Text(item.clozeTranslation!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: feedback == null && !_hintUsed
                    ? () => setState(() => _hintUsed = true)
                    : null,
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('提示'),
              ),
              const Spacer(),
              IconButton.filledTonal(
                onPressed: widget.onSpeak,
                icon: const Icon(Icons.volume_up),
              ),
            ],
          ),
          if (_hintUsed && feedback == null)
            Text('提示：${firstCharHint(_targetText)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            autofocus: true,
            enabled: feedback == null,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: isJa ? '输入读音（假名/罗马字）' : '输入缺失的词',
            ),
          ),
          if (isJa) ...[
            const SizedBox(height: 12),
            _KanaPad(controller: _controller, enabled: feedback == null),
          ],
          const SizedBox(height: 12),
          if (feedback != null) ...[
            const SizedBox(height: 4),
            _FeedbackCard(feedback: feedback, onNext: widget.onNext),
          ] else
            FilledButton(onPressed: _submit, child: const Text('提交')),
        ],
      ),
    );
  }
}

/// 首字符提示：显示第一个字符 + 其余用下划线占位。
String firstCharHint(String target) {
  final runes = target.runes.toList();
  if (runes.isEmpty) return '';
  final rest = '＿' * (runes.length - 1).clamp(0, 12);
  return '${String.fromCharCode(runes.first)}$rest';
}

// ---- 共用反馈卡 ----

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.feedback, required this.onNext});

  final ItemFeedback feedback;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: feedback.correct
          ? Colors.green.withValues(alpha: 0.12)
          : Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedback.correct
                  ? (feedback.repracticed ? '重练通过 ✓' : '回答正确 ✓')
                  : '正确答案：${feedback.correctAnswer ?? "-"}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onNext, child: const Text('下一题')),
          ],
        ),
      ),
    );
  }
}

// ---- 假名键盘兜底（设备无日文输入法时） ----

class _KanaPad extends StatelessWidget {
  const _KanaPad({required this.controller, required this.enabled});

  final TextEditingController controller;
  final bool enabled;

  static const _rows = [
    'あいうえお',
    'かきくけこ',
    'さしすせそ',
    'たちつてと',
    'なにぬねの',
    'はひふへほ',
    'まみむめも',
    'やゆよー',
    'らりるれろ',
    'わをんっ',
    'がぎぐげご',
    'ざじずぜぞ',
    'だでどばび',
    'ぶべぼぱぴ',
    'ぷぺぽゃゅょ',
  ];

  void _insert(String kana) {
    final value = controller.value;
    final text = value.text;
    final base = value.selection.baseOffset < 0 ? text.length : value.selection.baseOffset;
    final extent =
        value.selection.extentOffset < 0 ? base : value.selection.extentOffset;
    final start = base < extent ? base : extent;
    final end = base < extent ? extent : base;
    controller.value = TextEditingValue(
      text: text.replaceRange(start, end, kana),
      selection: TextSelection.collapsed(offset: start + kana.length),
    );
  }

  void _backspace() {
    final value = controller.value;
    final text = value.text;
    if (text.isEmpty) return;
    final base = value.selection.baseOffset < 0 ? text.length : value.selection.baseOffset;
    final extent =
        value.selection.extentOffset < 0 ? base : value.selection.extentOffset;
    final start = base < extent ? base : extent;
    final end = base < extent ? extent : base;
    if (start == end) {
      if (start == 0) return;
      controller.value = TextEditingValue(
        text: text.replaceRange(start - 1, start, ''),
        selection: TextSelection.collapsed(offset: start - 1),
      );
    } else {
      controller.value = TextEditingValue(
        text: text.replaceRange(start, end, ''),
        selection: TextSelection.collapsed(offset: start),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final row in _rows)
              Row(
                children: [
                  for (final kana in row.runes)
                    Expanded(
                      child: InkWell(
                        onTap: () => _insert(String.fromCharCode(kana)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            String.fromCharCode(kana),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            InkWell(
              onTap: _backspace,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Icon(Icons.backspace_outlined,
                    size: 18, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- 汇总 / 错误 ----

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.state});

  final StudySessionState state;

  @override
  Widget build(BuildContext context) {
    final accuracy =
        state.completedCount == 0 ? 0 : (state.correctCount * 100 / state.completedCount).round();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.celebration_outlined,
              size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(state.completedCount == 0 ? '今日任务已完成' : '完成 ${state.completedCount} 项',
              style: Theme.of(context).textTheme.headlineSmall),
          if (state.completedCount > 0) ...[
            const SizedBox(height: 8),
            Text('首答正确率 $accuracy%',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/home'),
            child: const Text('返回主页'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 56, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}
