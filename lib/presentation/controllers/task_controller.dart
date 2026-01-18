import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/i_task_repository.dart';

class TaskController extends ChangeNotifier {
  final ITaskRepository _repository;
  List<TaskEntity> _tasks = [];

  TaskController(this._repository);

  List<TaskEntity> get tasks => List.unmodifiable(_tasks);

  Future<void> loadTasks() async {
    _tasks = await _repository.fetchAllItems();
    notifyListeners();
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
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _repository.update(updatedTask);
      await loadTasks();
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.delete(id);
    await loadTasks();
  }
}
