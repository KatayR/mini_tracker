import 'package:hive/hive.dart';

import '../models/habit_model.dart';

class HabitLocalDataSource {
  final Box<HabitModel> _box;

  HabitLocalDataSource(this._box);

  List<HabitModel> getAll() {
    return _box.values.toList();
  }

  Future<void> add(HabitModel item) async {
    await _box.put(item.id, item);
  }

  Future<void> update(HabitModel item) async {
    await _box.put(item.id, item);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
