import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/score_log.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/services/database_service.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.canvas : AppColors.canvasLight;
    final surface = isDark ? AppColors.surface : AppColors.surfaceLight;
    final textPrimary =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text('Habit DNA'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Balance',
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRadarChart(context, textSecondary),
            const SizedBox(height: 32),
            Text(
              'Momentum History (Last 7 Days)',
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildLineChart(textSecondary),
            const SizedBox(height: 32),
            _buildFreezeTokenCard(context, surface, textPrimary, textSecondary),
          ],
        ),
      ),
    );
  }

  // --- RADAR CHART ---
  Widget _buildRadarChart(BuildContext context, Color textSecondary) {
    final habits = context.watch<HabitProvider>().habits;
    final categoryData = <String, double>{};

    // Initialize categories
    for (final cat in HabitCategory.values) {
      categoryData[cat.name] = 0.0;
    }

    // Calculate completion percentage per category over the last 7 days
    final now = DateTime.now();
    for (final habit in habits) {
      final logs = DatabaseService.getLogsForHabit(habit.id);
      double daysCompleted = 0;
      for (var i = 0; i < 7; i++) {
        final checkDate =
            DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
        if (logs.any((l) => l.date == checkDate && l.isCompleted)) {
          daysCompleted++;
        }
      }
      // Average out if there are multiple habits in the same category
      categoryData[habit.category.name] =
          categoryData[habit.category.name]! + (daysCompleted / 7) * 100;
    }

    // Normalize to 100% max per category
    final categoryCount = <String, int>{};
    for (final habit in habits) {
      categoryCount[habit.category.name] =
          (categoryCount[habit.category.name] ?? 0) + 1;
    }
    categoryData.forEach((key, value) {
      final count = categoryCount[key] ?? 1;
      categoryData[key] = (value / count).clamp(0.0, 100.0);
    });

    return AspectRatio(
      aspectRatio: 1.2,
      child: RadarChart(
        RadarChartData(
          gridBorderData: BorderSide(color: textSecondary.withValues(alpha: 0.2)),
          tickCount: 4,
          tickBorderData: BorderSide(color: textSecondary.withValues(alpha: 0.2)),
          titlePositionPercentageOffset: 0.2,
          titleTextStyle: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w600),
          getTitle: (index, angle) {
            if (index < 0 || index >= HabitCategory.values.length) {
              return const RadarChartTitle(text: '');
            }
            final cat = HabitCategory.values[index];
            final name = cat.name[0].toUpperCase() + cat.name.substring(1);
            return RadarChartTitle(text: name, angle: angle);
          },
          dataSets: [
            RadarDataSet(
              fillColor: AppColors.accentSubtle,
              borderColor: AppColors.accentPrimary,
              entryRadius: 3,
              dataEntries: categoryData.entries
                  .map((e) => RadarEntry(value: e.value))
                  .toList(),
            ),
          ],
          radarBorderData:
              BorderSide(color: textSecondary.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  // --- LINE CHART ---
  Widget _buildLineChart(Color textSecondary) {
    final allLogs = DatabaseService.getScoreLogs();

    // Filter last 7 days
    final now = DateTime.now();
    final last7Days = <ScoreLog>[];
    for (var i = 6; i >= 0; i--) {
      final dateStr =
          DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
      final log = allLogs.where((l) => l.date == dateStr).firstOrNull;
      last7Days.add(log ?? ScoreLog(id: '0', date: dateStr, score: 0));
    }

    return AspectRatio(
      aspectRatio: 1.8,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= last7Days.length) {
                    return const SizedBox();
                  }
                  final date = DateTime.parse(last7Days[index].date);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('EEE').format(date),
                      style: TextStyle(color: textSecondary, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              
            ),
            topTitles: const AxisTitles(
              
            ),
            rightTitles: const AxisTitles(
              
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              gradient: const LinearGradient(
                colors: [AppColors.accentPrimary, AppColors.socialColor],
              ),
              barWidth: 3,
              spots: last7Days
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.score.toDouble()))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- FREEZE TOKEN CARD ---
  Widget _buildFreezeTokenCard(
    BuildContext context,
    Color surface,
    Color textPrimary,
    Color textSecondary,
  ) {
    final tokens = context.watch<StatsProvider>().freezeTokens;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.socialColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.socialColor,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Freeze Tokens',
                  style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Automatically protects your streak if you miss a day.',
                  style: TextStyle(
                    color: textSecondary.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$tokens',
            style: const TextStyle(
              color: AppColors.socialColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}