import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../core/db/app_database.dart';
import 'home_providers.dart';
import 'suggestion_engine.dart';

/// 主页：连续打卡 + 今日任务卡（新词/复习配额）+ 建议卡 + AI 入口。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final t = AppStrings.of(context);
    final settings = ref.watch(settingsProvider).value;
    final language = settings?.learningLang ?? 'en';
    final dueCount = ref.watch(dueCountProvider(language)).value ?? 0;
    final todayStats = ref.watch(todayStatsProvider).value;
    final streak = ref.watch(streakProvider).value ?? 0;
    final openSession = ref.watch(openSessionProvider).value;

    final newLimit = settings?.dailyNewLimit ?? 10;
    final newDone = todayStats?.newCount ?? 0;
    final newLeft = (newLimit - newDone).clamp(0, newLimit);
    // 当天完成数（与学习页进度条同源；会话计数可能跨天，不作展示）。
    final todayDone = newDone + (todayStats?.reviewCount ?? 0);

    final suggestions = SuggestionEngine.build(
      SuggestionInputs(
        streak: streak,
        dueCount: dueCount,
        recentAccuracy: ref.watch(recentAccuracyProvider).value,
        daysSinceLastStudy: ref.watch(daysSinceLastStudyProvider).value,
        dailyReviewLimit: settings?.dailyReviewLimit ?? 50,
      ),
      t,
    );

    return Scaffold(
      appBar: AppBar(title: Text(t.appName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(t.todayMotivation(language),
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              if (streak > 0)
                Chip(
                  avatar: Icon(Icons.local_fire_department,
                      size: 18, color: scheme.primary),
                  label: Text(t.streakDays(streak)),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 12),
          // 今日任务卡
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.todayTask,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatChip(
                          label: t.toReview,
                          value: '$dueCount',
                          color: scheme.tertiary,
                          onTap: dueCount > 0
                              ? () => context.push('/review')
                              : null),
                      const SizedBox(width: 8),
                      _StatChip(
                          label: t.newWords,
                          value: newLeft > 0 ? '$newLeft' : '✓',
                          color: scheme.primary),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: openSession != null
                        ? FilledButton.icon(
                            onPressed: () => context.push('/study'),
                            icon: const Icon(Icons.play_circle_outline),
                            label:
                                Text(t.continueStudy(todayDone)),
                          )
                        : (dueCount > 0 || newLeft > 0)
                            ? FilledButton.icon(
                                onPressed: () => context.push('/study'),
                                icon: const Icon(Icons.play_arrow),
                                label: Text(t.startStudy),
                              )
                            : FilledButton.tonalIcon(
                                onPressed: null,
                                icon: const Icon(Icons.check_circle_outline),
                                label: Text(t.allDoneToday),
                              ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 已学单词入口
          Card(
            child: ListTile(
              leading: Icon(Icons.style_outlined, color: scheme.primary),
              title: Text(t.learnedWords),
              subtitle: Text(t.learnedWordsSub),
              trailing: Text(
                '${ref.watch(learnedCountProvider(language)).value ?? 0}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: scheme.primary),
              ),
              onTap: () => context.push('/learned'),
            ),
          ),
          // 建议卡（规则模板）
          for (final sug in suggestions) ...[
            const SizedBox(height: 12),
            _SuggestionCard(suggestion: sug),
          ],
          const SizedBox(height: 12),
          // AI 对话入口（一期占位）
          Card(
            child: ListTile(
              leading: Icon(Icons.smart_toy_outlined, color: scheme.primary),
              title: Text(t.aiPractice),
              subtitle: Text(t.aiPracticeSub),
              trailing: _SoonBadge(text: t.comingSoon),
              onTap: () => context.push('/ai'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 建议卡：icon + 文案 + 可选操作按钮。
class _SuggestionCard extends ConsumerWidget {
  const _SuggestionCard({required this.suggestion});

  final Suggestion suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(suggestion.icon, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Text(suggestion.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Text(suggestion.body,
                style: Theme.of(context).textTheme.bodyMedium),
            if (suggestion.actionLabel != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _applyAction(context, ref),
                  child: Text(suggestion.actionLabel!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _applyAction(BuildContext context, WidgetRef ref) {
    final db = ref.read(dbProvider);
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    switch (suggestion.id) {
      case 'comeback':
        // 复习减半（在引擎建议值与当前值之间取小）。
        final settings = ref.read(settingsProvider).value;
        if (settings == null) return;
        final half =
            (settings.dailyReviewLimit / 2).floor().clamp(10, 200);
        db.settingsDao.updateSettings(
            SettingsCompanion(dailyReviewLimit: Value(half)), nowMs: nowMs);
      case 'clear-reviews':
        context.push('/study');
      case 'scale-up':
        final settings = ref.read(settingsProvider).value;
        if (settings == null) return;
        db.settingsDao.updateSettings(
          SettingsCompanion(
            dailyNewLimit:
                Value((settings.dailyNewLimit + 5).clamp(3, 50)),
            dailyReviewLimit:
                Value((settings.dailyReviewLimit + 10).clamp(10, 200)),
          ),
          nowMs: nowMs,
        );
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(
      {required this.label, required this.value, required this.color,
      this.onTap});

  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 2),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }
}
