class AppConstants {
  AppConstants._();

  static const appName            = 'Momentum';
  static const int freezeTokensPerMonth = 2;
  static const int orbMinSize     = 64;
  static const int orbMaxSize     = 110;

  // Streak milestone days
  static const List<int> streakMilestones = [3, 7, 14, 30, 60, 100];

  // Habit categories
  static const List<String> habitCategories = [
    'Health',
    'Mind',
    'Work',
    'Social',
    'Creative',
    'Finance',
    'Other',
  ];

  // Frequency options
  static const List<String> frequencyOptions = [
    'Daily',
    'Weekly',
    'Custom',
  ];
}