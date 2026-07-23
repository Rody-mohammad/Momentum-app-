import 'package:intl/intl.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/models/habit_log.dart';

class StreakCalculator {
  /// Calculates the current streak by walking backwards day-by-day.
  static int calculateCurrentStreak(Habit habit, List<HabitLog> logs) {
    if (logs.isEmpty) return 0;

    final now = DateTime.now();
    
    // Start walking backwards from today or yesterday
    var checkDate = now;
    
    // If today is scheduled and not completed/frozen yet, we don't count it as broken.
    // We only start from today if it is completed or frozen today. Otherwise, we start from yesterday.
    final todayStr = DateFormat('yyyy-MM-dd').format(checkDate);
    final todayCompleted = logs.any((l) => l.date == todayStr && l.isCompleted);
    final todayFrozen = logs.any((l) => l.date == todayStr && l.usedFreezeToken);
    
    if (habit.isScheduledOn(checkDate)) {
      if (!todayCompleted && !todayFrozen) {
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    } else {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    var streak = 0;
    var daysChecked = 0;
    
    while (daysChecked < 3650) { // Limit to 10 years to prevent infinite loop
      final checkDateStr = DateFormat('yyyy-MM-dd').format(checkDate);
      if (habit.isScheduledOn(checkDate)) {
        final isCompleted = logs.any((l) => l.date == checkDateStr && l.isCompleted);
        if (isCompleted) {
          streak++;
        } else {
          final usedFreezeToken = logs.any((l) => l.date == checkDateStr && l.usedFreezeToken);
          if (!usedFreezeToken) {
            // Missed scheduled day. Streak breaks!
            break;
          }
        }
      }
      // Non-scheduled days are ignored, they don't break the streak and don't count.
      checkDate = checkDate.subtract(const Duration(days: 1));
      daysChecked++;
    }

    return streak;
  }

  /// Calculates the longest streak chronologically.
  static int calculateLongestStreak(Habit habit, List<HabitLog> logs) {
    if (logs.isEmpty) return 0;
    
    final sortedLogs = List<HabitLog>.from(logs)
      ..sort((a, b) => a.date.compareTo(b.date));
      
    if (sortedLogs.isEmpty) return 0;
    
    final formatter = DateFormat('yyyy-MM-dd');
    final firstLogDate = formatter.parse(sortedLogs.first.date);
    final startDate = habit.startDate.isBefore(firstLogDate) ? habit.startDate : firstLogDate;
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    var longest = 0;
    var current = 0;
    
    var checkDate = start;
    while (!checkDate.isAfter(today)) {
      final checkDateStr = formatter.format(checkDate);
      
      if (habit.isScheduledOn(checkDate)) {
        final isCompleted = logs.any((l) => l.date == checkDateStr && l.isCompleted);
        if (isCompleted) {
          current++;
          if (current > longest) {
            longest = current;
          }
        } else {
          final usedFreezeToken = logs.any((l) => l.date == checkDateStr && l.usedFreezeToken);
          if (!usedFreezeToken) {
            final isToday = checkDate.year == today.year &&
                            checkDate.month == today.month &&
                            checkDate.day == today.day;
            if (!isToday) {
              current = 0;
            }
          }
        }
      }
      checkDate = checkDate.add(const Duration(days: 1));
    }
    
    return longest;
  }
}