import 'package:flutter/material.dart';

class AppColors {
  // Background Surfaces (Linear-inspired dark-mode-native)
  static const Color canvas = Color(0xFF08090A);
  static const Color panel = Color(0xFF0F1011);
  static const Color surface = Color(0xFF191A1B);
  static const Color surfaceHighlight = Color(0xFF28282C);

  // Light Mode Backgrounds
  static const Color canvasLight = Color(0xFFFFFFFF);
  static const Color panelLight = Color(0xFFF5F5F7);
  static const Color surfaceLight = Color(0xFFE5E5E7);

  // Text Colors
  static const Color textPrimary = Color(0xFFF7F8F8);
  static const Color textSecondary = Color(0xFFD0D6E0);
  static const Color textTertiary = Color(0xFF8A8F98);
  static const Color textQuaternary = Color(0xFF62666D);

  // Light Mode Text
  static const Color textPrimaryLight = Color(0xFF1D1D1F);
  static const Color textSecondaryLight = Color(0xFF6E6E73);

  // Brand & Accent (Momentum Purple)
  static const Color accentPrimary = Color(0xFF7C3AED);
  static const Color accentSecondary = Color(0xFF8B5CF6);
  static const Color accentHover = Color(0xFFA78BFA);
  static const Color accentSubtle = Color(0x267C3AED); // 15% opacity

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successSubtle = Color(0x2610B981); // 15% opacity
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSubtle = Color(0x26F59E0B); // 15% opacity
  static const Color error = Color(0xFFEF4444);
  static const Color errorSubtle = Color(0x26EF4444); // 15% opacity

  // Border & Divider
  static const Color borderSubtle = Color(0x0DFFFFFF); // 5% opacity
  static const Color borderStandard = Color(0x14FFFFFF); // 8% opacity
  static const Color borderStrong = Color(0x1EFFFFFF); // 12% opacity
  static const Color divider = Color(0xFF141516);

  // Light Mode Borders
  static const Color borderLight = Color(0xFFD2D2D7);

  // Overlay
  static const Color overlay = Color(0xD9000000); // 85% opacity

  // Legacy semantic aliases retained while screen styling is consolidated.
  static const Color primaryAccent = accentPrimary;
  static const Color darkBackground = canvas;
  static const Color lightBackground = canvasLight;
  static const Color darkSurface = surface;
  static const Color lightSurface = surfaceLight;
  static const Color darkTextPrimary = textPrimary;
  static const Color lightTextPrimary = textPrimaryLight;
  static const Color darkTextSecondary = textSecondary;
  static const Color lightTextSecondary = textSecondaryLight;
  static const Color danger = error;

  // The 5 Fixed Habit Categories (preserved for logic compatibility)
  static const Color healthColor = Color(0xFF00D68F);   // Green/Teal
  static const Color mindColor = Color(0xFF6C63FF);     // Purple/Indigo
  static const Color socialColor = Color(0xFFFFAD33);   // Orange/Peach
  static const Color workColor = Color(0xFF339AF0);     // Blue/Cyan
  static const Color creativeColor = Color(0xFFFF6B9D); // Pink/Magenta

  // Helper to get category color by index
  static Color getCategoryColor(int index) {
    switch (index % 5) {
      case 0:
        return healthColor;
      case 1:
        return mindColor;
      case 2:
        return socialColor;
      case 3:
        return workColor;
      case 4:
        return creativeColor;
      default:
        return accentPrimary;
    }
  }
}