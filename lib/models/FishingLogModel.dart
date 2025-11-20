import 'package:hive/hive.dart';

class FishingLogModel {
  int id;
  String name;       
  double weight;     
  double height;     
  String location;  
  DateTime date;     

  FishingLogModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.location,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'weight': weight,
        'height': height,
        'location': location,
        'date': date.toIso8601String(),
      };

  factory FishingLogModel.fromMap(Map<String, dynamic> m) => FishingLogModel(
        id: m['id'] as int,
        name: m['name'] as String,
        weight: (m['weight'] as num).toDouble(),
        height: (m['height'] as num).toDouble(),
        location: m['location'] as String,
        date: DateTime.parse(m['date'] as String),
      );
}

class FishingLogModelAdapter extends TypeAdapter<FishingLogModel> {
  @override
  final int typeId = 1;

  @override
  FishingLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }
    return FishingLogModel(
      id: fields[0] as int,
      name: fields[1] as String,
      weight: fields[2] as double,
      height: fields[3] as double,
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
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.date);
  }
}
