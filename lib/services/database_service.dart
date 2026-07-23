import 'package:hive/hive.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/models/score_log.dart'; // 1. تأكد من إضافة هذا الاستيراد هنا

class DatabaseService {
  static late Box<Habit> _habitsBox;
  static late Box<HabitLog> _logsBox;
  static late Box<dynamic> _settingsBox;
  static late Box<ScoreLog> _scoreBox; // 2. تم إضافة المتغير هنا

  // Initialize the boxes
  static Future<void> init() async {
    _habitsBox = await Hive.openBox<Habit>('habits');
    _logsBox = await Hive.openBox<HabitLog>('logs');
    _settingsBox = await Hive.openBox<dynamic>('settings');
    _scoreBox = await Hive.openBox<ScoreLog>('score_logs'); // 3. تم فتح الـ Box هنا
  }

  // --- HABITS ---
  static List<Habit> getAllHabits() {
    // Only return habits that are NOT archived (Soft Delete)
    return _habitsBox.values.where((habit) => !habit.isArchived).toList();
  }

  static Future<void> addHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
  }

  static Future<void> archiveHabit(String id) async {
    final habit = _habitsBox.get(id);
    if (habit != null) {
      habit.isArchived = true;
      // FIX: Manually put the updated object back into the Hive box
      await _habitsBox.put(id, habit);
    }
  }

  static Future<void> updateHabit(Habit updatedHabit) async {
    await _habitsBox.put(updatedHabit.id, updatedHabit);
  }

  // --- LOGS ---
  static List<HabitLog> getLogsForHabit(String habitId) {
    return _logsBox.values.where((log) => log.habitId == habitId).toList();
  }

  static Future<void> addLog(HabitLog log) async {
    await _logsBox.put(log.id, log);
  }

  static Future<void> deleteLog(String id) async {
    await _logsBox.delete(id);
  }

  // --- SETTINGS (Score & Tokens) ---
  static T? getSetting<T>(String key) {
    return _settingsBox.get(key) as T?;
  }

  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  // --- SCORE LOGS --- (4. تم إضافة الدوال الجديدة في الأسفل هنا)
  static List<ScoreLog> getScoreLogs() {
    return _scoreBox.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  static Future<void> saveScoreLog(ScoreLog log) async {
    await _scoreBox.put(log.date, log); // Use date as key to overwrite today's score
  }
}