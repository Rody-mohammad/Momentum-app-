import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';

class HabitBottomSheet extends StatelessWidget {
  const HabitBottomSheet({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surface : AppColors.surfaceLight;
    final textPrimary =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            habit.name,
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            habit.category.name.toUpperCase(),
            style: TextStyle(
              color: AppColors.getCategoryColor(habit.category.index),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 24),

          _buildTile(
            icon: Icons.info_outline_rounded,
            title: 'View Details',
            color: AppColors.accentPrimary,
            textPrimary: textPrimary,
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
              context.push('/habit-detail', extra: habit);
            },
          ),

          _buildTile(
            icon: Icons.edit_outlined,
            title: 'Edit Habit',
            color: AppColors.workColor,
            textPrimary: textPrimary,
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
              context.push('/edit-habit', extra: habit);
            },
          ),

          _buildTile(
            icon: Icons.history_rounded,
            title: 'Backfill Past Day',
            color: AppColors.socialColor,
            textPrimary: textPrimary,
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
              _selectBackfillDate(context);
            },
          ),

          _buildTile(
            icon: Icons.archive_outlined,
            title: 'Archive Habit',
            color: AppColors.error,
            textPrimary: textPrimary,
            onTap: () {
              HapticFeedback.heavyImpact();
              context.read<HabitProvider>().archiveHabit(habit.id);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Habit archived.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color color,
    required Color textPrimary,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textPrimary.withValues(alpha: 0.3),
        size: 20,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: onTap,
    );
  }

  void _selectBackfillDate(BuildContext context) {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 1)),
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).brightness == Brightness.dark
              ? const ColorScheme.dark(primary: AppColors.accentPrimary)
              : const ColorScheme.light(primary: AppColors.accentPrimary),
        ),
        child: child!,
      ),
    ).then((pickedDate) async {
      if (pickedDate != null) {
        if (!context.mounted) return;
        final habitProvider = context.read<HabitProvider>();
        final statsProvider = context.read<StatsProvider>();
        final result = await habitProvider.toggleHabitCompletion(
          habit.id,
          pickedDate,
        );
        if (result.becameCompleted) {
          await statsProvider.addScore(10);
        }
      }
    });
  }
}