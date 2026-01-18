import 'package:flutter/foundation.dart';

import '../../domain/entities/base_entity.dart';

/// Generic base controller for managing a list of items of type [T].
abstract class BaseDataController<T extends BaseEntity> extends ChangeNotifier {
  List<T> _items = [];
  List<T> get items => List.unmodifiable(_items);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Abstract methods to be implemented by child controllers
  Future<List<T>> loadLocalFromRepository();

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      final localItems = await loadLocalFromRepository();
      _items = List<T>.from(localItems);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading items: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helpers for modifying local state

  @protected
  void addLocalItem(T item) {
    _items.add(item);
    notifyListeners();
  }

  @protected
  void updateLocalItem(T item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
    }
  }

  @protected
  void deleteLocalItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }
}
