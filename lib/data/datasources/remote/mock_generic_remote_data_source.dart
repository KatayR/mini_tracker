import 'dart:math';

import '../../../domain/entities/base_entity.dart';
import '../interfaces/i_crud_data_source.dart';

class MockGenericRemoteDataSource<T extends BaseEntity> implements ICrudDataSource<T> {
  final _random = Random();
  final List<T> _items = [];

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulated error injection could be here
  }

  @override
  Future<List<T>> getAll() async {
    await _simulateDelay();
    return List.from(_items);
  }

  @override
  Future<void> create(T item) async {
    await _simulateDelay();
    _items.add(item);
  }

  @override
  Future<void> update(T item) async {
    await _simulateDelay();
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    } else {
      // Upsert
      _items.add(item);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _simulateDelay();
    _items.removeWhere((i) => i.id == id);
  }

  @override
  Future<void> cacheAll(List<T> items) async {
    await _simulateDelay();
    _items.clear();
    _items.addAll(items);
  }
}
