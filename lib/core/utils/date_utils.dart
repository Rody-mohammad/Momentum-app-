import 'package:intl/intl.dart';

/// Utility class for date operations used throughout the app.
class AppDateUtils {
  AppDateUtils._(); // Prevent instantiation

  static final _fmt = DateFormat('yyyy-MM-dd');

  /// Formats a [DateTime] to a storage-safe string: "2025-07-12".
  static String toDateStr(DateTime date) => _fmt.format(date);

  /// Parses a storage string back to a [DateTime].
  static DateTime fromDateStr(String dateStr) => _fmt.parse(dateStr);

  /// Returns today's date as a formatted string.
  static String todayStr() => _fmt.format(DateTime.now());

  /// Returns yesterday's date as a formatted string.
  static String yesterdayStr() =>
      _fmt.format(DateTime.now().subtract(const Duration(days: 1)));

  /// Returns the last [n] days as a list of formatted date strings,
  /// ordered from oldest (index 0) to newest (last index = today).
  static List<String> lastNDays(int n) {
    final now = DateTime.now();
    return List.generate(n, (i) {
      final date = now.subtract(Duration(days: n - 1 - i));
      return _fmt.format(date);
    });
  }

  /// Returns the number of calendar days between [from] and [to].
  static int daysBetween(DateTime from, DateTime to) {
    final a = DateTime(from.year, from.month, from.day);
    final b = DateTime(to.year, to.month, to.day);
    return b.difference(a).inDays.abs();
  }

  /// Returns a human-friendly greeting based on current hour.
  /// e.g. "Good Morning", "Good Afternoon", "Good Evening"
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// Returns a short day label for charts: "Mon", "Tue", etc.
  static String shortDayLabel(String dateStr) {
    final date = fromDateStr(dateStr);
    return DateFormat('EEE').format(date);
  }
}
