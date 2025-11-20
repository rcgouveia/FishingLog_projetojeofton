import 'package:hive_flutter/hive_flutter.dart';
import '../../models/FishingLogModel.dart';

class HiveConfig {
  static const String logsBox = 'fishing_logs';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FishingLogModelAdapter());
    }

    // Apaga o box antigo se existir
    if (await Hive.boxExists(logsBox)) {
      await Hive.deleteBoxFromDisk(logsBox);
    }

    // Abre um box limpo
    await Hive.openBox<FishingLogModel>(logsBox);
  }

  static Box<FishingLogModel> get logs => Hive.box<FishingLogModel>(logsBox);
}