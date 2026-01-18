import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task_entity.dart';

class TaskController extends ChangeNotifier {
  final List<TaskEntity> _tasks = [
    TaskEntity(
      id: '1',
      title: 'Buy groceries',
      description: 'Milk, Eggs, Bread',
      createdAt: DateTime.now(),
      priority: TaskPriority.high,
    ),
    TaskEntity(id: '2', title: 'Walk the dog', createdAt: DateTime.now(), priority: TaskPriority.medium),
  ];

  List<TaskEntity> get tasks => List.unmodifiable(_tasks);

  void addTask(String title, String description, TaskPriority priority) {
    final newTask = TaskEntity(
      id: const Uuid().v4(),
      title: title,
      description: description,
      priority: priority,
      createdAt: DateTime.now(),
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
