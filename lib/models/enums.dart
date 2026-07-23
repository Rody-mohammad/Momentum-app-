import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 2)
enum HabitCategory {
  @HiveField(0)
  health,
  @HiveField(1)
  mind,
  @HiveField(2)
  social,
  @HiveField(3)
  work,
  @HiveField(4)
  creative,
}

@HiveType(typeId: 3)
enum HabitTimeOfDay {
  @HiveField(0)
  morning,
  @HiveField(1)
  afternoon,
  @HiveField(2)
  evening,
  @HiveField(3)
  anytime,
}

@HiveType(typeId: 5)
enum FrequencyType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  interval,
}