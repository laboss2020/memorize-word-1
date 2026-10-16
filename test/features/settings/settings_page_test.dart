import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/app/providers.dart';
import 'package:memorize_word/core/db/app_database.dart';
import 'package:memorize_word/features/settings/settings_page.dart';

/// drift 的 watch 流在取消订阅/表更新时会创建 0ms 定时器（markAsClosed 等），
/// 而 fake_async 下 pump() 不带时长不会触发零时长定时器，还可能让
/// pumpAndSettle 永不结束。因此全程用带时长的 pump 显式推进，并在测试体内
/// 卸载树 + dispose 容器，把定时器全部冲刷掉再结束（否则撞 pending-timer 断言）。
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<ProviderContainer> pump(WidgetTester tester) async {
    final container = ProviderContainer(
        overrides: [dbProvider.overrideWithValue(db)]);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: SettingsPage()),
    ));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    return container;
  }

  /// 卸载 + 冲刷，避免 pending timer。
  Future<void> unwind(WidgetTester tester, ProviderContainer container) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
    container.dispose();
    await tester.pump(const Duration(milliseconds: 10));
  }

  Future<Setting> settings() => (db.select(db.settings)
        ..where((s) => s.id.equals('local')))
      .getSingle();

  testWidgets('默认选中英语，可切换为日语', (tester) async {
    final container = await pump(tester);
    expect((await settings()).learningLang, 'en');

    await tester.tap(find.text('日语'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect((await settings()).learningLang, 'ja');

    await unwind(tester, container);
  });

  testWidgets('每日新词上限步进 ±1', (tester) async {
    final container = await pump(tester);
    expect((await settings()).dailyNewLimit, 10);

    // 每日新词上限一行的 + 按钮（第一个 add 图标属于新词上限）。
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect((await settings()).dailyNewLimit, 11);

    await tester.tap(find.byIcon(Icons.remove).first);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect((await settings()).dailyNewLimit, 10);

    await unwind(tester, container);
  });

  testWidgets('复习提醒开关可关', (tester) async {
    final container = await pump(tester);
    expect((await settings()).reminderEnabled, isTrue);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect((await settings()).reminderEnabled, isFalse);

    await unwind(tester, container);
  });
}
