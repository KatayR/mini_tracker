import 'package:hive/hive.dart';

import '../models/task_model.dart';

class TaskLocalDataSource {
  final Box<TaskModel> _box;

  TaskLocalDataSource(this._box);

  List<TaskModel> getAll() {
    return _box.values.toList();
  }

  Future<void> add(TaskModel item) async {
    await _box.put(item.id, item);
  }

  Future<void> update(TaskModel item) async {
    await _box.put(item.id, item);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
