import 'package:uuid/uuid.dart';

import '../../core/constants/app_strings.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_enums.dart';
import '../../domain/logic/task_filter_logic.dart';
import '../../domain/repositories/i_task_repository.dart';
import 'base_data_controller.dart';

class TaskController extends BaseDataController<TaskEntity> {
  final ITaskRepository repository;

  TaskController(this.repository);

  // State specific to Tasks
  TaskFilter _currentFilter = TaskFilter.all;
  TaskFilter get currentFilter => _currentFilter;

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Getters for filtered list
  List<TaskEntity> get filteredTasks {
    return TaskFilterLogic.apply(items, filter: _currentFilter, searchQuery: searchQuery);
  }

  // Implementation of Abstract Methods

  @override
  Future<List<TaskEntity>> loadLocalFromRepository() {
    return repository.fetchAllItems();
  }

  @override
  Future<void> syncRemoteRepository() {
    return repository.syncRemote();
  }

  // Note: These methods are wrappers around executeRemoteAction.
  // We explicitly define them here instead of in the BaseController to:
  // 1. Encapsulate business logic (e.g., ID generation, specific parameters).
  // 2. Maintain strict type safety for the repository calls.
  // 3. Keep the Repository interface simple and explicit.

  // Specific CRUD Methods

  bool isTaskLoading(String id) => isItemLoading(id);

  Future<bool> addTask(String title, String description, DateTime? dueDate, TaskPriority priority) async {
    final newTask = TaskEntity(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      createdAt: DateTime.now(),
    );

    return performCreate(() => repository.create(newTask), newTask, AppStrings.errorAddTask);
  }

  Future<void> updateTaskStatus(TaskEntity task, bool isCompleted) async {
    final updated = task.copyWith(isCompleted: isCompleted);
    await performUpdate(() => repository.update(updated), updated, AppStrings.errorUpdateTask);
  }

  Future<bool> updateTaskDetails(TaskEntity task) async {
    return performUpdate(() => repository.update(task), task, AppStrings.errorUpdateTask);
  }

  Future<void> deleteTask(String id) async {
    await performDelete(() => repository.delete(id), id, AppStrings.errorDeleteTask);
  }
}
