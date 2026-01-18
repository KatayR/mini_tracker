import 'dart:math';

import '../../../domain/entities/base_entity.dart';
import '../interfaces/i_crud_data_source.dart';

class MockGenericRemoteDataSource<T extends BaseEntity> implements ICrudDataSource<T> {
  final _random = Random();
  final List<T> _items = [];

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_random.nextInt(10) < 1) {
      // 10% chance of error
      throw Exception("Simulated Remote Error");
    }
  }

  @override
  Future<List<T>> getAll() async {
    await _simulateDelay();
    return List.from(_items);
  }

  @override
  Future<T> create(T item) async {
    await _simulateDelay();

    _items.add(item);
    return item;
  }

  @override
  Future<T> update(T item) async {
    await _simulateDelay();
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    } else {
      // Upsert: If item doesn't exist on remote, create it
      _items.add(item);
    }
    return item;
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
