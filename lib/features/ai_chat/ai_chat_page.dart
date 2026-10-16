import 'package:flutter/material.dart';

/// AI 对话占位页（一期不做；架构上预留 core/ai/ai_service.dart 接口）。
class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 对话')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy_outlined,
                size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text('即将上线'),
            const SizedBox(height: 8),
            Text('用新学的单词和 AI 对话练习（规划中）',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
