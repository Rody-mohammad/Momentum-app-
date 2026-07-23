import 'package:hive/hive.dart';
import 'package:momentum/models/enums.dart';

part 'habit.g.dart'; // This will be generated automatically

@HiveType(typeId: 0)
class Habit {

  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.timeOfDay,
    this.isArchived = false,
    this.frequencyType = FrequencyType.daily,
    this.weeklyDays = const [],
    this.intervalDays = 1,
    DateTime? startDate,
  }) : startDate = startDate ?? DateTime.now();
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  final HabitCategory category;
  
  @HiveField(3)
  final HabitTimeOfDay timeOfDay;
  
  @HiveField(4)
  bool isArchived; // Soft delete!

  @HiveField(5)
  FrequencyType frequencyType;

  @HiveField(6)
  List<int> weeklyDays;

  @HiveField(7)
  int intervalDays;

  @HiveField(8)
  DateTime startDate;

  bool isScheduledOn(DateTime date) {
    switch (frequencyType) {
      case FrequencyType.daily:
        return true;
      case FrequencyType.weekly:
        return weeklyDays.contains(date.weekday);
      case FrequencyType.interval:
        final start = DateTime(startDate.year, startDate.month, startDate.day);
        final current = DateTime(date.year, date.month, date.day);
        if (current.isBefore(start)) return false;
        final differenceInDays = current.difference(start).inDays;
        return differenceInDays % intervalDays == 0;
    }
  }
}