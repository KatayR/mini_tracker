import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/entities/base_entity.dart';
import '../interfaces/i_crud_data_source.dart';

/// A generic implementation of [ICrudDataSource] for Hive-backed entities.
///
/// [T] must extend [BaseEntity] to ensure it has an [id] property.
/// Ideally [T] should also be a Hive object, but since we use separate Models/Entities
/// and wrap the Hive Box logic, the [BaseEntity] constraint focuses on the ID requirement.
class GenericLocalDataSourceImpl<T extends BaseEntity> implements ICrudDataSource<T> {
  final Box<T> box;

  GenericLocalDataSourceImpl(this.box);

  @override
  Future<List<T>> getAll() async {
    return box.values.toList();
  }

  @override
  Future<T> create(T item) async {
    await box.put(item.id, item);
    return item;
  }

  @override
  Future<T> update(T item) async {
    await box.put(item.id, item);
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }

  @override
  Future<void> cacheAll(List<T> items) async {
    final map = {for (var i in items) i.id: i};
    await box.putAll(map);
  }
}
