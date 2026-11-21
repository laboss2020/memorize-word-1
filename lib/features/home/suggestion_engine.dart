/// 主页建议卡（规则模板，纯函数可单测）。
///
/// 规则优先级：回归 > 先清复习 > 建议加量，最多展示 2 张。
library;

import 'package:flutter/material.dart';

import '../../app/strings.dart';

class Suggestion {
  const Suggestion({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;

  /// 非空时卡片带操作按钮（由页面按 id 分发）。
  final String? actionLabel;
}

class SuggestionInputs {
  const SuggestionInputs({
    required this.streak,
    required this.dueCount,
    this.recentAccuracy,
    this.daysSinceLastStudy,
    required this.dailyReviewLimit,
  });

  /// 连续打卡天数。
  final int streak;

  /// 到期未复习数。
  final int dueCount;

  /// 近 7 天正确率（%）；无答题记录为 null。
  final double? recentAccuracy;

  /// 距上次学习天数；从未学过为 null。
  final int? daysSinceLastStudy;

  final int dailyReviewLimit;
}

class SuggestionEngine {
  SuggestionEngine._();

  static const _maxCards = 2;

  static List<Suggestion> build(SuggestionInputs input, AppStrings s) {
    final out = <Suggestion>[];

    // 1. 长时间未学 → 复习减半回归。
    final absent = input.daysSinceLastStudy;
    if (absent != null && absent >= 7) {
      final half = (input.dailyReviewLimit / 2).floor().clamp(10, 200);
      out.add(Suggestion(
        id: 'comeback',
        icon: Icons.waving_hand_outlined,
        title: s.suggestionWelcomeBack,
        body: s.suggestionComebackBody(absent, half),
        actionLabel: s.suggestionHalveReviews,
      ));
    }

    // 2. 逾期较多 → 先清复习。
    if (input.dueCount > 20) {
      out.add(Suggestion(
        id: 'clear-reviews',
        icon: Icons.notifications_active_outlined,
        title: s.suggestionBacklog,
        body: s.suggestionBacklogBody(input.dueCount),
        actionLabel: s.startStudy,
      ));
    }

    // 3. 连续打卡且正确率高 → 建议加量。
    final accuracy = input.recentAccuracy;
    if (input.streak >= 5 && accuracy != null && accuracy >= 85) {
      out.add(Suggestion(
        id: 'scale-up',
        icon: Icons.trending_up_outlined,
        title: s.suggestionGoodShape,
        body: s.suggestionScaleUpBody(input.streak, accuracy.round()),
        actionLabel: s.suggestionNewPlus5,
      ));
    }

    return out.take(_maxCards).toList();
  }
}
