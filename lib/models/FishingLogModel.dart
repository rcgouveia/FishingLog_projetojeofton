import 'package:hive/hive.dart';

part 'FishingLogModel.g.dart';

@HiveType(typeId: 1)
class FishingLogModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String fishName;

  @HiveField(2)
  double weight;

  @HiveField(3)
  double length;

  @HiveField(4)
  String location;

  @HiveField(5)
  DateTime date;

  FishingLogModel({
    this.id,
    required this.fishName,
    required this.weight,
    required this.length,
    required this.location,
    required this.date,
  });
}
