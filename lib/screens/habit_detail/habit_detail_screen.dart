import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/utils/date_utils.dart';
import 'package:momentum/core/utils/streak_calculator.dart';
import 'package:momentum/models/badge_model.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/services/streak_service.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habit});
  final Habit habit;

  Color get _categoryColor =>
      AppColors.getCategoryColor(habit.category.index);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final habitProvider = context.watch<HabitProvider>();
    final logs = habitProvider.getLogsForHabit(habit.id);
    final streak = StreakCalculator.calculateCurrentStreak(habit,logs);
    final totalDone = StreakService.totalCompletions(logs);

    final todayStr = AppDateUtils.todayStr();
    final isCompletedToday =
        logs.any((l) => l.date == todayStr && l.isCompleted);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── Sliver App Bar ──────────────────────────────────────
          SliverAppBar(
            backgroundColor: bg,
            pinned: true,
            expandedHeight: 300,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: textPrimary),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: textSecondary),
                onPressed: () {
                  context.pop();
                  context.push('/edit-habit', extra: habit);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _OrbHero(
                habit: habit,
                isCompletedToday: isCompletedToday,
                categoryColor: _categoryColor,
                streak: streak,
                textPrimary: textPrimary,
                bg: bg,
              ),
            ),
          ),

          // ── Body content ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Habit name + category
                  Text(
                    habit.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _CategoryChip(
                        habit: habit,
                        categoryColor: _categoryColor,
                      ),
                      _FrequencyChip(
                        habit: habit,
                        categoryColor: _categoryColor,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Stats row ─────────────────────────────────
                  _StatsRow(
                    streak: streak,
                    totalDone: totalDone,
                    categoryColor: _categoryColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    surface: surface,
                  ),
                  const SizedBox(height: 28),

                  // ── 7-Day heatmap ─────────────────────────────
                  Text(
                    'LAST 7 DAYS',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _WeekHeatmap(
                    logs: logs,
                    categoryColor: _categoryColor,
                    textSecondary: textSecondary,
                    surface: surface,
                  ),
                  const SizedBox(height: 28),

                  // ── Badges ────────────────────────────────────
                  Text(
                    'MILESTONE BADGES',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _BadgesRow(currentStreak: streak),
                  const SizedBox(height: 28),

                  // ── Quick Actions ─────────────────────────────
                  _QuickActions(
                    habit: habit,
                    isCompletedToday: isCompletedToday,
                    categoryColor: _categoryColor,
                    surface: surface,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Orb Hero (top of the flexible space)
// ────────────────────────────────────────────────────────────────────────────

class _OrbHero extends StatelessWidget {

  const _OrbHero({
    required this.habit,
    required this.isCompletedToday,
    required this.categoryColor,
    required this.streak,
    required this.textPrimary,
    required this.bg,
  });
  final Habit habit;
  final bool isCompletedToday;
  final Color categoryColor;
  final int streak;
  final Color textPrimary;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompletedToday
                  ? categoryColor.withValues(alpha: 0.2)
                  : Colors.transparent,
              border: Border.all(
                color: categoryColor,
                width: isCompletedToday ? 3 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: categoryColor.withValues(
                    alpha: isCompletedToday ? 0.5 : 0.15,
                  ),
                  blurRadius: isCompletedToday ? 40 : 20,
                  spreadRadius: isCompletedToday ? 4 : 1,
                ),
              ],
            ),
            child: Center(
              child: isCompletedToday
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: categoryColor,
                      size: 52,
                    )
                  : streak > 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '🔥',
                              style: TextStyle(fontSize: 28),
                            ),
                            Text(
                              '$streak',
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: categoryColor.withValues(alpha: 0.5),
                          size: 40,
                        ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isCompletedToday
                ? 'Done for today! ✅'
                : 'Not completed yet today',
            style: TextStyle(
              color: textPrimary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Category chip
// ────────────────────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.habit, required this.categoryColor});
  final Habit habit;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        habit.category.name.toUpperCase(),
        style: TextStyle(
          color: categoryColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Stats row
// ────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {

  const _StatsRow({
    required this.streak,
    required this.totalDone,
    required this.categoryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
  });
  final int streak;
  final int totalDone;
  final Color categoryColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            emoji: '🔥',
            value: '$streak',
            label: 'Day Streak',
            color: categoryColor,
            surface: surface,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            emoji: '✅',
            value: '$totalDone',
            label: 'Total Done',
            color: AppColors.success,
            surface: surface,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });
  final String emoji;
  final String value;
  final String label;
  final Color color;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// 7-Day heatmap
// ────────────────────────────────────────────────────────────────────────────

class _WeekHeatmap extends StatelessWidget {

  const _WeekHeatmap({
    required this.logs,
    required this.categoryColor,
    required this.textSecondary,
    required this.surface,
  });
  final List<HabitLog> logs;
  final Color categoryColor;
  final Color textSecondary;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final days = AppDateUtils.lastNDays(7);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((dateStr) {
        final isCompleted =
            logs.any((l) => l.date == dateStr && l.isCompleted == true);
        final isFrozen = logs
            .any((l) => l.date == dateStr && l.usedFreezeToken == true);
        final dayLabel = AppDateUtils.shortDayLabel(dateStr);
        final isToday = dateStr == AppDateUtils.todayStr();

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 38,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? categoryColor.withValues(alpha: 0.85)
                        : isFrozen
                            ? AppColors.socialColor.withValues(alpha: 0.3)
                            : surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isToday
                          ? categoryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: categoryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          )
                        : isFrozen
                            ? const Text(
                                '🛡️',
                                style: TextStyle(fontSize: 12),
                              )
                            : null,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  dayLabel.substring(0, 1),
                  style: TextStyle(
                    color: isToday ? categoryColor : textSecondary,
                    fontSize: 10,
                    fontWeight:
                        isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Badges row
// ────────────────────────────────────────────────────────────────────────────

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.currentStreak});
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: BadgeModel.all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final badge = BadgeModel.all[index];
          final isEarned = currentStreak >= badge.milestone;
          return _MilestoneBadge(badge: badge, isEarned: isEarned);
        },
      ),
    );
  }
}

