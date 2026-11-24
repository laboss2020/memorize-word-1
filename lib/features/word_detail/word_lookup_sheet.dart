import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../core/db/app_database.dart';
import '../../core/tts/tts_service.dart';
import '../../core/utils/text_tokens.dart';
import '../../core/utils/word_content.dart';

/// 点词查字典：弹出词条（音标/读音 + 词性 + 释义 + 发音），可跳词详情。
/// 只查本地词库；英文先按原形查，再试规则屈折还原（inflectionCandidates）。
Future<void> showWordLookup(
  BuildContext context,
  WidgetRef ref, {
  required String language,
  required String query,
  required String glossMode,
}) {
  final db = ref.read(dbProvider);
  Future<Word?> find() async {
    for (final key in inflectionCandidates(query)) {
      final w = await db.wordDao.lookupByHeadword(language, key);
      if (w != null) return w;
    }
    return null;
  }

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => FutureBuilder<Word?>(
      future: find(),
      builder: (context, snapshot) {
        final s = AppStrings.of(context);
        final word = snapshot.data;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.connectionState != ConnectionState.done)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (word == null) ...[
                  Text(query, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(s.notInDict,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline)),
                ] else ...[
                  _FoundWord(word: word, glossMode: glossMode),
                ],
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _FoundWord extends ConsumerStatefulWidget {
  const _FoundWord({required this.word, required this.glossMode});

  final Word word;
  final String glossMode;

  @override
  ConsumerState<_FoundWord> createState() => _FoundWordState();
}

class _FoundWordState extends ConsumerState<_FoundWord> {
  final _tts = TtsService();

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    final s = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final meanings = selectMeanings(
      word.meanings,
      glossMode: widget.glossMode,
      learningLang: word.language,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(word.headword,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () =>
                  _tts.speak(word.headword, language: word.language),
            ),
          ],
        ),
        if (word.reading != null || word.phonetic != null)
          Text(
            word.language == 'ja'
                ? word.reading!
                : '/${word.phonetic ?? ''}/',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: scheme.primary),
          ),
        if (word.pos != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(word.pos!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.outline)),
          ),
        const SizedBox(height: 8),
        for (final m in meanings)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('• ${m.def}',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/library/word/${word.id}');
            },
            child: Text(s.viewDetail),
          ),
        ),
      ],
    );
  }
}
