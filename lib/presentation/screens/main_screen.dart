import 'package:flutter/material.dart';
import '../../presentation/screens/habits/habit_list_screen.dart';
import '../../presentation/screens/tasks/task_list_screen.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const TaskListScreen(), const HabitListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(AppIcons.navTasks), label: AppStrings.navTasks),
          NavigationDestination(icon: Icon(AppIcons.navHabits), label: AppStrings.navHabits),
        ],
      ),
    );
  }
}
