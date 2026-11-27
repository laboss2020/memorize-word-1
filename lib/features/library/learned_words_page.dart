import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../core/utils/pos_labels.dart';
import '../../core/utils/word_content.dart';
import '../study/session_controller.dart';

/// 已学单词列表：按最近学习倒序，可按掌握状态筛选，点词进入该词的学习。
/// 筛选口径与统计页一致：学习中(1)/巩固中(2)/已掌握(3)。
class LearnedWordsPage extends ConsumerStatefulWidget {
  const LearnedWordsPage({super.key});

  @override
  ConsumerState<LearnedWordsPage> createState() => _LearnedWordsPageState();
}

class _LearnedWordsPageState extends ConsumerState<LearnedWordsPage> {
  int? _filter; // null=全部

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final language = settings?.learningLang ?? 'en';
    final glossMode = settings?.glossMode ?? 'zh';
    final s = AppStrings.of(context);
    final learned = ref.watch(learnedWordsProvider((language, _filter)));

    return Scaffold(
      appBar: AppBar(title: Text(s.learnedWords)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                _FilterChip(
                    label: s.filterAll,
                    selected: _filter == null,
                    onTap: () => setState(() => _filter = null)),
                const SizedBox(width: 8),
                _FilterChip(
                    label: s.filterLearning,
                    selected: _filter == 1,
                    onTap: () => setState(() => _filter = 1)),
                const SizedBox(width: 8),
                _FilterChip(
                    label: s.filterYoung,
                    selected: _filter == 2,
                    onTap: () => setState(() => _filter = 2)),
                const SizedBox(width: 8),
                _FilterChip(
                    label: s.filterMature,
                    selected: _filter == 3,
                    onTap: () => setState(() => _filter = 3)),
              ],
            ),
          ),
          Expanded(
            child: learned.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(AppStrings.of(context).loadFailedWith(e))),
              data: (list) => list.isEmpty
                  ? Center(child: Text(s.noData))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final (word, progress) = list[i];
                        return ListTile(
                          leading: Icon(
                            progress.state == 2
                                ? Icons.autorenew
                                : Icons.school_outlined,
                            size: 20,
                            color:
                                Theme.of(context).colorScheme.outlineVariant,
                          ),
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(word.headword,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              if (word.phonetic != null) ...[
                                const SizedBox(width: 8),
                                Text('/${word.phonetic}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline)),
                              ],
                              if (word.pos != null) ...[
                                const SizedBox(width: 8),
                                Text(posLabel(word.pos!, glossMode),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline)),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            meaningsLine(
                              word.meanings,
                              glossMode: glossMode,
                              learningLang: word.language,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            progress.state == 2 && (progress.stability ?? 0) >= 21
                                ? s.filterMature
                                : progress.state == 2
                                    ? s.filterYoung
                                    : s.filterLearning,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline),
                          ),
                          onTap: () async {
                            // 不推 /library/word/*（位于 shell 词库分支内，
                            // 从 shell 外推送会得到空白分支页），改为单词学习。
                            await ref
                                .read(sessionControllerProvider.notifier)
                                .startSingleReview(
                                    wordId: word.id, language: language);
                            if (context.mounted) context.push('/study');
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
