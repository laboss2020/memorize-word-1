import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/providers.dart';
import 'app/router.dart';
import 'app/theme.dart';

void main() {
  runApp(const ProviderScope(child: MemorizeWordApp()));
}

/// 应用根：等待种子导入与设置就绪后再进路由。
class MemorizeWordApp extends ConsumerWidget {
  const MemorizeWordApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seedImport = ref.watch(seedImportProvider);
    final settings = ref.watch(settingsProvider);

    // 每日提醒跟随设置变化（含首次加载的初始调度）。
    final reminder = ref.watch(reminderServiceProvider);
    ref.listen(settingsProvider, (_, next) {
      final s = next.value;
      if (s != null) reminder.syncFromSettings(s);
    });

    return MaterialApp.router(
      title: '背单词',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final ready = seedImport.hasValue && settings.hasValue;
        if (!ready) {
          return const _SplashScreen();
        }
        if (seedImport.hasError || settings.hasError) {
          return const _StartupErrorScreen();
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

/// 启动屏：种子导入期间显示。
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_outlined,
                  size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              const Text('背单词', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 启动失败兜底（如种子资产缺失）。
class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              const Text('启动失败，请重启应用'),
            ],
          ),
        ),
      ),
    );
  }
}
