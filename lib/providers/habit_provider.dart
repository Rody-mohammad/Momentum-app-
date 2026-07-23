import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:momentum/models/badge_model.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/services/database_service.dart';
import 'package:momentum/services/streak_service.dart';
import 'package:momentum/core/utils/streak_calculator.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  final _uuid = const Uuid();

  Future<void> loadHabits() async {
    _habits = DatabaseService.getAllHabits();
    notifyListeners();
  }

  List<Habit> getTodayHabits() {
    final today = DateTime.now();
    return _habits.where((h) => h.isScheduledOn(today)).toList();
  }

  Future<void> addHabit({
    required String name,
    required HabitCategory category,
    required HabitTimeOfDay timeOfDay,
    FrequencyType frequencyType = FrequencyType.daily,
    List<int> weeklyDays = const [],
    int intervalDays = 1,
    DateTime? startDate,
  }) async {
    final newHabit = Habit(
      id: _uuid.v4(),
      name: name,
      category: category,
      timeOfDay: timeOfDay,
      frequencyType: frequencyType,
      weeklyDays: weeklyDays,
      intervalDays: intervalDays,
      startDate: startDate,
    );
    await DatabaseService.addHabit(newHabit);
    await loadHabits();
  }

  /// Toggles completion for [habitId] on [date].
  ///
  /// Returns a [ToggleResult] containing:
  /// - `becameCompleted`: whether the habit is now done (vs. undone)
  /// - `newBadge`: a [BadgeModel] if a milestone was crossed, else null
  Future<ToggleResult> toggleHabitCompletion(
    String habitId,
    DateTime date,
  ) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    if (!habit.isScheduledOn(date)) {
      return const ToggleResult(becameCompleted: false, newBadge: null);
    }

    final dateStr = _formatDate(date);
    final logs = DatabaseService.getLogsForHabit(habitId);
    final existingLog =
        logs.where((log) => log.date == dateStr).firstOrNull;

    if (existingLog != null) {
      // UNDO: Log exists, delete it
      await DatabaseService.deleteLog(existingLog.id);
      notifyListeners();
      return const ToggleResult(becameCompleted: false, newBadge: null);
    } else {
      // Get the streak BEFORE adding the new log
      final oldStreak = StreakCalculator.calculateCurrentStreak(habit, logs);

      // COMPLETE: Create new log
      final newLog = HabitLog(
        id: _uuid.v4(),
        habitId: habitId,
        date: dateStr,
        isCompleted: true,
      );
      await DatabaseService.addLog(newLog);

      // Calculate the NEW streak (including the log we just added)
      final updatedLogs = DatabaseService.getLogsForHabit(habitId);
      final newStreak =
          StreakCalculator.calculateCurrentStreak(habit, updatedLogs);

      // Check if a milestone badge was just crossed
      final newBadge = StreakService.checkForNewBadge(
        habitId: habitId,
        oldStreak: oldStreak,
        newStreak: newStreak,
      );

      notifyListeners();
      return ToggleResult(becameCompleted: true, newBadge: newBadge);
    }
  }

  Future<void> archiveHabit(String habitId) async {
    StreakService.clearBadgesForHabit(habitId);
    await DatabaseService.archiveHabit(habitId);
    await loadHabits();
  }

  Future<void> updateHabit({
    required String id,
    required String name,
    required HabitCategory category,
    required HabitTimeOfDay timeOfDay,
    FrequencyType frequencyType = FrequencyType.daily,
    List<int> weeklyDays = const [],
    int intervalDays = 1,
    DateTime? startDate,
  }) async {
    final habitIndex = _habits.indexWhere((h) => h.id == id);

    if (habitIndex != -1) {
      final updatedHabit = Habit(
        id: id,
        name: name,
        category: category,
        timeOfDay: timeOfDay,
        isArchived: _habits[habitIndex].isArchived,
        frequencyType: frequencyType,
        weeklyDays: weeklyDays,
        intervalDays: intervalDays,
        startDate: startDate,
      );
      await DatabaseService.addHabit(updatedHabit);
      await loadHabits();
    }
  }

  List<HabitLog> getLogsForHabit(String habitId) {
    return DatabaseService.getLogsForHabit(habitId);
  }

  int getStreakForHabit(String habitId) {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    final logs = DatabaseService.getLogsForHabit(habitId);
    return StreakCalculator.calculateCurrentStreak(habit, logs);
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}'
      '-${date.day.toString().padLeft(2, '0')}';
}

/// Result returned from [HabitProvider.toggleHabitCompletion].
class ToggleResult {

  const ToggleResult({
    required this.becameCompleted,
    required this.newBadge,
  });
  final bool becameCompleted;
  final BadgeModel? newBadge;
}
