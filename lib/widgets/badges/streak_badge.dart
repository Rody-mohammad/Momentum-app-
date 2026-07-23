import 'package:flutter/material.dart';
import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/theme/app_radius.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/theme/app_text_styles.dart';

/// Shows the current streak count.
class StreakBadge extends StatelessWidget {
  /// Creates a streak badge.
  const StreakBadge({
    required this.streak,
    this.isLarge = false,
    super.key,
  });

  /// The number of consecutive completed days.
  final int streak;

  /// Whether to use the larger badge layout.
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? AppSpacing.space3 : AppSpacing.space2,
        vertical: isLarge ? AppSpacing.space2 : AppSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentSubtle,
        borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            size: isLarge ? 16 : 14,
            color: AppColors.accentPrimary,
          ),
          const SizedBox(width: AppSpacing.space1),
          Text(
            '$streak',
            style: isLarge 
                ? AppTextStyles.label.copyWith(color: AppColors.accentPrimary)
                : AppTextStyles.micro.copyWith(color: AppColors.accentPrimary),
          ),
        ],
      ),
    );
  }
}
