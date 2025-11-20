// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FishingLogModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishingLogModelAdapter extends TypeAdapter<FishingLogModel> {
  @override
  final int typeId = 1;

  @override
  FishingLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FishingLogModel(
      id: fields[0] as int?,
      fishName: fields[1] as String,
      weight: fields[2] as double,
      length: fields[3] as double,
      location: fields[4] as String,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FishingLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fishName)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.length)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishingLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
