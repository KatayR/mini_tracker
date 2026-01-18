import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehir360_clean/presentation/screens/tasks/task_list_screen.dart';

import 'core/theme/app_theme.dart';
import 'presentation/controllers/task_controller.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => TaskController(), child: const MainApp()));
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
