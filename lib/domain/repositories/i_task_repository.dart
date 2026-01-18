import '../entities/task_entity.dart';

abstract class ITaskRepository {
  Future<List<TaskEntity>> fetchAllItems();
  Future<void> create(TaskEntity item);
  Future<void> update(TaskEntity item);
  Future<void> delete(String id);
}