class _MilestoneBadge extends StatelessWidget {
  const _MilestoneBadge({required this.badge, required this.isEarned});

  final BadgeModel badge;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    final color = isEarned ? AppColors.accentPrimary : AppColors.textTertiary;

    return Container(
      width: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isEarned ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(badge.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            badge.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${badge.milestone} days',
            style: TextStyle(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Quick Actions
// ────────────────────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {

  const _QuickActions({
    required this.habit,
    required this.isCompletedToday,
    required this.categoryColor,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });
  final Habit habit;
  final bool isCompletedToday;
  final Color categoryColor;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.read<HabitProvider>();
    final statsProvider = context.read<StatsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            unawaited(HapticFeedback.mediumImpact());
            final result = await habitProvider.toggleHabitCompletion(
              habit.id,
              DateTime.now(),
            );
            if (result.becameCompleted) {
              await statsProvider.addScore(10);
            } else {
              await statsProvider.addScore(-5);
            }
          },
          icon: Icon(
            isCompletedToday
                ? Icons.close_rounded
                : Icons.check_circle_rounded,
          ),
          label: Text(
            isCompletedToday
                ? 'Mark as Incomplete'
                : 'Complete for Today',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isCompletedToday ? surface : categoryColor,
            foregroundColor:
                isCompletedToday ? textSecondary : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isCompletedToday
                  ? BorderSide(
                      color: textSecondary.withValues(alpha: 0.3),
                    )
                  : BorderSide.none,
            ),
            elevation: 0,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.heavyImpact();
            _showArchiveConfirm(context, habitProvider);
          },
          icon: const Icon(Icons.archive_outlined),
          label: const Text('Archive Habit'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: BorderSide(
              color: AppColors.danger.withValues(alpha: 0.4),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  void _showArchiveConfirm(
    BuildContext context,
    HabitProvider habitProvider,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Archive this habit?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"${habit.name}" will be removed from your home screen.',
          style: TextStyle(color: textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              unawaited(habitProvider.archiveHabit(habit.id));
              Navigator.of(ctx).pop();
              context.go('/');
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }
}

class _FrequencyChip extends StatelessWidget {

  const _FrequencyChip({
    required this.habit,
    required this.categoryColor,
    required this.textSecondary,
  });
  final Habit habit;
  final Color categoryColor;
  final Color textSecondary;

  String _getFrequencyText() {
    switch (habit.frequencyType) {
      case FrequencyType.daily:
        return 'DAILY';
      case FrequencyType.weekly:
        if (habit.weeklyDays.length == 7) {
          return 'DAILY';
        }
        final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final days = habit.weeklyDays.map((d) => weekdays[d - 1]).toList();
        return days.join(' ').toUpperCase();
      case FrequencyType.interval:
        return 'EVERY ${habit.intervalDays} DAYS';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: textSecondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textSecondary.withValues(alpha: 0.2)),
      ),
      child: Text(
        _getFrequencyText(),
        style: TextStyle(
          color: textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
