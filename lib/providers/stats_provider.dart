import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/models/score_log.dart'; // 1. تم إضافة استيراد الموديل الجديد هنا
import 'package:momentum/services/database_service.dart';
import 'package:momentum/providers/habit_provider.dart';

class StatsProvider extends ChangeNotifier {
  int _momentumScore = 0;
  int _freezeTokens = 3; // Start with 3 free tokens
  String _lastTokenGrantDate = '';
  String _lastScoreUpdateDate = '';

  int get momentumScore => _momentumScore;
  int get freezeTokens => _freezeTokens;

  Future<void> loadSettings(HabitProvider habitProvider) async {
    _momentumScore = DatabaseService.getSetting<int>('momentumScore') ?? 0;
    _freezeTokens = DatabaseService.getSetting<int>('freezeTokens') ?? 3;
    _lastTokenGrantDate = DatabaseService.getSetting<String>('lastTokenGrantDate') ?? '';
    _lastScoreUpdateDate = DatabaseService.getSetting<String>('lastScoreUpdateDate') ?? '';

    await _checkMonthlyTokenGrant();
    await _checkMidnightPenalty(habitProvider);
    
    notifyListeners();
  }

  // 2. تم استبدال الدالة القديمة بالدالة الجديدة التي تسجل السكور اليومي
  Future<void> addScore(int points) async {
    _momentumScore += points;
    if (_momentumScore < 0) _momentumScore = 0;
    await DatabaseService.setSetting('momentumScore', _momentumScore);
    
    // Record today's score for the line chart
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final log = ScoreLog(
      id: const Uuid().v4(),
      date: todayStr,
      score: _momentumScore,
    );
    await DatabaseService.saveScoreLog(log);
    
    notifyListeners();
  }

  /// Resets momentum score to 0 (used from Settings screen).
  Future<void> resetScore() async {
    _momentumScore = 0;
    await DatabaseService.setSetting('momentumScore', _momentumScore);
    notifyListeners();
  }

  // Grant 3 tokens on the 1st of every month
  Future<void> _checkMonthlyTokenGrant() async {
    final now = DateTime.now();
    final currentMonthStr = '${now.year}-${now.month}';

    if (_lastTokenGrantDate != currentMonthStr) {
      _freezeTokens += 3;
      _lastTokenGrantDate = currentMonthStr;
      await DatabaseService.setSetting('freezeTokens', _freezeTokens);
      await DatabaseService.setSetting(
        'lastTokenGrantDate',
        _lastTokenGrantDate,
      );
    }
  }

  // If the app was closed at midnight, this catches missed habits automatically
  Future<void> _checkMidnightPenalty(HabitProvider habitProvider) async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final todayStr = DateFormat('yyyy-MM-dd').format(today);
    final yesterdayStr = DateFormat('yyyy-MM-dd').format(yesterday);

    // If last update was BEFORE today, a day has rolled over!
    if (_lastScoreUpdateDate != todayStr && _lastScoreUpdateDate.isNotEmpty) {
      var missedHabitsCount = 0;

      for (final habit in habitProvider.habits) {
        final logs = DatabaseService.getLogsForHabit(habit.id);
        final hasYesterdayLog = logs.any((log) => log.date == yesterdayStr);

        if (!hasYesterdayLog) {
          // They missed this habit yesterday!
          if (_freezeTokens > 0) {
            // AUTO-APPLY FREEZE TOKEN
            await DatabaseService.addLog(
              HabitLog(
                id: const Uuid().v4(),
                habitId: habit.id,
                date: yesterdayStr,
                isCompleted: false,
                usedFreezeToken: true,
              ),
            );
            _freezeTokens--;
            await DatabaseService.setSetting('freezeTokens', _freezeTokens);
          } else {
            // No tokens left. Take the -5 penalty.
            missedHabitsCount++;
          }
        }
      }

      // Apply 2% Daily Decay
      final decay = (_momentumScore * 0.02).ceil();
      _momentumScore -= decay;
      
      // Apply -5 penalty for every unprotected missed habit
      _momentumScore -= missedHabitsCount * 5;
      
      if (_momentumScore < 0) _momentumScore = 0;

      // Update the date so we don't run this again today
      _lastScoreUpdateDate = todayStr;
      await DatabaseService.setSetting('momentumScore', _momentumScore);
      await DatabaseService.setSetting(
        'lastScoreUpdateDate',
        _lastScoreUpdateDate,
      );
    } else if (_lastScoreUpdateDate.isEmpty) {
      // First time ever opening the app
      _lastScoreUpdateDate = todayStr;
      await DatabaseService.setSetting(
        'lastScoreUpdateDate',
        _lastScoreUpdateDate,
      );
    }
  }
}