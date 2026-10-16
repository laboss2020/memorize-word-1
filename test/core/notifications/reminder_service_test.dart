import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/core/notifications/reminder_service.dart';

/// 时区偏移 → IANA 名映射（无 flutter_timezone 依赖的兜底）。
void main() {
  test('整小时偏移 → Etc/GMT（符号相反）', () {
    expect(ReminderService.localIanaName(Duration.zero), 'UTC');
    expect(ReminderService.localIanaName(const Duration(hours: 8)),
        'Etc/GMT-8'); // UTC+8
    expect(ReminderService.localIanaName(const Duration(hours: -5)),
        'Etc/GMT+5'); // UTC-5
  });

  test('半小时偏移 → 代表性 IANA 名', () {
    expect(ReminderService.localIanaName(const Duration(hours: 5, minutes: 30)),
        'Asia/Kolkata');
    expect(ReminderService.localIanaName(const Duration(hours: 9, minutes: 30)),
        'Australia/Adelaide');
    expect(
        ReminderService.localIanaName(const Duration(hours: -3, minutes: 30)),
        'America/St_Johns');
  });
}
