import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/services/database_service.dart';

import 'test_database.dart';

void main() {
  setUpAll(initializeTestDatabase);
  setUp(resetTestDatabase);

  test('protects a missed habit with a freeze token after a day rollover',
      () async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final habit = Habit(
      id: 'daily-habit',
      name: 'Meditate',
      category: HabitCategory.mind,
      timeOfDay: HabitTimeOfDay.morning,
    );
    await DatabaseService.addHabit(habit);
    await DatabaseService.setSetting('freezeTokens', 1);
    await DatabaseService.setSetting('momentumScore', 100);
    await DatabaseService.setSetting(
      'lastTokenGrantDate',
      '${today.year}-${today.month}',
    );
    await DatabaseService.setSetting(
      'lastScoreUpdateDate',
      DateFormat('yyyy-MM-dd').format(yesterday),
    );

    final habitProvider = HabitProvider();
    await habitProvider.loadHabits();
    final statsProvider = StatsProvider();
    await statsProvider.loadSettings(habitProvider);

    final logs = DatabaseService.getLogsForHabit(habit.id);
    expect(logs, hasLength(1));
    expect(logs.single.usedFreezeToken, isTrue);
    expect(logs.single.isCompleted, isFalse);
    expect(statsProvider.freezeTokens, 0);
    expect(statsProvider.momentumScore, 98);
  });
}