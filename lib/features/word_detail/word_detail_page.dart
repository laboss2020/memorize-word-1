import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart';
import '../../core/tts/tts_service.dart';
import '../../core/utils/levels.dart';
import '../../core/utils/word_content.dart';

/// 单词详情：释义/例句/发音/进度/历史。
class WordDetailPage extends ConsumerStatefulWidget {
  const WordDetailPage({super.key, required this.wordId});

  final String wordId;

  @override
  ConsumerState<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  final _tts = TtsService();

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = ref.watch(wordProvider(widget.wordId)).value;
    if (word == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final progress = ref.watch(progressProvider(widget.wordId)).value;
    final logs = ref.watch(wordLogsProvider(widget.wordId)).value ?? const [];
    final scheme = Theme.of(context).colorScheme;
    final meanings = parseMeanings(word.meanings);
    final examples = parseExamples(word.examples);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => _tts.speak(word.headword, language: word.language),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(word.headword, style: Theme.of(context).textTheme.headlineMedium),
          if (word.reading != null || word.phonetic != null) ...[
            const SizedBox(height: 4),
            Text(
              word.language == 'ja'
                  ? (word.reading ?? '')
                  : '/${word.phonetic ?? ''}/',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text(levelDisplayName(word.language, word.level)),
                visualDensity: VisualDensity.compact,
              ),
              if (word.pos != null)
                Chip(
                  label: Text(word.pos!),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (final m in meanings)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• ${m.def}',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          if (examples.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('例句', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final e in examples)
              Card(
                child: ListTile(
                  title: Text(e.text),
                  subtitle:
                      e.translation == null ? null : Text(e.translation!),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up_outlined),
                    onPressed: () =>
                        _tts.speak(e.text, language: word.language),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 20),
          if (progress != null) _ProgressCard(progress: progress),
          const SizedBox(height: 20),
          Text('学习记录', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (logs.isEmpty)
            Text('还没有学习记录',
                style: Theme.of(context).textTheme.bodySmall),
          for (final log in logs)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(
                log.correct ? Icons.check_circle : Icons.cancel,
                color: log.correct ? Colors.green : scheme.error,
                size: 20,
              ),
              title: Text(modeName(log.mode)),
              trailing: Text(_fmtTime(log.studiedAt),
                  style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
      ),
    );
  }

  String _fmtTime(int ms) {
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${d.month}/${d.day} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});

  final WordProgressData progress;

  @override
  Widget build(BuildContext context) {
    final stateNames = {1: '学习中', 2: '复习中', 3: '重学中'};
    final due = DateTime.fromMillisecondsSinceEpoch(progress.due);
    final dueText = due.isBefore(DateTime.now())
        ? '已到期'
        : '${due.difference(DateTime.now()).inDays + 1} 天后复习';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ProgressStat(
                label: '状态', value: stateNames[progress.state] ?? '-'),
            _ProgressStat(label: '复习次数', value: '${progress.reps}'),
            _ProgressStat(label: '遗忘次数', value: '${progress.lapses}'),
            _ProgressStat(label: '下次', value: dueText),
          ],
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  const _ProgressStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// 模式 → 显示名。
String modeName(String mode) => switch (mode) {
      'new_card' => '新词学习',
      'choice' => '选择题',
      'dictation' => '听写',
      'cloze' => '填空',
      'placement' => '定级测试',
      _ => mode,
    };
