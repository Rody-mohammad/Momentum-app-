import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/theme/app_text_styles.dart';
import 'package:momentum/core/utils/date_utils.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/screens/home/widgets/habit_orb.dart';
import 'package:momentum/screens/home/widgets/momentum_score_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final today = DateTime.now();
    final habits = context.watch<HabitProvider>().habits.where((h) => h.isScheduledOn(today)).toList();
    final todayStr = DateFormat('yyyy-MM-dd').format(today);

    // Group habits by time of day
    final morningHabits =
        habits.where((h) => h.timeOfDay == HabitTimeOfDay.morning).toList();
    final afternoonHabits =
        habits.where((h) => h.timeOfDay == HabitTimeOfDay.afternoon).toList();
    final eveningHabits =
        habits.where((h) => h.timeOfDay == HabitTimeOfDay.evening).toList();
    final anytimeHabits =
        habits.where((h) => h.timeOfDay == HabitTimeOfDay.anytime).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.space6, AppSpacing.space6, AppSpacing.space6, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppDateUtils.greeting(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.small.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space1),
                        Text(
                          'Momentum',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: colors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Momentum Score Card ────────────────────────────────
          const SliverToBoxAdapter(child: MomentumScoreCard()),

          // ── Habit Sections ─────────────────────────────────────
          if (habits.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.space16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.circle_outlined,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: AppSpacing.space5),
                    const Text(
                      'No habits yet.',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      'Tap + to start building momentum!',
                      style: AppTextStyles.small.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            _buildSectionHeader('Morning ☀️', morningHabits, context),
            _buildHabitGrid(morningHabits, todayStr, context),

            _buildSectionHeader('Afternoon ⛅', afternoonHabits, context),
            _buildHabitGrid(afternoonHabits, todayStr, context),

            _buildSectionHeader('Evening 🌙', eveningHabits, context),
            _buildHabitGrid(eveningHabits, todayStr, context),

            _buildSectionHeader('Anytime ✨', anytimeHabits, context),
            _buildHabitGrid(anytimeHabits, todayStr, context),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.space16)),
          ],
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => context.push('/add-habit'),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    List<Habit> sectionHabits,
    BuildContext context,
  ) {
    // Only show header if section has habits
    if (sectionHabits.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.space6, AppSpacing.space6, AppSpacing.space6, AppSpacing.space2),
        child: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildHabitGrid(
    List<Habit> sectionHabits,
    String todayStr,
    BuildContext context,
  ) {
    if (sectionHabits.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (ctx, index) {
          final habit = sectionHabits[index];
          final logs = ctx.read<HabitProvider>().getLogsForHabit(habit.id);
          final isCompletedToday =
              logs.any((log) => log.date == todayStr && log.isCompleted);

          return HabitOrb(
            habit: habit,
            isCompletedToday: isCompletedToday,
          );
        },
        childCount: sectionHabits.length,
      ),
    );
  }
}