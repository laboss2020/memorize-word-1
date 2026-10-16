import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart';
import '../../core/utils/word_content.dart';

/// 词书单词列表：headword + 释义 + 掌握标记。
class DeckWordsPage extends ConsumerWidget {
  const DeckWordsPage({super.key, required this.deckId, required this.deckName});

  final String deckId;
  final String deckName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(deckWordsProvider(deckId));

    return Scaffold(
      appBar: AppBar(title: Text(deckName)),
      body: words.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final (word, learned) = list[i];
            return ListTile(
              leading: Icon(
                learned ? Icons.check_circle : Icons.radio_button_unchecked,
                color: learned
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                size: 20,
              ),
              title: Text(word.headword),
              subtitle: Text(
                word.reading ??
                    meaningsToLine(parseMeanings(word.meanings)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => context.push('/library/word/${word.id}'),
            );
          },
        ),
      ),
    );
  }
}

/// 词书内单词（带已学标记）。
final deckWordsProvider =
    StreamProvider.autoDispose.family<List<(Word, bool)>, String>((ref, deckId) {
  return ref.watch(dbProvider).wordDao.watchDeckWords(deckId);
});
