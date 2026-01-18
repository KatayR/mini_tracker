import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../datasources/habit_local_data_source.dart';
import '../models/habit_model.dart';

class HabitRepository implements IHabitRepository {
  final HabitLocalDataSource _localDataSource;

  HabitRepository(this._localDataSource);

  @override
  Future<List<HabitEntity>> fetchAllItems() async {
    return _localDataSource.getAll();
  }

  @override
  Future<void> create(HabitEntity item) async {
    final model = HabitModel.fromEntity(item);
    await _localDataSource.create(model);
  }

  @override
  Future<void> update(HabitEntity item) async {
    final model = HabitModel.fromEntity(item);
    await _localDataSource.update(model);
  }

  @override
  Future<void> delete(String id) async {
    await _localDataSource.delete(id);
  }
}
