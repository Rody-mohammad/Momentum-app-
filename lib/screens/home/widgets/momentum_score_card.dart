import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/theme/app_radius.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/theme/app_text_styles.dart';
import 'package:momentum/providers/stats_provider.dart';

class MomentumScoreCard extends StatelessWidget {
  const MomentumScoreCard({super.key});

  /// Dynamic motivational message based on score level.
  String _getMotivation(int score) {
    if (score == 0) return 'Your journey starts today.';
    if (score < 50) return 'Keep pushing. Every rep counts.';
    if (score < 150) return "You're building real momentum.";
    if (score < 300) return 'Strong consistency. Keep going!';
    if (score < 500) return "Unstoppable. Don't slow down.";
    if (score < 1000) return "Elite level. You're an example.";
    return "Legendary. You've mastered your habits. 🏆";
  }

  /// Score level label shown as a subtle badge.
  String _getLevel(int score) {
    if (score < 50) return 'Beginner';
    if (score < 150) return 'Rising';
    if (score < 300) return 'Consistent';
    if (score < 500) return 'Strong';
    if (score < 1000) return 'Elite';
    return 'Legend';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final statsProvider = context.watch<StatsProvider>();
    final score = statsProvider.momentumScore;
    final tokens = statsProvider.freezeTokens;

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.space5, AppSpacing.space4, AppSpacing.space5, AppSpacing.space2),
      padding: const EdgeInsets.all(AppSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.cardColor,
            AppColors.accentSubtle,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: label + level badge ───────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Life Momentum',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space2),
              _LevelBadge(level: _getLevel(score)),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),

          // ── Score number ───────────────────────────────────────
          Text(
            '$score',
            style: AppTextStyles.displayHero.copyWith(
              color: colors.onSurface,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: AppSpacing.space1),

          // ── Motivational message ───────────────────────────────
          Text(
            _getMotivation(score),
            style: AppTextStyles.small.copyWith(
              color: colors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),

          // ── Divider ────────────────────────────────────────────
          Divider(
            color: AppColors.accentPrimary.withValues(alpha: 0.15),
            height: 1,
          ),
          const SizedBox(height: AppSpacing.space3),

          // ── Freeze tokens row ──────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.shield_rounded,
                color: AppColors.socialColor,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.space2),
              Expanded(
                child: Text(
                  '$tokens Freeze Token${tokens != 1 ? 's' : ''} remaining',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space2),
              // Visual token dots
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: List.generate(
                      tokens.clamp(0, 5),
                      (_) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.socialColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Level badge chip
// ────────────────────────────────────────────────────────────────────────────

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});
  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: AppColors.primaryAccent,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}