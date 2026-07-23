import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/core/utils/streak_calculator.dart';

void main() {
  final habit = Habit(
    id: 'test-habit',
    name: 'Test Habit',
    category: HabitCategory.health,
    timeOfDay: HabitTimeOfDay.morning,
  );

  group('StreakCalculator', () {
    test('returns 0 if there are no logs', () {
      final streak = StreakCalculator.calculateCurrentStreak(habit, []);
      expect(streak, 0);
    });

    test('returns correct streak for consecutive days', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final dayBefore = now.subtract(const Duration(days: 2));
      
      final dynamicLogs = [
        _createLog(now), 
        _createLog(yesterday), 
        _createLog(dayBefore),
      ];

      final streak = StreakCalculator.calculateCurrentStreak(habit, dynamicLogs);
      expect(streak, 3);
    });

    test('ignores a missed day if a freeze token was used', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final dayBefore = now.subtract(const Duration(days: 2));
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final logs = [
        _createLog(now), // Today: Done (+1)
        // Yesterday: MISSED, but Freeze Token used! (Bridges the gap)
        HabitLog(id: 'f1', habitId: 'h1', date: _formatDate(yesterday), isCompleted: false, usedFreezeToken: true),
        _createLog(dayBefore), // 2 days ago: Done (+1)
        _createLog(threeDaysAgo), // 3 days ago: Done (+1)
      ];

      final streak = StreakCalculator.calculateCurrentStreak(habit,logs);
      expect(streak, 3); // 3 actual completions, streak kept alive by token
    });

    test('breaks streak if missed day has no freeze token', () {
      final now = DateTime.now();
      final dayBefore = now.subtract(const Duration(days: 2));

      final logs = [
        _createLog(now), // Today: Done
        // Yesterday: MISSED, NO Freeze Token
        _createLog(dayBefore), // 2 days ago: Done
      ];

      final streak = StreakCalculator.calculateCurrentStreak(habit,logs);
      expect(streak, 1); // Streak resets to just today
    });
    
    test('returns 0 if last completion was 2 days ago', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      final logs = [_createLog(twoDaysAgo)];
      
      final streak = StreakCalculator.calculateCurrentStreak(habit,logs);
      expect(streak, 0);
    });
  });
}

// --- Helper Functions ---
String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

HabitLog _createLog(DateTime date) {
  return HabitLog(
    id: 'test_${date.day}',
    habitId: 'h1',
    date: _formatDate(date),
    isCompleted: true,
  );
}