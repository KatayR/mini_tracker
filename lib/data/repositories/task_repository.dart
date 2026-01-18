import '../../../domain/entities/task_entity.dart';
import '../../../domain/repositories/i_task_repository.dart';
import '../models/task_model.dart';
import 'base_repository.dart';

class TaskRepositoryImpl extends BaseRepository<TaskEntity, TaskModel> implements ITaskRepository {
  TaskRepositoryImpl({required super.localDataSource, required super.remoteDataSource}) : super(logLabel: "Task");

  @override
  TaskModel toModel(TaskEntity entity) => TaskModel.fromEntity(entity);
}
