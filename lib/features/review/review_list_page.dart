import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../core/db/app_database.dart';
import '../../core/utils/word_content.dart';
import '../study/session_controller.dart';

/// 待复习一览：列出到期单词（due 升序），点击单词直接进入该词的复习。
class ReviewListPage extends ConsumerWidget {
  const ReviewListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final language = settings?.learningLang ?? 'en';
    final glossMode = settings?.glossMode ?? 'zh';
    final dueWords = ref.watch(dueWordsProvider(language));

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(context).toReview)),
      body: dueWords.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
            child: Text(AppStrings.of(context).loadFailedWith(e))),
        data: (list) => list.isEmpty
            ? Center(child: Text(AppStrings.of(context).noData))
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
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    title: Text(word.headword),
                    subtitle: Text(
                      word.reading ??
                          meaningsLine(
                            word.meanings,
                            glossMode: glossMode,
                            learningLang: word.language,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
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
    );
  }
}

/// 到期单词（due 升序，含进度行；作答后自动重查，
/// 每半分钟重取当前时间让新到期的词自动出现）。
final dueWordsProvider = StreamProvider.autoDispose
    .family<List<(Word, WordProgressData)>, String>((ref, language) {
  final timer = Timer.periodic(
      const Duration(seconds: 30), (_) => ref.invalidateSelf());
  ref.onDispose(timer.cancel);
  return ref.watch(dbProvider).progressDao.watchDueWords(
      language: language, nowMs: DateTime.now().millisecondsSinceEpoch);
});
