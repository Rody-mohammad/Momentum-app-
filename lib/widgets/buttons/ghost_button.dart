import 'package:flutter/material.dart';
import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/theme/app_radius.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/theme/app_text_styles.dart';

class GhostButton extends StatelessWidget {

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        disabledForegroundColor: AppColors.textQuaternary,
        side: const BorderSide(color: AppColors.borderStandard),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        ),
        textStyle: AppTextStyles.bodyMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.space2),
          ],
          Text(label),
        ],
      ),
    );
  }
}
