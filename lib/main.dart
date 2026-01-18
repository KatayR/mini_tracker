import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/di/service_locator.dart';
import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/i_habit_repository.dart';
import 'domain/repositories/i_task_repository.dart';
import 'presentation/controllers/habit_controller.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/routes/app_router.dart';

void main() async {
  await AppInitializer.init();

  await setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController(getIt<ITaskRepository>())),
        ChangeNotifierProvider(create: (_) => HabitController(getIt<IHabitRepository>())),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const MiniTrackerApp(),
    ),
  );
}

class MiniTrackerApp extends StatelessWidget {
  const MiniTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp.router(
          scaffoldMessengerKey: AppRouter.rootScaffoldMessengerKey,
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
