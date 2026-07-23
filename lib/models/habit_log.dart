import 'package:hive/hive.dart';

part 'habit_log.g.dart'; // This will be generated automatically

@HiveType(typeId: 1)
class HabitLog {

  HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
    this.usedFreezeToken = false,
  });
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String habitId;
  
  @HiveField(2)
  final String date; // Format: "2023-10-25"
  
  @HiveField(3)
  final bool isCompleted;
  
  @HiveField(4)
  final bool usedFreezeToken;
}