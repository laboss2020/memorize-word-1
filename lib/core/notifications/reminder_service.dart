import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../db/app_database.dart';

/// 每日复习提醒（本地通知，每天固定时刻循环）。
///
/// 平台通道在测试环境不可用，所有调用都吞异常降级为 no-op。
/// 通知 id 固定 [dailyNotificationId]，重复调度即覆盖。
class ReminderService {
  ReminderService();

  static const dailyNotificationId = 42;
  static const _title = '背单词';
  static const _body = '今天的复习安排好了，花几分钟巩固一下吧。';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initTimezone();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          // 权限在开启提醒开关时统一请求。
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _initialized = true;
  }

  void _initTimezone() {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(localIanaName(DateTime.now().timeZoneOffset)));
  }

  /// 由 UTC 偏移推 IANA 时区名（无 flutter_timezone 依赖的兜底方案）。
  /// Etc/GMT 符号与日常习惯相反：Etc/GMT-8 = UTC+8。
  @visibleForTesting
  static String localIanaName(Duration offset) {
    const halfHourZones = {
      '5:30': 'Asia/Kolkata',
      '5:45': 'Asia/Kathmandu',
      '3:30': 'Asia/Tehran',
      '4:30': 'Asia/Kabul',
      '6:30': 'Asia/Yangon',
      '9:30': 'Australia/Adelaide',
      '8:45': 'Australia/Eucla',
      '10:30': 'Australia/Lord_Howe',
      '12:45': 'Pacific/Chatham',
      '-2:30': 'America/St_Johns',
      '-3:30': 'America/St_Johns',
      '-9:30': 'Pacific/Marquesas',
    };
    final key =
        '${offset.inHours}:${offset.inMinutes.remainder(60).abs()}';
    if (offset.inMinutes % 60 != 0 && halfHourZones.containsKey(key)) {
      return halfHourZones[key]!;
    }
    final hours = offset.inHours;
    if (hours == 0) return 'UTC';
    return hours > 0 ? 'Etc/GMT-$hours' : 'Etc/GMT+${-hours}';
  }

  /// Android 13+ / iOS 通知运行时权限；被拒绝返回 false。
  Future<bool> requestPermission() async {
    try {
      await _ensureInitialized();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        final granted = await android?.requestNotificationsPermission();
        return granted ?? true;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        final granted = await ios?.requestPermissions(
            alert: true, badge: true, sound: true);
        return granted ?? true;
      }
      return false; // 其他平台无通知实现
    } catch (_) {
      return false;
    }
  }

  /// 按设置同步每日提醒：开启则调度，关闭则取消。
  Future<void> syncFromSettings(Setting settings) async {
    if (!settings.reminderEnabled) {
      await cancelDaily();
      return;
    }
    final parts = settings.reminderTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 20;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
    await scheduleDaily(hour: hour, minute: minute);
  }

  Future<void> scheduleDaily({required int hour, required int minute}) async {
    try {
      await _ensureInitialized();
      var mode = AndroidScheduleMode.exactAllowWhileIdle;
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final exactAllowed = await android.canScheduleExactNotifications();
        if (exactAllowed == false) {
          mode = AndroidScheduleMode.inexactAllowWhileIdle;
        }
      }
      await _plugin.zonedSchedule(
        id: dailyNotificationId,
        title: _title,
        body: _body,
        scheduledDate: _nextOccurrence(hour, minute),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder',
            '每日复习提醒',
            channelDescription: '每天固定时间提醒复习单词',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: mode,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // 测试环境 / 通知不可用：静默降级。
    }
  }

  Future<void> cancelDaily() async {
    try {
      await _ensureInitialized();
      await _plugin.cancel(id: dailyNotificationId);
    } catch (_) {}
  }

  /// 下一个 [hour]:[minute]（已过则明天）。
  tz.TZDateTime _nextOccurrence(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
