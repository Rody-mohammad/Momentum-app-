import 'package:hive/hive.dart';

part 'score_log.g.dart';

@HiveType(typeId: 4)
class ScoreLog {

  ScoreLog({
    required this.id,
    required this.date,
    required this.score,
  });
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String date; // YYYY-MM-DD
  
  @HiveField(2)
  final int score;
}