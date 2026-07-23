import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/services/database_service.dart';

import 'test_database.dart';

void main() {
  setUpAll(initializeTestDatabase);
  setUp(resetTestDatabase);

  group('HabitProvider', () {
    test('persists added habits and reloads them', () async {
      final provider = HabitProvider();

      await provider.addHabit(
        name: 'Read',
        category: HabitCategory.mind,
        timeOfDay: HabitTimeOfDay.evening,
      );

      expect(provider.habits, hasLength(1));
      expect(provider.habits.single.name, 'Read');

      final reloadedProvider = HabitProvider();
      await reloadedProvider.loadHabits();
      expect(reloadedProvider.habits.single.name, 'Read');
    });

    test('updates, completes, uncompletes, and archives a habit', () async {
      final provider = HabitProvider();
      await provider.addHabit(
        name: 'Walk',
        category: HabitCategory.health,
        timeOfDay: HabitTimeOfDay.morning,
      );
      final habitId = provider.habits.single.id;

      await provider.updateHabit(
        id: habitId,
        name: 'Morning walk',
        category: HabitCategory.health,
        timeOfDay: HabitTimeOfDay.afternoon,
      );
      expect(provider.habits.single.name, 'Morning walk');
      expect(provider.habits.single.timeOfDay, HabitTimeOfDay.afternoon);

      final completed = await provider.toggleHabitCompletion(
        habitId,
        DateTime.now(),
      );
      expect(completed.becameCompleted, isTrue);
      expect(DatabaseService.getLogsForHabit(habitId), hasLength(1));

      final undone = await provider.toggleHabitCompletion(habitId, DateTime.now());
      expect(undone.becameCompleted, isFalse);
      expect(DatabaseService.getLogsForHabit(habitId), isEmpty);

      await provider.archiveHabit(habitId);
      expect(provider.habits, isEmpty);
    });
  });
}