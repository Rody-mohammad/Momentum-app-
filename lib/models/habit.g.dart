// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as HabitCategory,
      timeOfDay: fields[3] as HabitTimeOfDay,
      isArchived: fields[4] as bool,
      frequencyType: fields[5] as FrequencyType,
      weeklyDays: (fields[6] as List).cast<int>(),
      intervalDays: fields[7] as int,
      startDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.timeOfDay)
      ..writeByte(4)
      ..write(obj.isArchived)
      ..writeByte(5)
      ..write(obj.frequencyType)
      ..writeByte(6)
      ..write(obj.weeklyDays)
      ..writeByte(7)
      ..write(obj.intervalDays)
      ..writeByte(8)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
