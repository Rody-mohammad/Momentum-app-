import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:momentum/app.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/models/habit_log.dart';
import 'package:momentum/providers/habit_provider.dart';
import 'package:momentum/providers/stats_provider.dart';
import 'package:momentum/providers/theme_provider.dart';
import 'package:momentum/services/database_service.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/score_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 2. CRITICAL: Register Hive Adapters BEFORE initializing Hive
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ScoreLogAdapter());
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(HabitAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HabitLogAdapter());
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(HabitCategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(HabitTimeOfDayAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(FrequencyTypeAdapter());
  }
  await Hive.initFlutter();
  await DatabaseService.init();

  final habitProvider = HabitProvider();
  await habitProvider.loadHabits();

  final statsProvider = StatsProvider();
  await statsProvider.loadSettings(habitProvider);

  // CRITICAL: Check if first time launching to show Onboarding
  final isOnboarded = DatabaseService.getSetting<bool>('isOnboarded') ?? false;
  final initialLocation = isOnboarded ? '/' : '/onboarding';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: habitProvider),
        ChangeNotifierProvider.value(value: statsProvider),
      ],
      child: MomentumApp(initialLocation: initialLocation),
    ),
  );
}
