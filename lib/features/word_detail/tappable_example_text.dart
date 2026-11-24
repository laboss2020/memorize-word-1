import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/utils/text_tokens.dart';
import 'word_lookup_sheet.dart';

/// 可点词例句文本：例句中词库命中的词可点，弹出查词层。
/// [knownHeads] 为 null 时降级为纯文本（集合未加载完不阻塞显示）。
class TappableExampleText extends ConsumerStatefulWidget {
  const TappableExampleText({
    super.key,
    required this.text,
    required this.language,
    required this.glossMode,
    this.knownHeads,
    this.style,
  });

  final String text;
  final String language;
  final String glossMode;
  final Set<String>? knownHeads;
  final TextStyle? style;

  @override
  ConsumerState<TappableExampleText> createState() =>
      _TappableExampleTextState();
}

class _TappableExampleTextState extends ConsumerState<TappableExampleText> {
  final _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 重建时释放上一轮的 recognizer，避免逐题累积。
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
    final heads = widget.knownHeads;
    if (heads == null) return Text(widget.text, style: widget.style);

    final tokens = tokenizeExample(widget.text, widget.language, heads);
    final spans = <InlineSpan>[];
    for (final token in tokens) {
      if (!token.isLookup) {
        spans.add(TextSpan(text: token.text));
        continue;
      }
      final recognizer = TapGestureRecognizer()
        ..onTap = () => showWordLookup(
              context,
              ref,
              language: widget.language,
              query: token.lookupKey!,
              glossMode: widget.glossMode,
            );
      _recognizers.add(recognizer);
      spans.add(TextSpan(
        text: token.text,
        style: (widget.style ?? DefaultTextStyle.of(context).style)
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
        recognizer: recognizer,
      ));
    }
    return Text.rich(
      TextSpan(children: spans, style: widget.style),
    );
  }
}
