import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/logic/habit_logic.dart';
import '../../domain/repositories/i_habit_repository.dart';
import 'base_data_controller.dart';

class HabitController extends BaseDataController<HabitEntity> {
  final IHabitRepository _repository;

  HabitController(this._repository);

  @override
  Future<List<HabitEntity>> loadLocalFromRepository() {
    return _repository.fetchAllItems();
  }

  Future<void> addHabit(String name, int targetDays) async {
    final newHabit = HabitEntity(id: const Uuid().v4(), name: name, targetDays: targetDays, createdAt: DateTime.now());
    await _repository.create(newHabit);
    addLocalItem(newHabit);
  }

  Future<void> toggleHabitCompletion(String id) async {
    final index = items.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = items[index];
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
      updateLocalItem(updatedHabit);
    }
  }

  Future<void> deleteHabit(String id) async {
    await _repository.delete(id);
    deleteLocalItem(id);
  }

  // Debug Tool
  Future<void> debugAdvanceOneDay() async {
    for (int i = 0; i < items.length; i++) {
      final habit = items[i];
      final newDates = habit.completionDates.map((d) => d.subtract(AppConstants.oneDay)).toList();
      final newStreak = HabitLogic.calculateStreak(newDates);
      final updatedHabit = habit.copyWith(completionDates: newDates, streak: newStreak);
      await _repository.update(updatedHabit);
      updateLocalItem(updatedHabit);
    }
  }
}
