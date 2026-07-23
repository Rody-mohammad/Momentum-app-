import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/theme/app_theme.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/providers/theme_provider.dart';
import 'package:momentum/screens/home/home_screen.dart';
import 'package:momentum/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('home and settings follow the selected app theme', (tester) async {
    final themeProvider = ThemeProvider();

    await _pumpThemedScreen(tester, themeProvider, const HomeScreen());
    expect(_screenBackground(tester), AppTheme.dark.scaffoldBackgroundColor);

    themeProvider.toggleTheme();
    await tester.pumpAndSettle();
    expect(_screenBackground(tester), AppTheme.light.scaffoldBackgroundColor);

    await _pumpThemedScreen(tester, themeProvider, const SettingsScreen());
    expect(_screenBackground(tester), AppTheme.light.scaffoldBackgroundColor);
    final footer = find.textContaining('Built by Rody');
    await tester.ensureVisible(footer);
    expect(footer, findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpThemedScreen(
  WidgetTester tester,
  ThemeProvider themeProvider,
  Widget screen,
) {
  return tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, _) => MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: screen,
        ),
      ),
    ),
  );
}

Color? _screenBackground(WidgetTester tester) {
  return tester.widget<Scaffold>(find.byType(Scaffold).first).backgroundColor;
}