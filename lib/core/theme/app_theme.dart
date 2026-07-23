import 'package:flutter/material.dart';
import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/core/theme/app_radius.dart';
import 'package:momentum/core/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._(); // Prevent instantiation

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.canvas,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentPrimary,
        onPrimary: AppColors.textPrimary,
        secondary: AppColors.accentSecondary,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textPrimary,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayHero,
        displayMedium: AppTextStyles.displayLarge,
        displaySmall: AppTextStyles.display,
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        titleLarge: AppTextStyles.bodyLarge,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.small,
        labelLarge: AppTextStyles.caption,
        labelMedium: AppTextStyles.label,
        labelSmall: AppTextStyles.micro,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusStandard),
        ),
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.panel,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading2,
        iconTheme: IconThemeData(color: AppColors.textSecondary),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPrimary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderStandard),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderStandard),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderStandard),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColors.accentPrimary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.panel,
        selectedItemColor: AppColors.accentPrimary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: AppTextStyles.label,
        unselectedLabelStyle: AppTextStyles.label,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        ),
        elevation: 8,
        titleTextStyle: AppTextStyles.heading2,
        contentTextStyle: AppTextStyles.body,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceHighlight,
        labelStyle: AppTextStyles.label,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        ),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentPrimary;
          }
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentSubtle;
          }
          return AppColors.borderStandard;
        }),
      ),
      
      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.accentPrimary,
        inactiveTrackColor: AppColors.borderStandard,
        thumbColor: AppColors.accentPrimary,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.canvasLight,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentPrimary,
        onPrimary: AppColors.textPrimaryLight,
        secondary: AppColors.accentSecondary,
        onSecondary: AppColors.textPrimaryLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.error,
        onError: AppColors.textPrimaryLight,
      ),
      
      // Text Theme (light mode variants)
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayHero.copyWith(color: AppColors.textPrimaryLight),
        displayMedium: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryLight),
        displaySmall: AppTextStyles.display.copyWith(color: AppColors.textPrimaryLight),
        headlineLarge: AppTextStyles.heading1.copyWith(color: AppColors.textPrimaryLight),
        headlineMedium: AppTextStyles.heading2.copyWith(color: AppColors.textPrimaryLight),
        headlineSmall: AppTextStyles.heading3.copyWith(color: AppColors.textPrimaryLight),
        titleLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryLight),
        bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
        bodySmall: AppTextStyles.small.copyWith(color: AppColors.textPrimaryLight),
        labelLarge: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight),
        labelMedium: AppTextStyles.label.copyWith(color: AppColors.textPrimaryLight),
        labelSmall: AppTextStyles.micro.copyWith(color: AppColors.textPrimaryLight),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusStandard),
        ),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.panelLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.textPrimaryLight),
        iconTheme: const IconThemeData(color: AppColors.textSecondaryLight),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPrimary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryLight,
          side: const BorderSide(color: AppColors.borderLight),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          borderSide: const BorderSide(color: AppColors.accentPrimary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondaryLight),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondaryLight,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.panelLight,
        selectedItemColor: AppColors.accentPrimary,
        unselectedItemColor: AppColors.textSecondaryLight,
        selectedLabelStyle: AppTextStyles.label,
        unselectedLabelStyle: AppTextStyles.label,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        ),
        elevation: 8,
        titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.textPrimaryLight),
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLight,
        labelStyle: AppTextStyles.label,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        ),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentPrimary;
          }
          return AppColors.textSecondaryLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentSubtle;
          }
          return AppColors.borderLight;
        }),
      ),
      
      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.accentPrimary,
        inactiveTrackColor: AppColors.borderLight,
        thumbColor: AppColors.accentPrimary,
      ),
    );
  }
}