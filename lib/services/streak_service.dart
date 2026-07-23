import 'package:momentum/models/badge_model.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/services/database_service.dart';

/// Service that checks whether a new milestone badge has been earned
/// and persists that information via [DatabaseService].
class StreakService {
  StreakService._(); // Prevent instantiation

  static const String _badgeKeyPrefix = 'badge_earned_';

  /// Checks if [newStreak] crosses a new milestone for [habitId].
  ///
  /// Returns the [BadgeModel] that was just earned, or `null` if no
  /// new milestone was crossed.
  static BadgeModel? checkForNewBadge({
    required String habitId,
    required int oldStreak,
    required int newStreak,
  }) {
    // Walk through all milestones and see if we just crossed one
    for (final badge in BadgeModel.all) {
      final crossedNow =
          newStreak >= badge.milestone && oldStreak < badge.milestone;
      if (crossedNow) {
        _markBadgeEarned(habitId, badge.milestone);
        return badge;
      }
    }
    return null;
  }

  /// Returns whether a badge for [milestone] was previously earned
  /// for [habitId] (so we don't show confetti twice).
  static bool isBadgeEarned(String habitId, int milestone) {
    final key = '$_badgeKeyPrefix${habitId}_$milestone';
    return DatabaseService.getSetting<bool>(key) ?? false;
  }

  /// Persists that the [milestone] badge was earned for [habitId].
  static void _markBadgeEarned(String habitId, int milestone) {
    final key = '$_badgeKeyPrefix${habitId}_$milestone';
    DatabaseService.setSetting(key, true);
  }

  /// Clears all earned-badge flags for [habitId] (used when archiving).
  static void clearBadgesForHabit(String habitId) {
    for (final badge in BadgeModel.all) {
      final key = '$_badgeKeyPrefix${habitId}_${badge.milestone}';
      DatabaseService.setSetting(key, false);
    }
  }

  /// Calculates the total number of unique days a habit was completed,
  /// regardless of streaks (used as "total completions" stat).
  static int totalCompletions(List<HabitLog> logs) {
    return logs.where((l) => l.isCompleted).length;
  }
}
