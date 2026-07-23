import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:momentum/screens/onboarding/onboarding_screen.dart';
import 'package:momentum/services/database_service.dart';

import 'test_database.dart';

void main() {
  setUpAll(initializeTestDatabase);
  setUp(resetTestDatabase);

  testWidgets('skip persists onboarding and navigates home', (tester) async {
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('Home')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(DatabaseService.getSetting<bool>('isOnboarded'), isTrue);
    expect(find.text('Home'), findsOneWidget);
  });
}