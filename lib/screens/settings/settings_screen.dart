import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.scaffoldBackgroundColor;
    final surface = theme.cardColor;
    final textPrimary = theme.colorScheme.onSurface;
    final textSecondary = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: bg,
            floating: true,
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Appearance ──────────────────────────────────
                  _SectionLabel(label: 'Appearance', color: textSecondary),
                  _SettingsCard(
                    surface: surface,
                    children: [
                      _ThemeToggleTile(
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Streak Protection ───────────────────────────
                  _SectionLabel(
                    label: 'Streak Protection',
                    color: textSecondary,
                  ),
                  _SettingsCard(
                    surface: surface,
                    children: [
                      _FreezeTokenTile(
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Momentum Score ──────────────────────────────
                  _SectionLabel(
                    label: 'Momentum Score',
                    color: textSecondary,
                  ),
                  _SettingsCard(
                    surface: surface,
                    children: [
                      _ResetScoreTile(
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── About ───────────────────────────────────────
                  _SectionLabel(label: 'About', color: textSecondary),
                  _SettingsCard(
                    surface: surface,
                    children: [
                      _AboutTile(
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ── App tagline ─────────────────────────────────
                  Center(
                    child: Text(
                      'Momentum v1.0.0\nBuilt by Rody',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textSecondary.withValues(alpha: 0.5),
                        fontSize: 12,
                        height: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Local sub-widgets
// ────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.surface, required this.children});
  final Color surface;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }
}

// ── Theme Toggle ─────────────────────────────────────────────────────────────

class _ThemeToggleTile extends StatelessWidget {
  const _ThemeToggleTile({
    required this.textPrimary,
    required this.textSecondary,
  });
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.accentPrimary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          themeProvider.isDarkMode
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
          color: AppColors.accentPrimary,
          size: 20,
        ),
      ),
      title: Text(
        'Dark Mode',
        style: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        themeProvider.isDarkMode ? 'Currently dark' : 'Currently light',
        style: TextStyle(color: textSecondary, fontSize: 12),
      ),
      trailing: Switch(
        value: themeProvider.isDarkMode,
        onChanged: (_) => themeProvider.toggleTheme(),
        activeColor: AppColors.accentPrimary,
      ),
    );
  }
}

// ── Freeze Tokens ─────────────────────────────────────────────────────────────

class _FreezeTokenTile extends StatelessWidget {
  const _FreezeTokenTile({
    required this.textPrimary,
    required this.textSecondary,
  });
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<StatsProvider>().freezeTokens;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.socialColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.shield_rounded,
          color: AppColors.socialColor,
          size: 20,
        ),
      ),
      title: Text(
        'Freeze Tokens',
        style: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'Auto-protect streaks when you miss a day.',
        style: TextStyle(color: textSecondary, fontSize: 12),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.socialColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.socialColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          '$tokens left',
          style: const TextStyle(
            color: AppColors.socialColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ── Reset Score ───────────────────────────────────────────────────────────────

class _ResetScoreTile extends StatelessWidget {
  const _ResetScoreTile({
    required this.textPrimary,
    required this.textSecondary,
  });
  final Color textPrimary;
  final Color textSecondary;

  void _showConfirmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Reset Momentum Score?',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'This will set your score back to 0. '
          'Your habits and streaks will not be affected.',
          style: TextStyle(color: textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<StatsProvider>().resetScore();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Momentum Score has been reset.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.refresh_rounded,
          color: AppColors.error,
          size: 20,
        ),
      ),
      title: Text(
        'Reset Score',
        style: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'Set your momentum score back to zero.',
        style: TextStyle(color: textSecondary, fontSize: 12),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textSecondary.withValues(alpha: 0.4),
      ),
      onTap: () => _showConfirmDialog(context),
    );
  }
}

// ── About ─────────────────────────────────────────────────────────────────────

class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.textPrimary,
    required this.textSecondary,
  });
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentPrimary,
                      AppColors.creativeColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Momentum',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Small daily actions compound into life-changing results. '
            'Momentum is your habit operating system — track, grow, and '
            'protect your streaks every day.',
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
