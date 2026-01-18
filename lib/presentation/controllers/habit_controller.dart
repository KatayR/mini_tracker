import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/feedback_utils.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/logic/habit_logic.dart';
import '../../domain/repositories/i_habit_repository.dart';
import 'base_data_controller.dart';

class HabitController extends BaseDataController<HabitEntity> {
  final IHabitRepository repository;

  HabitController(this.repository);

  // Getters for filtered list
  List<HabitEntity> get filteredHabits {
    if (searchQuery.isEmpty) {
      return items;
    }
    return items.where((h) => h.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  bool isHabitLoading(String id) => isItemLoading(id);

  // Implementation of Abstract Methods

  @override
  Future<List<HabitEntity>> loadLocalFromRepository() {
    return repository.fetchAllItems();
  }

  @override
  Future<void> syncRemoteRepository() {
    return repository.syncRemote();
  }

  // Optional Hook override to recalculate streaks after sync
  @override
  List<HabitEntity> processItemsAfterSync(List<HabitEntity> items) {
    return items.map((h) {
      final calculatedStreak = HabitLogic.calculateStreak(h.completionDates);
      if (calculatedStreak != h.streak) {
        return h.copyWith(streak: calculatedStreak);
      }
      return h;
    }).toList();
  }

  // Note: These methods are wrappers around executeRemoteAction.
  // We explicitly define them here instead of in the BaseController to:
  // 1. Encapsulate business logic (e.g., ID generation, specific parameters).
  // 2. Maintain strict type safety for the repository calls.
  // 3. Keep the Repository interface simple and explicit.

  // Specific CRUD Methods

  Future<bool> addHabit(String name, int targetDays) async {
    final newHabit = HabitEntity(id: const Uuid().v4(), name: name, targetDays: targetDays, createdAt: DateTime.now());

    return performCreate(() => repository.create(newHabit), newHabit, AppStrings.errorAddHabit);
  }

  Future<void> toggleHabitCompletion(HabitEntity habit) async {
    final now = DateTime.now();
    final isDoneToday = habit.isCompletedToday;

    List<DateTime> newDates = List.from(habit.completionDates);

    if (isDoneToday) {
      // Undo
      newDates.removeWhere((d) => d.year == now.year && d.month == now.month && d.day == now.day);
    } else {
      // Do
      newDates.add(now);
    }

    // Recalculate streak dynamically
    final newStreak = HabitLogic.calculateStreak(newDates);
    final updatedHabit = habit.copyWith(completionDates: newDates, streak: newStreak);

    await performUpdate(
      () => repository.update(updatedHabit),
      updatedHabit,
      AppStrings.errorUpdateHabit,
      loadingId: habit.id,
    );
  }

  Future<void> deleteHabit(String id) async {
    await performDelete(() => repository.delete(id), id, AppStrings.errorDeleteHabit);
  }

  Future<bool> updateHabitDetails(HabitEntity habit) async {
    return performUpdate(() => repository.update(habit), habit, AppStrings.errorUpdateHabit);
  }

  // DEBUG ONLY: Simulates a day passing by shifting all completion dates back by 1 day.
  Future<void> debugAdvanceOneDay() async {
    for (int i = 0; i < items.length; i++) {
      final habit = items[i];
      final newDates = habit.completionDates.map((d) => d.subtract(AppConstants.oneDay)).toList();

      // Recalculate streak for the new shifted dates
      final newStreak = HabitLogic.calculateStreak(newDates);

      items[i] = habit.copyWith(completionDates: newDates, streak: newStreak);
    }
    notifyListeners();
    FeedbackUtils.showSuccess(AppStrings.debugTimeTravel, AppStrings.debugTimeTravelMessage);
  }
}
