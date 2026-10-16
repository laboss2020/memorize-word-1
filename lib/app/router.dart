import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/widgets.dart' show Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ai_chat/ai_chat_page.dart';
import '../features/about/about_page.dart';
import '../features/home/home_page.dart';
import '../features/library/deck_words_page.dart';
import '../features/library/library_page.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/settings/settings_page.dart';
import '../features/stats/stats_page.dart';
import '../features/study/study_page.dart';
import '../features/word_detail/word_detail_page.dart';
import 'providers.dart';
import 'shell/app_shell.dart';

/// 全局路由（含 onboarding 守卫）。
final routerProvider = Provider<GoRouter>((ref) {
  // redirect 里只能 read 到瞬时值：初始加载（null → 默认行）与完成引导
  // （onboarded 写库）都必须在设置流更新时重估 redirect，否则全新安装
  // 会直接落在 /home、完成引导后会被弹回 /onboarding。
  // （真实 app 的根组件常驻 watch settingsProvider，故此流不会暂停。）
  final refresh = ValueNotifier(0);
  ref.listen(settingsProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    refreshListenable: refresh,
    initialLocation: '/home',
    redirect: (context, state) {
      final settings = ref.read(settingsProvider).value;
      if (settings == null) return null; // 尚未加载完成（启动屏覆盖中）
      final loc = state.matchedLocation;
      final inOnboarding = loc.startsWith('/onboarding');
      if (!settings.onboarded) {
        // 未引导（含直接访问 /placement）→ 引导页。
        return inOnboarding ? null : '/onboarding';
      }
      if (inOnboarding) return '/home';
      return null; // /placement 对已引导用户放行（重新定级）
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          _branch('/home', const HomePage()),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryPage(),
                routes: [
                  GoRoute(
                    path: 'deck/:deckId',
                    builder: (context, state) => DeckWordsPage(
                      deckId: state.pathParameters['deckId']!,
                      deckName:
                          state.uri.queryParameters['name'] ?? '词书',
                    ),
                  ),
                  GoRoute(
                    path: 'word/:wordId',
                    builder: (context, state) => WordDetailPage(
                      wordId: state.pathParameters['wordId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _branch('/stats', const StatsPage()),
          _branch('/settings', const SettingsPage()),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        // 重新定级（设置页入口）：复用引导页的定级流程。
        path: '/placement',
        builder: (context, state) => const OnboardingPage(retest: true),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/study',
        builder: (context, state) => const StudyPage(),
      ),
      GoRoute(
        path: '/ai',
        builder: (context, state) => const AiChatPage(),
      ),
    ],
  );
});

StatefulShellBranch _branch(String path, Widget child) => StatefulShellBranch(
      routes: [
        GoRoute(path: path, builder: (context, state) => child),
      ],
    );
