import '../../../domain/entities/habit_entity.dart';
import '../../../domain/repositories/i_habit_repository.dart';
import '../models/habit_model.dart';
import 'base_repository.dart';

class HabitRepositoryImpl extends BaseRepository<HabitEntity, HabitModel> implements IHabitRepository {
  HabitRepositoryImpl({required super.localDataSource, required super.remoteDataSource}) : super(logLabel: "Habit");

  @override
  HabitModel toModel(HabitEntity entity) => HabitModel.fromEntity(entity);
}
