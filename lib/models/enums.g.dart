// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitCategoryAdapter extends TypeAdapter<HabitCategory> {
  @override
  final int typeId = 2;

  @override
  HabitCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitCategory.health;
      case 1:
        return HabitCategory.mind;
      case 2:
        return HabitCategory.social;
      case 3:
        return HabitCategory.work;
      case 4:
        return HabitCategory.creative;
      default:
        return HabitCategory.health;
    }
  }

  @override
  void write(BinaryWriter writer, HabitCategory obj) {
    switch (obj) {
      case HabitCategory.health:
        writer.writeByte(0);
        break;
      case HabitCategory.mind:
        writer.writeByte(1);
        break;
      case HabitCategory.social:
        writer.writeByte(2);
        break;
      case HabitCategory.work:
        writer.writeByte(3);
        break;
      case HabitCategory.creative:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitTimeOfDayAdapter extends TypeAdapter<HabitTimeOfDay> {
  @override
  final int typeId = 3;

  @override
  HabitTimeOfDay read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitTimeOfDay.morning;
      case 1:
        return HabitTimeOfDay.afternoon;
      case 2:
        return HabitTimeOfDay.evening;
      case 3:
        return HabitTimeOfDay.anytime;
      default:
        return HabitTimeOfDay.morning;
    }
  }

  @override
  void write(BinaryWriter writer, HabitTimeOfDay obj) {
    switch (obj) {
      case HabitTimeOfDay.morning:
        writer.writeByte(0);
        break;
      case HabitTimeOfDay.afternoon:
        writer.writeByte(1);
        break;
      case HabitTimeOfDay.evening:
        writer.writeByte(2);
        break;
      case HabitTimeOfDay.anytime:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitTimeOfDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequencyTypeAdapter extends TypeAdapter<FrequencyType> {
  @override
  final int typeId = 5;

  @override
  FrequencyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FrequencyType.daily;
      case 1:
        return FrequencyType.weekly;
      case 2:
        return FrequencyType.interval;
      default:
        return FrequencyType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, FrequencyType obj) {
    switch (obj) {
      case FrequencyType.daily:
        writer.writeByte(0);
        break;
      case FrequencyType.weekly:
        writer.writeByte(1);
        break;
      case FrequencyType.interval:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
