import 'package:hive/hive.dart';
import '../models/FishingLogModel.dart';
import '../core/db/HiveConfig.dart';

class FishingLogRepository {
  Box<FishingLogModel> get _box => HiveConfig.logs;

  Future<List<FishingLogModel>> getAll() async {
    final list = _box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<FishingLogModel?> getById(int id) async {
    return _box.values.firstWhere((e) => e.id == id);
  }

  Future<FishingLogModel> create(FishingLogModel model) async {
    model.id = DateTime.now().millisecondsSinceEpoch;
    await _box.put(model.id, model);
    return model;
  }

  Future<FishingLogModel?> update(int id, FishingLogModel model) async {
    if (!_box.containsKey(id)) return null;

    await _box.put(id, model);
    return model;
  }

  Future<bool> delete(int id) async {
    if (!_box.containsKey(id)) return false;
    await _box.delete(id);
    return true;
  }
}
