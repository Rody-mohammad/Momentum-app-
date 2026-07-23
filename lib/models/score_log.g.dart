// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreLogAdapter extends TypeAdapter<ScoreLog> {
  @override
  final int typeId = 4;

  @override
  ScoreLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreLog(
      id: fields[0] as String,
      date: fields[1] as String,
      score: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScoreLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
