import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/app/providers.dart';
import 'package:memorize_word/app/router.dart';
import 'package:memorize_word/core/db/app_database.dart';

/// 引导全链路（含 go_router 守卫）：介绍页 → 选语言 → 定级 → 目标 → 主页。
///
/// 要点：
/// - drift 流的 0ms 定时器在 fake_async 下的限制见 settings_page_test 的注释：
///   全程带时长的 pump 显式推进，结束时卸载树 + dispose 容器冲刷定时器。
/// - Riverpod 3 无监听的 provider 会暂停：真实 app 根组件常驻 watch
///   settingsProvider，测试里同样挂一个常驻监听，模拟根组件。
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  /// 每档 4 个词（freq 递增保证出题顺序确定），释义可区分。
  Future<void> seedLevels(List<String> levels) async {
    var freq = 1;
    final companions = <WordsCompanion>[];
    for (final level in levels) {
      final difficulty = switch (level) {
        'A1' => 1.0,
        'A2' => 2.0,
        'B1' => 3.0,
        'B2' => 4.0,
        'C1' => 5.0,
        'C2' => 6.0,
        _ => 3.0,
      };
      for (var i = 1; i <= 4; i++) {
        companions.add(WordsCompanion.insert(
          id: 'en-$level-$i',
          language: 'en',
          headword: 'w-$level-$i',
          meanings: '[{"lang":"zh","def":"释$level-$i"}]',
          examples: '[]',
          difficulty: difficulty,
          level: level,
          freqRank: Value(freq++),
        ));
      }
    }
    await db.batch((b) => b.insertAll(db.words, companions));
    await db.settingsDao.getOrCreate(
        nowMs: DateTime.now().millisecondsSinceEpoch);
  }

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer(
        overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(() async {
      // 失败也要卸载，避免把容器/流监听泄漏给后续测试。
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
      container.dispose();
      await tester.pump(const Duration(milliseconds: 10));
    });
    container.listen(settingsProvider, (_, _) {}); // 模拟根组件常驻监听
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: container.read(routerProvider)),
    ));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    return container;
  }

  Future<Setting> settings() => (db.select(db.settings)
        ..where((s) => s.id.equals('local')))
      .getSingle();

  Future<void> pump2(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('全对走完定级（8 题 → C2）→ 主页，设置与日志落库', (tester) async {
    await seedLevels(['B1', 'B2', 'C1', 'C2']);
    await pumpApp(tester);

    // 全新安装：守卫应把初始 /home 弹到 /onboarding（介绍页）。
    expect(find.text('科学记单词'), findsOneWidget);

    // 跳过介绍 → 选语言。
    await tester.tap(find.text('跳过'));
    await pump2(tester);
    expect(find.text('选择学习语言'), findsOneWidget);

    // 开始定级 → 第 1 题（B1 档）。
    await tester.tap(find.text('开始定级测试（约 1 分钟）'));
    await pump2(tester);

    // 全对路径：B1×2 → B2×2 → C1×2 → C2×2，共 8 题后完成在 C2（顶档确认）。
    const expectedDefs = [
      '释B1-1', '释B1-2', '释B2-1', '释B2-2',
      '释C1-1', '释C1-2', '释C2-1', '释C2-2',
    ];
    for (final def in expectedDefs) {
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.widgetWithText(OutlinedButton, def));
      await pump2(tester);
      await tester.tap(find.text('下一题'));
      await pump2(tester);
    }

    // 结果页：顶档 C2。
    expect(find.textContaining('精通 C2'), findsOneWidget);
    await tester.tap(find.text('就这样开始'));
    await pump2(tester);

    // 每日目标 → 完成。
    await tester.tap(find.text('完成，开始学习'));
    await pump2(tester);
    await tester.pump(const Duration(milliseconds: 100));

    // 落到主页（守卫重估：onboarded=true 且在 /home）。
    expect(find.text('今日任务'), findsOneWidget);

    final s = await settings();
    expect(s.onboarded, isTrue);
    expect(s.placementDone, isTrue);
    expect(s.placementLevelEn, 'C2');
    expect(s.learningLang, 'en');
    expect(s.dailyNewLimit, 10);
    expect(s.dailyReviewLimit, 50);

    // 定级只记日志：8 条 placement 日志；不进 FSRS、不记每日统计。
    final logs = await db.select(db.studyLogs).get();
    expect(logs, hasLength(8));
    expect(logs.every((l) => l.mode == 'placement'), isTrue);
    final stats = await db.select(db.dailyStats).get();
    expect(stats, isEmpty);
    final progress = await db.select(db.wordProgress).get();
    expect(progress, isEmpty);
  });

  testWidgets('跳过定级 → 默认目标 → 主页，placementDone=false', (tester) async {
    await seedLevels(['B1']);
    await pumpApp(tester);

    await tester.tap(find.text('跳过')); // 介绍页
    await pump2(tester);
    await tester.tap(find.text('跳过测试，从入门级开始')); // 语言页
    await pump2(tester);
    await tester.tap(find.text('完成，开始学习'));
    await pump2(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('今日任务'), findsOneWidget);

    final s = await settings();
    expect(s.onboarded, isTrue);
    expect(s.placementDone, isFalse);
    expect(s.placementLevelEn, isNull);
    expect(s.learningLang, 'en');

    final logs = await db.select(db.studyLogs).get();
    expect(logs, isEmpty);
  });

  testWidgets('重新定级：已引导用户可进 /placement，完成后只写定级字段', (tester) async {
    // 预置：已完成引导 + 调整过的每日目标。
    await seedLevels(['B1']);
    await db.settingsDao.getOrCreate(
        nowMs: DateTime.now().millisecondsSinceEpoch);
    await db.settingsDao.updateSettings(
      const SettingsCompanion(
          onboarded: Value(true), dailyNewLimit: Value(25)),
      nowMs: DateTime.now().millisecondsSinceEpoch,
    );
    final container = await pumpApp(tester);

    // 直接落主页（守卫放行已引导用户）。
    expect(find.text('今日任务'), findsOneWidget);

    // 设置页入口等价于 push('/placement')：直接改路由模拟。
    container.read(routerProvider).go('/placement');
    await pump2(tester);
    expect(find.textContaining('定级测试'), findsOneWidget);

    // 连错 2 题 → 结果 A2。
    for (var round = 0; round < 2; round++) {
      await tester.tap(find.widgetWithText(OutlinedButton, '释B1-3'));
      await pump2(tester);
      await tester.tap(find.text('下一题'));
      await pump2(tester);
    }
    expect(find.textContaining('基础 A2'), findsOneWidget);
    await tester.tap(find.text('就这样开始'));
    await pump2(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('今日任务'), findsOneWidget);
    final s = await settings();
    expect(s.onboarded, isTrue);
    expect(s.placementDone, isTrue);
    expect(s.placementLevelEn, 'A2');
    expect(s.dailyNewLimit, 25); // 重新定级不动每日目标
  });

  testWidgets('连错两题定级结束：保守取低一档（B1 → A2）', (tester) async {
    // 只放 4 个 B1 词：干扰项候选恰为其余 3 个 B1 词，选项完全确定。
    await seedLevels(['B1']);
    await pumpApp(tester);

    await tester.tap(find.text('跳过'));
    await pump2(tester);
    await tester.tap(find.text('开始定级测试（约 1 分钟）'));
    await pump2(tester);

    // 连错 2 题：释B1-3 在两题中都是干扰项。
    for (var round = 0; round < 2; round++) {
      expect(find.byType(CircularProgressIndicator), findsNothing);
      // 正确项文本 = 释B1-1（第 1 题）/ 释B1-2（第 2 题）。
      final correctDef = round == 0 ? '释B1-1' : '释B1-2';
      final wrongFinder = find.widgetWithText(OutlinedButton, '释B1-3');
      expect(wrongFinder, findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, correctDef), findsOneWidget);
      await tester.tap(wrongFinder);
      await pump2(tester);
      await tester.tap(find.text('下一题'));
      await pump2(tester);
    }

    expect(find.textContaining('基础 A2'), findsOneWidget);
    await tester.tap(find.text('就这样开始'));
    await pump2(tester);
    await tester.tap(find.text('完成，开始学习'));
    await pump2(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('今日任务'), findsOneWidget);
    final s = await settings();
    expect(s.placementDone, isTrue);
    expect(s.placementLevelEn, 'A2');
  });
}
