import 'dart:math';

import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/theme/app_text_styles.dart';
import 'package:momentum/core/utils/streak_calculator.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/screens/home/widgets/habit_bottom_sheet.dart';

class HabitOrb extends StatefulWidget {
  const HabitOrb({
    required this.habit, required this.isCompletedToday, super.key,
  });

  final Habit habit;
  final bool isCompletedToday;

  @override
  State<HabitOrb> createState() => _HabitOrbState();
}

class _HabitOrbState extends State<HabitOrb>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confetti;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _confetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseAnim = Tween<double>(begin: 1, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Pulse only when there's an active streak
    _updatePulse();
  }

  @override
  void didUpdateWidget(HabitOrb old) {
    super.didUpdateWidget(old);
    _updatePulse();
  }

  void _updatePulse() {
    final logs = context.read<HabitProvider>().getLogsForHabit(widget.habit.id);
    final streak = StreakCalculator.calculateCurrentStreak(widget.habit, logs);
    if (streak > 0 && !widget.isCompletedToday) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _categoryColor =>
      AppColors.getCategoryColor(widget.habit.category.index);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final habitProvider = context.read<HabitProvider>();
    final statsProvider = context.read<StatsProvider>();

    final logs = habitProvider.getLogsForHabit(widget.habit.id);
    final streak = StreakCalculator.calculateCurrentStreak(widget.habit, logs);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // ── Main Orb ─────────────────────────────────────────────
        GestureDetector(
          // Tap → navigate to Habit Detail
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/habit-detail', extra: widget.habit);
          },

          // Long press → complete/undo + show bottom sheet
          onLongPress: () async {
            unawaited(HapticFeedback.heavyImpact());

            // First: toggle completion
            final result = await habitProvider.toggleHabitCompletion(
              widget.habit.id,
              DateTime.now(),
            );

            if (result.becameCompleted) {
              await statsProvider.addScore(10);

              // 🎉 Fire confetti if a new milestone badge was just earned
              if (result.newBadge != null) {
                _confetti.play();
                if (context.mounted) {
                  _showMilestoneBanner(
                    context,
                    result.newBadge!.emoji,
                    result.newBadge!.title,
                  );
                }
              }
            } else {
              await statsProvider.addScore(-5);
            }

            // Then: show the options bottom sheet
            if (context.mounted) {
              unawaited(
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => HabitBottomSheet(habit: widget.habit),
                ),
              );
            }
          },

          child: ScaleTransition(
            scale: _pulseAnim,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              margin: const EdgeInsets.all(AppSpacing.space2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isCompletedToday
                    ? _categoryColor.withValues(alpha: 0.18)
                  : Theme.of(context).cardColor,
                border: Border.all(
                  color: widget.isCompletedToday
                      ? _categoryColor
                      : _categoryColor.withValues(alpha: 0.25),
                  width: widget.isCompletedToday ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isCompletedToday
                        ? _categoryColor.withValues(alpha: 0.45)
                        : _categoryColor.withValues(alpha: 0.08),
                    blurRadius: widget.isCompletedToday ? 24 : 8,
                    spreadRadius: widget.isCompletedToday ? 2 : 0,
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.space2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Icon area ─────────────────────────────
                      if (widget.isCompletedToday)
                        Icon(
                          Icons.check_circle_rounded,
                          color: _categoryColor,
                          size: 30,
                        )
                      else if (streak > 0)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '🔥',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '$streak',
                              style: AppTextStyles.heading3.copyWith(
                                color: _categoryColor,
                                height: 1.1,
                              ),
                            ),
                          ],
                        )
                      else
                        Icon(
                          Icons.circle_outlined,
                          color: AppColors.textTertiary.withValues(alpha: 0.25),
                          size: 28,
                        ),

                      const SizedBox(height: AppSpacing.space1),

                      // ── Habit name ────────────────────────────
                      Text(
                        widget.habit.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(
                          color: widget.isCompletedToday
                              ? colors.onSurface
                              : colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Confetti overlay ──────────────────────────────────────
        Positioned(
          top: 0,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirection: pi / 2, // Downward
            numberOfParticles: 18,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.3,
            colors: [
              _categoryColor,
              AppColors.accentPrimary,
              AppColors.success,
              AppColors.socialColor,
              AppColors.textPrimary,
            ],
          ),
        ),
      ],
    );
  }

  void _showMilestoneBanner(
    BuildContext context,
    String emoji,
    String title,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Badge earned: $title!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _categoryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
