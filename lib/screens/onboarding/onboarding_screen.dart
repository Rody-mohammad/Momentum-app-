import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/services/database_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _finishOnboarding() async {
    final router = GoRouter.of(context);
    // Save flag so this never shows again
    final saveOnboardingState =
        DatabaseService.setSetting('isOnboarded', true);
    // Navigate to home and remove onboarding from stack
    router.go('/');
    await saveOnboardingState;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.canvas : AppColors.canvasLight;
    final dotUnselected = isDark ? AppColors.surface : Colors.black.withValues(alpha: 0.1);
    final textPrimary =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildPage(
                    icon: Icons.rocket_launch_rounded,
                    title: 'Welcome to Momentum',
                    description:
                        'Small daily actions compound into life-changing results. Track your habits visually.',
                    color: AppColors.accentPrimary,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  _buildPage(
                    icon: Icons.circle_rounded,
                    title: 'Grow Your Orbs',
                    description:
                        'Every habit is a glowing orb. Complete it to watch it glow and your streak increase. Miss a day, and it dims.',
                    color: AppColors.success,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  _buildPage(
                    icon: Icons.shield_outlined,
                    title: 'Freeze Tokens',
                    description:
                        'Life happens. You get 3 Freeze Tokens monthly to automatically protect your streak if you miss a day.',
                    color: AppColors.socialColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ],
              ),
            ),
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Skip button
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _finishOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(color: textSecondary),
                        ),
                      ),
                    ),
                  ),
                  // Dots Indicator
                  SizedBox(
                    width: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 8,
                          width: _currentPage == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primaryAccent
                                : dotUnselected,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Next/Start Button
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _currentPage == 2
                            ? _finishOnboarding
                            : () => _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(_currentPage == 2 ? 'Start Now' : 'Next'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(icon, size: 80, color: color),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: textSecondary,
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}