import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/habit_local_data_source.dart';
import 'data/datasources/remote/mock_generic_remote_data_source.dart';
import 'data/datasources/task_local_data_source.dart';
import 'data/models/habit_model.dart';
import 'data/models/task_model.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/task_repository.dart';
import 'presentation/controllers/habit_controller.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  await AppInitializer.init();

  // Dependency Injection (Manual for MVP)
  final taskBox = Hive.box<TaskModel>('tasks');
  final taskLocalDataSource = TaskLocalDataSource(taskBox);
  final taskRemoteDataSource = MockGenericRemoteDataSource<TaskModel>();
  final taskRepository = TaskRepository(localDataSource: taskLocalDataSource, remoteDataSource: taskRemoteDataSource);

  final habitBox = Hive.box<HabitModel>('habits');
  final habitLocalDataSource = HabitLocalDataSource(habitBox);
  final habitRemoteDataSource = MockGenericRemoteDataSource<HabitModel>();
  final habitRepository = HabitRepository(
    localDataSource: habitLocalDataSource,
    remoteDataSource: habitRemoteDataSource,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController(taskRepository)..loadItems()),
        ChangeNotifierProvider(create: (_) => HabitController(habitRepository)..loadItems()),
      ],
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
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
