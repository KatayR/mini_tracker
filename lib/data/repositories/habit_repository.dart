import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../datasources/interfaces/i_crud_data_source.dart';
import '../models/habit_model.dart';
import 'base_repository.dart';

class HabitRepository extends BaseRepository<HabitEntity, HabitModel> implements IHabitRepository {
  HabitRepository({
    required ICrudDataSource<HabitModel> localDataSource,
    required ICrudDataSource<HabitModel> remoteDataSource,
  }) : super(localDataSource: localDataSource, remoteDataSource: remoteDataSource, logLabel: 'HabitRepository');

  @override
  HabitModel toModel(HabitEntity entity) {
    return HabitModel.fromEntity(entity);
  }
}
