import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../datasources/interfaces/i_crud_data_source.dart';
import '../models/task_model.dart';
import 'base_repository.dart';

class TaskRepository extends BaseRepository<TaskEntity, TaskModel> implements ITaskRepository {
  TaskRepository({
    required ICrudDataSource<TaskModel> localDataSource,
    required ICrudDataSource<TaskModel> remoteDataSource,
  }) : super(localDataSource: localDataSource, remoteDataSource: remoteDataSource, logLabel: 'TaskRepository');

  @override
  TaskModel toModel(TaskEntity entity) {
    return TaskModel.fromEntity(entity);
  }
}
