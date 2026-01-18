import '../entities/task_entity.dart';
import '../entities/task_enums.dart';

/// Provides pure business logic for filtering and sorting tasks.
///
/// This class contains static utility methods that transform task lists
/// based on user-defined criteria. All methods are pure functions with
/// no side effects, making them ideal for unit testing.
class TaskFilterLogic {
  /// Applies a multi-stage filtering pipeline to a list of tasks.
  ///
  /// The pipeline processes tasks in the following order:
  ///
  /// 1. **Status Filter** - Filters tasks by completion state:
  ///    - [TaskFilter.all]: No filtering, includes all tasks.
  ///    - [TaskFilter.active]: Only incomplete tasks (`isCompleted == false`).
  ///    - [TaskFilter.completed]: Only completed tasks (`isCompleted == true`).
  ///
  /// 2. **Search Filter** - If [searchQuery] is non-empty, filters tasks
  ///    where the title contains the query (case-insensitive match).
  ///
  /// 3. **Sorting** - Results are sorted by creation date in descending order
  ///    (newest tasks appear first).
  ///
  /// **Example:**
  /// ```dart
  /// final filtered = TaskFilterLogic.apply(
  ///   allTasks,
  ///   filter: TaskFilter.active,
  ///   searchQuery: 'meeting',
  /// );
  /// // Returns active tasks containing "meeting" in the title, newest first.
  /// ```
  ///
  /// [tasks] - The source list of tasks to filter. Not modified by this method.
  /// [filter] - The status filter to apply (all, active, or completed).
  /// [searchQuery] - Text to search for in task titles. Empty string skips search.
  ///
  /// Returns a new list containing only the tasks that match all criteria,
  /// sorted by creation date (newest first).
  static List<TaskEntity> apply(List<TaskEntity> tasks, {required TaskFilter filter, required String searchQuery}) {
    List<TaskEntity> filtered = List.from(tasks);

    // 1. Filter by Status
    if (filter == TaskFilter.active) {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    } else if (filter == TaskFilter.completed) {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }

    // 2. Filter by Search
    if (searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      filtered = filtered.where((t) => t.title.toLowerCase().contains(queryLower)).toList();
    }

    // Sort by Date (Newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }
}
