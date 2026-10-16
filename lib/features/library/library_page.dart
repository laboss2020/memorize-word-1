import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart' show Deck;

/// 词库浏览：按当前学习语言的词书分组（M3 加搜索与单词列表）。
class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final language = settings?.learningLang ?? 'en';
    final decks = ref.watch(decksProvider(language));

    return Scaffold(
      appBar: AppBar(title: Text(language == 'ja' ? '词库 · 日语' : '词库 · 英语')),
      body: decks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) => Card(
            child: ListTile(
              title: Text(list[i].name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                  '/library/deck/${list[i].id}?name=${Uri.encodeComponent(list[i].name)}'),
            ),
          ),
        ),
      ),
    );
  }
}

final decksProvider =
    StreamProvider.family<List<Deck>, String>((ref, language) {
  return ref.watch(dbProvider).wordDao.watchDecks(language);
});
