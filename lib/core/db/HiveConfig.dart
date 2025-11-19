import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static Future init() async {
    await Hive.initFlutter();
    await Hive.openBox('fishing_logs');
  }
}