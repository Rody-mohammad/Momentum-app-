/// Represents a milestone badge earned by completing a habit
/// for a certain number of consecutive days.
class BadgeModel {

  const BadgeModel({
    required this.milestone,
    required this.title,
    required this.emoji,
    required this.description,
  });
  final int milestone; // 3, 7, 14, 30, 60, 100
  final String title;
  final String emoji;
  final String description;

  /// All possible milestone badges in the app.
  static const List<BadgeModel> all = [
    BadgeModel(
      milestone: 3,
      title: 'Ignition',
      emoji: '🔥',
      description: '3 days in a row. The spark is lit.',
    ),
    BadgeModel(
      milestone: 7,
      title: 'One Week',
      emoji: '⚡',
      description: "A full week! You're building real momentum.",
    ),
    BadgeModel(
      milestone: 14,
      title: 'Two Weeks',
      emoji: '🌊',
      description: 'Two weeks strong. This is becoming a habit.',
    ),
    BadgeModel(
      milestone: 30,
      title: 'One Month',
      emoji: '🏆',
      description: 'A whole month! You are unstoppable.',
    ),
    BadgeModel(
      milestone: 60,
      title: 'Double Down',
      emoji: '💎',
      description: 'Two months. Rare level of commitment.',
    ),
    BadgeModel(
      milestone: 100,
      title: 'Centurion',
      emoji: '🚀',
      description: '100 days. You have mastered this habit.',
    ),
  ];

  /// Returns the next milestone above [currentStreak], or null if
  /// the streak has already passed all milestones.
  static BadgeModel? nextMilestone(int currentStreak) {
    try {
      return all.firstWhere((b) => b.milestone > currentStreak);
    } catch (_) {
      return null; // All milestones passed
    }
  }

  /// Returns all badges that have been earned for a given [streak].
  static List<BadgeModel> earnedBadges(int streak) {
    return all.where((b) => streak >= b.milestone).toList();
  }

  /// Returns the badge for exactly [milestone] days, or null.
  static BadgeModel? forMilestone(int milestone) {
    try {
      return all.firstWhere((b) => b.milestone == milestone);
    } catch (_) {
      return null;
    }
  }
}
