import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/task_local_data_source.dart';
import 'data/models/task_model.dart';
import 'data/repositories/task_repository.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/screens/tasks/task_list_screen.dart';

void main() async {
  await AppInitializer.init();

  // Dependency Injection (Manual for MVP)
  final taskBox = Hive.box<TaskModel>('tasks');
  final taskLocalDataSource = TaskLocalDataSource(taskBox);
  final taskRepository = TaskRepository(taskLocalDataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskController(taskRepository)..loadTasks(), // Trigger load immediately
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
