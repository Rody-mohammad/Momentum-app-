import 'package:flutter/material.dart';
import 'package:momentum/core/theme/app_colors.dart';

class AppTextStyles {
  // Display Styles
  static const TextStyle displayHero = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle display = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -1,
    color: AppColors.textPrimary,
  );

  // Heading Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.13,
    letterSpacing: -0.7,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: -0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySemibold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Small Styles
  static const TextStyle small = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle smallMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.15,
    color: AppColors.textPrimary,
  );

  // Caption & Label Styles
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.15,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle micro = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Monospace Styles
  static const TextStyle monoBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    fontFamily: 'JetBrains Mono',
  );

  static const TextStyle monoCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    fontFamily: 'JetBrains Mono',
  );
}
