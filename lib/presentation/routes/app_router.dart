import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../screens/habits/add_edit_habit_screen.dart';
import '../screens/habits/habit_list_screen.dart';
import '../screens/home/home_page.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/tasks/add_edit_task_screen.dart';
import '../screens/tasks/task_list_screen.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          // Tasks Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) => const TaskListScreen(),
                routes: [
                  GoRoute(path: 'add', builder: (context, state) => const AddEditTaskScreen()),
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => AddEditTaskScreen(task: state.extra as TaskEntity?),
                  ),
                ],
              ),
            ],
          ),

          // Habits Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.habits,
                builder: (context, state) => const HabitListScreen(),
                routes: [
                  GoRoute(path: 'add', builder: (context, state) => const AddEditHabitScreen()),
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => AddEditHabitScreen(habit: state.extra as HabitEntity?),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
