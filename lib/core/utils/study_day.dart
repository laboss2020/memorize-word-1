/// 本地"学习日"工具：统计与每日配额以设备本地时区的自然日为界。
library;

/// 本地日期 → 'YYYY-MM-DD'。
String localStudyDay(DateTime now) {
  final local = now.toLocal();
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  return '${local.year}-$m-$d';
}

/// 'YYYY-MM-DD' 前推 n 天（简单按月回退可能跨界，此处用 DateTime 计算）。
String studyDayBefore(String day, int n) {
  final parts = day.split('-');
  final date = DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  ).subtract(Duration(days: n));
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

/// 'HH:mm'（本地时区）解析为当天分钟数；非法输入返回默认 20:00。
int parseReminderMinutes(String hhmm) {
  final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(hhmm.trim());
  if (m == null) return 20 * 60;
  final h = int.parse(m.group(1)!);
  final min = int.parse(m.group(2)!);
  if (h > 23 || min > 59) return 20 * 60;
  return h * 60 + min;
}

/// 连续打卡天数：从今天（今天未学则从昨天）往前数连续有学习的天数。
/// [dates] 为 'YYYY-MM-DD' 集合（任意顺序）。
int computeStreak(Set<String> dates, {String? today}) {
  var cursor = today ?? localStudyDay(DateTime.now());
  if (!dates.contains(cursor)) {
    cursor = studyDayBefore(cursor, 1);
    if (!dates.contains(cursor)) return 0;
  }
  var streak = 0;
  while (dates.contains(cursor)) {
    streak++;
    cursor = studyDayBefore(cursor, 1);
  }
  return streak;
}
