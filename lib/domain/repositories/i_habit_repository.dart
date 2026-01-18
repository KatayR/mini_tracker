import '../entities/habit_entity.dart';

abstract class IHabitRepository {
  Future<List<HabitEntity>> fetchAllItems();
  Future<void> create(HabitEntity item);
  Future<void> update(HabitEntity item);
  Future<void> delete(String id);
}
