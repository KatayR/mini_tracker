import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/task_model.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());

    // Open Boxes
    await Hive.openBox<TaskModel>('tasks');
  }
}
