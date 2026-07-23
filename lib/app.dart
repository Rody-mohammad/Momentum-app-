import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_theme.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/providers/theme_provider.dart';
import 'package:momentum/screens/add_habit/add_habit_screen.dart';
import 'package:momentum/screens/edit_habit/edit_habit_screen.dart';
import 'package:momentum/screens/habit_detail/habit_detail_screen.dart';
import 'package:momentum/screens/home/home_screen.dart';
import 'package:momentum/screens/onboarding/onboarding_screen.dart';
import 'package:momentum/screens/settings/settings_screen.dart';
import 'package:momentum/screens/stats/stats_screen.dart';

class MomentumApp extends StatefulWidget {
  const MomentumApp({super.key, required this.initialLocation});
  final String initialLocation;

  @override
  State<MomentumApp> createState() => _MomentumAppState();
}

class _MomentumAppState extends State<MomentumApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: widget.initialLocation,
      routes: [
        // ── Onboarding (shown only once, full screen) ──────────────
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // ── Main shell with bottom nav ──────────────────────────────
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/stats',
                builder: (context, state) => const StatsScreen(),
              ),
            ],),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],),
          ],
        ),

        // ── Modal / full-screen routes (appear OVER nav bar) ───────
        GoRoute(
          path: '/add-habit',
          builder: (context, state) => const AddHabitScreen(),
        ),
        GoRoute(
          path: '/edit-habit',
          builder: (context, state) =>
              EditHabitScreen(habit: state.extra! as Habit),
        ),
        GoRoute(
          path: '/habit-detail',
          builder: (context, state) =>
              HabitDetailScreen(habit: state.extra! as Habit),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Momentum',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode:
          themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Bottom nav shell
// ────────────────────────────────────────────────────────────────────────────

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surface;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border(
            top: BorderSide(
                color: theme.brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: bg,
          elevation: 0,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation:
                index == navigationShell.currentIndex,
          ),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.circle_outlined),
              selectedIcon: Icon(Icons.circle_rounded),
              label: 'Habits',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}