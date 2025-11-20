import 'package:hive/hive.dart';

part 'FishingLogModel.g.dart';

@HiveType(typeId: 1)
class FishingLogModel extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double weight;

  @HiveField(3)
  double height;

  @HiveField(4)
  String location;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String imagePath;
  
  @HiveField(7)
  String bait;

  FishingLogModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.location,
    required this.date,
    required this.imagePath,
    required this.bait,
  });
}
