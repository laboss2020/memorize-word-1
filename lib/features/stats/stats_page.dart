import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/db/app_database.dart';
import '../../core/utils/study_day.dart';
import 'stats_providers.dart';

/// 统计页：连续打卡 / 累计数字 / 近 30 天柱状图与正确率 / 掌握度环形图 / 近一年热力图。
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider).value ?? 0;
    final today = ref.watch(todayStatsProvider).value;
    final totals = ref.watch(totalsProvider).value;
    final series = ref.watch(dailySeriesProvider).value;
    final mastery = ref.watch(masteryProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('统计')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatTiles(
            streak: streak,
            todayTotal: today?.totalCount ?? 0,
            todayCorrect: today?.correctCount ?? 0,
            totalMinutes: totals?.minutes ?? 0,
            totalWords: totals?.total ?? 0,
          ),
          const SizedBox(height: 16),
          if (series != null) ...[
            _BarChartCard(stats: series),
            const SizedBox(height: 16),
            _AccuracyCard(stats: series),
            const SizedBox(height: 16),
          ],
          if (mastery != null) ...[
            _MasteryCard(mastery: mastery),
            const SizedBox(height: 16),
          ],
          if (series != null) _HeatmapCard(stats: series),
        ],
      ),
    );
  }
}

// ---- 顶部数字 ----

class _StatTiles extends StatelessWidget {
  const _StatTiles({
    required this.streak,
    required this.todayTotal,
    required this.todayCorrect,
    required this.totalMinutes,
    required this.totalWords,
  });

  final int streak;
  final int todayTotal;
  final int todayCorrect;
  final int totalMinutes;
  final int totalWords;

  @override
  Widget build(BuildContext context) {
    final accuracy =
        todayTotal == 0 ? 0 : (todayCorrect * 100 / todayTotal).round();
    final hours = (totalMinutes / 60).toStringAsFixed(1);
    return Row(
      children: [
        Expanded(
            child: _StatTile(
                icon: Icons.local_fire_department,
                color: Colors.deepOrange,
                value: '$streak',
                label: '连续打卡（天）')),
        Expanded(
            child: _StatTile(
                icon: Icons.today,
                color: Colors.blue,
                value: '$todayTotal',
                label: '今日完成')),
        Expanded(
            child: _StatTile(
                icon: Icons.check_circle_outline,
                color: Colors.green,
                value: '$accuracy%',
                label: '今日正确率')),
        Expanded(
            child: _StatTile(
                icon: Icons.schedule,
                color: Colors.purple,
                value: hours,
                label: '累计学习（小时）')),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ---- 近 30 天学习量柱状图 ----

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({required this.stats});

  final List<DailyStat> stats;

  @override
  Widget build(BuildContext context) {
    final byDate = {for (final s in stats) s.date: s};
    final keys = _recentKeys(30);
    final bars = [
      for (final k in keys) (byDate[k]?.totalCount ?? 0).toDouble(),
    ];
    final maxVal = bars.fold<double>(4, (a, b) => b > a ? b : a);

    return _ChartCard(
      title: '近 30 天学习量',
      child: SizedBox(
        height: 160,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: maxVal * 1.15,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                  rod.toY.round().toString(),
                  const TextStyle(color: Colors.white),
                ),
              ),
            ),
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              for (var i = 0; i < bars.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: bars[i],
                      width: 6,
                      borderRadius: BorderRadius.circular(2),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- 近 30 天正确率折线 ----

class _AccuracyCard extends StatelessWidget {
  const _AccuracyCard({required this.stats});

  final List<DailyStat> stats;

  @override
  Widget build(BuildContext context) {
    final byDate = {for (final s in stats) s.date: s};
    final keys = _recentKeys(30);
    final spots = <FlSpot>[];
    for (var i = 0; i < keys.length; i++) {
      final s = byDate[keys[i]];
      if (s == null || s.totalCount == 0) continue;
      spots.add(FlSpot(i.toDouble(), s.correctCount * 100 / s.totalCount));
    }

    return _ChartCard(
      title: '近 30 天正确率（%）',
      child: SizedBox(
        height: 140,
        child: spots.isEmpty
            ? const Center(child: Text('还没有学习记录'))
            : LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
                  lineTouchData: const LineTouchData(enabled: false),
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// ---- 掌握度环形图 ----

class _MasteryCard extends StatelessWidget {
  const _MasteryCard({required this.mastery});

  final ({int fresh, int learning, int young, int mature}) mastery;

  @override
  Widget build(BuildContext context) {
    const colors = [Colors.grey, Colors.orange, Colors.blue, Colors.green];
    const labels = ['未学', '学习中', '巩固中', '已掌握'];
    final values = [
      mastery.fresh.toDouble(),
      mastery.learning.toDouble(),
      mastery.young.toDouble(),
      mastery.mature.toDouble(),
    ];
    final total = values.fold<double>(0, (a, b) => a + b);

    return _ChartCard(
      title: '掌握度分布',
      child: Row(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: total == 0
                ? const Center(child: Text('暂无数据'))
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 36,
                      sections: [
                        for (var i = 0; i < 4; i++)
                          if (values[i] > 0)
                            PieChartSectionData(
                              value: values[i],
                              color: colors[i],
                              radius: 22,
                              showTitle: false,
                            ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 4; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration:
                              BoxDecoration(color: colors[i], shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(labels[i])),
                        Text('${values[i].round()}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---- 近一年热力图 ----

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.stats});

  final List<DailyStat> stats;

  static const _cell = 11.0;
  static const _gap = 3.0;

  @override
  Widget build(BuildContext context) {
    final byDate = {for (final s in stats) s.date: s.totalCount};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // 今天所在周的周一为最后一列；共 53 列。
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final start = monday.subtract(const Duration(days: 52 * 7));

    final scheme = Theme.of(context).colorScheme;
    Color cellColor(int count) {
      if (count <= 0) return scheme.surfaceContainerHighest;
      if (count < 10) return scheme.primary.withValues(alpha: 0.30);
      if (count < 20) return scheme.primary.withValues(alpha: 0.60);
      return scheme.primary;
    }

    return _ChartCard(
      title: '近一年热力图',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // 默认停在最近一周
        child: SizedBox(
          height: 7 * _cell + 6 * _gap,
          child: Row(
            children: [
              for (var col = 0; col < 53; col++)
                Padding(
                  padding: EdgeInsets.only(right: col == 52 ? 0 : _gap),
                  child: Column(
                    children: [
                      for (var row = 0; row < 7; row++)
                        Padding(
                          padding: EdgeInsets.only(bottom: row == 6 ? 0 : _gap),
                          child: _cellOrSpacer(start, col, row, today, byDate,
                              cellColor, scheme),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cellOrSpacer(
      DateTime start,
      int col,
      int row,
      DateTime today,
      Map<String, int> byDate,
      Color Function(int) cellColor,
      ColorScheme scheme) {
    final day = start.add(Duration(days: col * 7 + row));
    if (day.isAfter(today)) {
      return SizedBox(width: _cell, height: _cell); // 未来日期留空
    }
    final count = byDate[localStudyDay(day)] ?? 0;
    return Tooltip(
      message: '${day.month}/${day.day}：$count 项',
      child: Container(
        width: _cell,
        height: _cell,
        decoration: BoxDecoration(
          color: cellColor(count),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ---- 公共 ----

/// 近 [days] 天的日期键（含今天，升序）。
List<String> _recentKeys(int days) {
  final today = localStudyDay(DateTime.now());
  return [for (var i = days - 1; i >= 0; i--) studyDayBefore(today, i)];
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
