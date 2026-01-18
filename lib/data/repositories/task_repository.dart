import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

class TaskRepository implements ITaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepository(this._localDataSource);

  @override
  Future<List<TaskEntity>> fetchAllItems() async {
    final models = _localDataSource.getAll();
    return models;
  }

  @override
  Future<void> create(TaskEntity item) async {
    final model = TaskModel.fromEntity(item);
    await _localDataSource.add(model);
  }

  @override
  Future<void> update(TaskEntity item) async {
    final model = TaskModel.fromEntity(item);
    await _localDataSource.update(model);
  }

  @override
  Future<void> delete(String id) async {
    await _localDataSource.delete(id);
  }
}
