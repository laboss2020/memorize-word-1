import 'package:flutter/material.dart';

import '../../app/strings.dart';

/// AI 对话占位页（一期不做；架构上预留 core/ai/ai_service.dart 接口）。
class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.aiChatTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy_outlined,
                size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(s.comingSoon),
            const SizedBox(height: 8),
            Text(s.aiChatSoonDesc,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
