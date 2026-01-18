import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/logic/habit_logic.dart';
import '../../domain/repositories/i_habit_repository.dart';

class HabitController extends ChangeNotifier {
  final IHabitRepository _repository;
  List<HabitEntity> _habits = [];

  HabitController(this._repository);

  List<HabitEntity> get habits => List.unmodifiable(_habits);

  Future<void> loadHabits() async {
    _habits = await _repository.fetchAllItems();
    notifyListeners();
  }

  Future<void> addHabit(String name, int targetDays) async {
    final newHabit = HabitEntity(id: const Uuid().v4(), name: name, targetDays: targetDays, createdAt: DateTime.now());
    await _repository.create(newHabit);
    await loadHabits();
  }

  Future<void> toggleHabitCompletion(String id) async {
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
      final updatedHabit = habit.copyWith(completionDates: newDates, streak: newStreak);
      await _repository.update(updatedHabit);
      await loadHabits();
    }
  }

  Future<void> deleteHabit(String id) async {
    await _repository.delete(id);
    await loadHabits();
  }

  // Debug Tool
  Future<void> debugAdvanceOneDay() async {
    for (int i = 0; i < _habits.length; i++) {
      final habit = _habits[i];
      final newDates = habit.completionDates.map((d) => d.subtract(AppConstants.oneDay)).toList();
      final newStreak = HabitLogic.calculateStreak(newDates);
      final updatedHabit = habit.copyWith(completionDates: newDates, streak: newStreak);
      await _repository.update(updatedHabit);
    }
    await loadHabits();
  }
}
