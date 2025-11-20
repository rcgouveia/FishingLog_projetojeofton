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
      id: fields[0] as int,
      name: fields[1] as String,
      weight: fields[2] as double,
      height: fields[3] as double,
      location: fields[4] as String,
      date: fields[5] as DateTime,
      imagePath: fields[6] as String,
      bait: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FishingLogModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.bait);
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
