import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/features/home/suggestion_engine.dart';

SuggestionInputs input({
  int streak = 0,
  int dueCount = 0,
  double? accuracy,
  int? daysSince,
  int reviewLimit = 50,
}) =>
    SuggestionInputs(
      streak: streak,
      dueCount: dueCount,
      recentAccuracy: accuracy,
      daysSinceLastStudy: daysSince,
      dailyReviewLimit: reviewLimit,
    );

void main() {
  group('回归卡（7 天未学）', () {
    test('7 天未学 → 建议复习减半', () {
      final out = SuggestionEngine.build(input(daysSince: 7, reviewLimit: 60));
      expect(out, hasLength(1));
      expect(out.first.id, 'comeback');
      expect(out.first.body, contains('30')); // 60/2
      expect(out.first.actionLabel, '复习减半');
    });

    test('6 天未学不触发', () {
      expect(SuggestionEngine.build(input(daysSince: 6)), isEmpty);
    });

    test('从未学过不触发', () {
      expect(SuggestionEngine.build(input()), isEmpty);
    });
  });

  group('清复习卡（逾期 > 20）', () {
    test('21 个到期触发', () {
      final out = SuggestionEngine.build(input(dueCount: 21));
      expect(out.single.id, 'clear-reviews');
      expect(out.single.actionLabel, '开始学习');
    });

    test('恰好 20 个不触发', () {
      expect(SuggestionEngine.build(input(dueCount: 20)), isEmpty);
    });
  });

  group('加量卡（连续 ≥5 天且正确率 ≥85%）', () {
    test('达标触发', () {
      final out =
          SuggestionEngine.build(input(streak: 5, accuracy: 85.0));
      expect(out.single.id, 'scale-up');
      expect(out.single.actionLabel, '新词 +5');
    });

    test('连续 4 天不触发', () {
      expect(
          SuggestionEngine.build(input(streak: 4, accuracy: 90)), isEmpty);
    });

    test('正确率 84.9 不触发', () {
      expect(
          SuggestionEngine.build(input(streak: 6, accuracy: 84.9)), isEmpty);
    });

    test('无正确率数据不触发', () {
      expect(SuggestionEngine.build(input(streak: 6)), isEmpty);
    });
  });

  test('优先级与上限：最多 2 张，回归 > 清复习 > 加量', () {
    final out = SuggestionEngine.build(input(
      streak: 8,
      dueCount: 30,
      accuracy: 90,
      daysSince: 9,
    ));
    expect(out.map((s) => s.id).toList(), ['comeback', 'clear-reviews']);
  });

  test('图标为有效 IconData', () {
    final out = SuggestionEngine.build(input(dueCount: 25));
    expect(out.single.icon, isA<IconData>());
  });
}
