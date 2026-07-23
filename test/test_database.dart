import 'dart:io';

import 'package:hive/hive.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/models/score_log.dart';
import 'package:momentum/services/database_service.dart';

Future<void> initializeTestDatabase() async {
  if (!Hive.isBoxOpen('habits')) {
    final directory = await Directory.systemTemp.createTemp('momentum_test_');
    Hive.init(directory.path);
  }

  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(HabitAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HabitLogAdapter());
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(HabitCategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(HabitTimeOfDayAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ScoreLogAdapter());
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(FrequencyTypeAdapter());
  }

  await DatabaseService.init();
}

Future<void> resetTestDatabase() async {
  await Future.wait([
    Hive.box<Habit>('habits').clear(),
    Hive.box<HabitLog>('logs').clear(),
    Hive.box<dynamic>('settings').clear(),
    Hive.box<ScoreLog>('score_logs').clear(),
  ]);
}