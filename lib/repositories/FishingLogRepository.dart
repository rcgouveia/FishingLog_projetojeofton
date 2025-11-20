import 'package:hive_flutter/hive_flutter.dart';
import '../models/FishingLogModel.dart';

class FishingLogRepository {
  final Box _box = Hive.box('fishing_logs');

  Future<int> add(FishingModel log) async {
    return await _box.add({
      "fishName": log.fishName,
      "photoPath": log.photoPath,
      "location": log.location,
      "date": log.date.toIso8601String(),
      "bait": log.bait,
      "size": log.size,
      "weight": log.weight,
    });
  }

  List<FishingModel> getAll() {
    return _box.values.map((e) {
      final map = Map<String, dynamic>.from(e);
      return FishingModel(
        fishName: map['fishName'],
        photoPath: map['photoPath'],
        location: map['location'],
        date: DateTime.parse(map['date']),
        bait: map['bait'],
        size: map['size'],
        weight: map['weight'],
      );
    }).toList();
  }

  Future<void> update(int id, FishingModel log) async {
    await _box.put(id, {
      "fishName": log.fishName,
      "photoPath": log.photoPath,
      "location": log.location,
      "date": log.date.toIso8601String(),
      "bait": log.bait,
      "size": log.size,
      "weight": log.weight,
    });
  }

  Future<void> delete(int id) async {
    await _box.delete(id);
  }
}