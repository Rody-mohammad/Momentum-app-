import 'package:flutter/material.dart';
import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/theme/app_radius.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/theme/app_text_styles.dart';

class HabitCard extends StatelessWidget {

  const HabitCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
    this.isCompleted = false,
  });
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted 
            ? AppColors.successSubtle 
            : AppColors.surface,
        border: Border.all(
          color: isCompleted 
              ? AppColors.success 
              : AppColors.borderStandard,
          width: isCompleted ? 1 : 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusStandard),
      ),
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusStandard),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySemibold.copyWith(
                      color: isCompleted 
                          ? AppColors.success 
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.space1),
                    Text(
                      subtitle!,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            trailing,
          ],
        ),
      ),
    );
  }
}
