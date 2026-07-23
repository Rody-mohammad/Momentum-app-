import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/screens/add_habit/add_habit_screen.dart';
import 'package:momentum/screens/edit_habit/edit_habit_screen.dart';
import 'package:momentum/screens/home/home_screen.dart';
import 'package:momentum/screens/onboarding/onboarding_screen.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:provider/provider.dart';

void main() {
  const smallPhoneSize = Size(320, 568);

  Future<void> pumpSmallPhone(
    WidgetTester tester,
    Widget child,
  ) async {
    tester.view.physicalSize = smallPhoneSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(child);
    await tester.pumpAndSettle();
  }

  void expectNoLayoutExceptions(WidgetTester tester) {
    expect(tester.takeException(), isNull);
  }

  testWidgets('dashboard fits on a narrow phone', (tester) async {
    await pumpSmallPhone(
      tester,
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HabitProvider()),
          ChangeNotifierProvider(create: (_) => StatsProvider()),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expectNoLayoutExceptions(tester);
  });

  testWidgets('add habit weekly selector fits on a narrow phone',
      (tester) async {
    await pumpSmallPhone(tester, const MaterialApp(home: AddHabitScreen()));

    await tester.ensureVisible(find.text('Weekly'));
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();

    expectNoLayoutExceptions(tester);
  });

  testWidgets('edit habit weekly selector fits on a narrow phone',
      (tester) async {
    final habit = Habit(
      id: 'responsive-test-habit',
      name: 'Read',
      category: HabitCategory.mind,
      timeOfDay: HabitTimeOfDay.evening,
    );

    await pumpSmallPhone(
      tester,
      MaterialApp(home: EditHabitScreen(habit: habit)),
    );

    await tester.ensureVisible(find.text('Weekly'));
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();

    expectNoLayoutExceptions(tester);
  });

  testWidgets('long onboarding slides fit on a short phone', (tester) async {
    await pumpSmallPhone(
      tester,
      const MaterialApp(home: OnboardingScreen()),
    );

    await tester.drag(find.byType(PageView), const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(find.text('Grow Your Orbs'), findsOneWidget);
    expectNoLayoutExceptions(tester);

    await tester.drag(find.byType(PageView), const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(find.text('Freeze Tokens'), findsOneWidget);
    expectNoLayoutExceptions(tester);
  });
}