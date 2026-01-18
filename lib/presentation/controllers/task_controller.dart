import 'package:uuid/uuid.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/i_task_repository.dart';
import 'base_data_controller.dart';

class TaskController extends BaseDataController<TaskEntity> {
  final ITaskRepository _repository;

  TaskController(this._repository);

  @override
  Future<List<TaskEntity>> loadLocalFromRepository() {
    return _repository.fetchAllItems();
  }

  Future<void> addTask(String title, String description, TaskPriority priority) async {
    final newTask = TaskEntity(
      id: const Uuid().v4(),
      title: title,
      description: description,
      priority: priority,
      createdAt: DateTime.now(),
    );
    await _repository.create(newTask);
    addLocalItem(newTask);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = items.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = items[index];
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _repository.update(updatedTask);
      updateLocalItem(updatedTask);
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.delete(id);
    deleteLocalItem(id);
  }
}
