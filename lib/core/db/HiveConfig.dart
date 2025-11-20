import 'package:hive_flutter/hive_flutter.dart';
import '../../models/FishingLogModel.dart';

class HiveConfig {
  static const String logsBox = 'fishing_logs';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FishingLogModelAdapter());
    }

    await Hive.openBox<FishingLogModel>(logsBox);
  }

  static Box<FishingLogModel> get logs => Hive.box<FishingLogModel>(logsBox);
}
