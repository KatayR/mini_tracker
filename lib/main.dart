import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/init/app_initializer.dart';
import 'core/init/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/controllers/habit_controller.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  // Initialize Hive
  await AppInitializer.init();

  // Initialize Dependency Injection
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<TaskController>()..loadItems()),
        ChangeNotifierProvider(create: (_) => di.sl<HabitController>()..loadItems()),
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
