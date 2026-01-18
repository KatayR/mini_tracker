import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();
  }
}
