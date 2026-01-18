import 'package:flutter/foundation.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/feedback_utils.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/base_entity.dart';
import '../../presentation/mixins/remote_action_mixin.dart';

/// Generic base controller for managing a list of items of type [T].
/// Handles loading, syncing, searching, and error states.
abstract class BaseDataController<T extends BaseEntity> extends ChangeNotifier with RemoteActionMixin {
  // State
  List<T> _items = [];
  List<T> get items => _items;
  @protected
  set items(List<T> value) => _items = value;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Template Methods

  /// Loads items from local storage, then triggers a background sync.
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      final localItems = await loadLocalFromRepository();
      _items = List<T>.from(localItems);
      notifyListeners();

      // Trigger sync in background
      syncItems();
    } catch (e) {
      FeedbackUtils.showError(AppStrings.error, "Failed to load items: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Syncs items with remote repository and updates local state.
  Future<void> syncItems() async {
    _isSyncing = true;
    notifyListeners();
    try {
      await syncRemoteRepository();
      final localItems = await loadLocalFromRepository();

      // Optional hook for processing items after sync (e.g. recalculating streaks)
      final processedItems = processItemsAfterSync(localItems);

      _items = List<T>.from(processedItems);
      notifyListeners();
    } catch (e) {
      AppLogger.e("Sync Failed", e);
      final message = e.toString().replaceAll("Exception: ", "");
      FeedbackUtils.showError(AppStrings.error, message);
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Abstract Methods to be implemented by child controllers

  /// Load data from the local repository
  Future<List<T>> loadLocalFromRepository();

  /// Trigger the repository's sync method
  Future<void> syncRemoteRepository();

  // Optional Hooks

  List<T> processItemsAfterSync(List<T> items) {
    return items;
  }
  // Generic CRUD Operations (DRY)

  @protected
  Future<bool> performCreate(Future<void> Function() remoteCreate, T item, String errorMessage) async {
    return await executeRemoteAction(
      remoteCall: remoteCreate,
      onSuccessLocalUpdate: () => addLocalItem(item),
      errorMessage: errorMessage,
    );
  }

  @protected
  Future<bool> performUpdate(
    Future<void> Function() remoteUpdate,
    T item,
    String errorMessage, {
    String? loadingId,
  }) async {
    return await executeRemoteAction(
      loadingId: loadingId ?? item.id,
      remoteCall: remoteUpdate,
      onSuccessLocalUpdate: () => updateLocalItem(item),
      errorMessage: errorMessage,
    );
  }

  @protected
  Future<void> performDelete(Future<void> Function() remoteDelete, String id, String errorMessage) async {
    await executeRemoteAction(
      loadingId: id,
      remoteCall: remoteDelete,
      onSuccessLocalUpdate: () => deleteLocalItem(id),
      errorMessage: errorMessage,
    );
  }

  // Helper Methods for Local Updates (DRY)

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
