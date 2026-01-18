import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/logic/habit_logic.dart';

class HabitController extends ChangeNotifier {
  final List<HabitEntity> _habits = [
    HabitEntity(
      id: '1',
      name: 'Drink Water',
      targetDays: 7,
      streak: 3,
      completionDates: [
        DateTime.now(),
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().subtract(const Duration(days: 2)),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  List<HabitEntity> get habits => List.unmodifiable(_habits);

  void addHabit(String name, int targetDays) {
    final newHabit = HabitEntity(id: const Uuid().v4(), name: name, targetDays: targetDays, createdAt: DateTime.now());
    _habits.add(newHabit);
    notifyListeners();
  }

  void toggleHabitCompletion(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final now = DateTime.now();

      List<DateTime> newDates = List.from(habit.completionDates);

      if (habit.isCompletedToday) {
        // Undo
        newDates.removeWhere((d) => d.year == now.year && d.month == now.month && d.day == now.day);
      } else {
        // Complete
        newDates.add(now);
      }

      final newStreak = HabitLogic.calculateStreak(newDates);
      _habits[index] = habit.copyWith(completionDates: newDates, streak: newStreak);
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  // Debug Tool
  void debugAdvanceOneDay() {
    for (int i = 0; i < _habits.length; i++) {
      final habit = _habits[i];
      final newDates = habit.completionDates.map((d) => d.subtract(AppConstants.oneDay)).toList();
      final newStreak = HabitLogic.calculateStreak(newDates);
      _habits[i] = habit.copyWith(completionDates: newDates, streak: newStreak);
    }
    notifyListeners();
  }
}
