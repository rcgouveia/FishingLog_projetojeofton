import 'package:hive/hive.dart';
import '../core/db/HiveConfig.dart';
import '../models/FishingLogModel.dart';

class FishingLogRepository {
  Box<FishingLogModel> get _box => HiveConfig.logs;

  Future<List<FishingLogModel>> getAll() async {
    final list = _box.values.toList();

    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<FishingLogModel?> getById(int id) async {
    try {
      return _box.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<FishingLogModel> create(FishingLogModel model) async {
    final id = model.id == 0 ? DateTime.now().millisecondsSinceEpoch : model.id;
    final toSave = FishingLogModel(
      id: id,
      name: model.name,
      weight: model.weight,
      height: model.height,
      location: model.location,
      date: model.date,
    );
    await _box.put(id, toSave);
    return toSave;
  }

  Future<FishingLogModel?> update(int id, FishingLogModel model) async {
    if (!_box.containsKey(id)) return null;
    final updated = FishingLogModel(
      id: id,
      name: model.name,
      weight: model.weight,
      height: model.height,
      location: model.location,
      date: model.date,
    );
    await _box.put(id, updated);
    return updated;
  }

  Future<bool> delete(int id) async {
    if (!_box.containsKey(id)) return false;
    await _box.delete(id);
    return true;
  }
}
