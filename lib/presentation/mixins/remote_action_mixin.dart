import 'package:flutter/foundation.dart';

import 'package:mini_tracker/presentation/core/constants/app_strings.dart';
import 'package:mini_tracker/presentation/core/utils/feedback_utils.dart';

/// Mixin to handle per-item loading states and safe remote execution.
///
/// Usage: `class MyController extends ChangeNotifier with RemoteActionMixin`
mixin RemoteActionMixin on ChangeNotifier {
  final Set<String> _loadingItemIds = {};

  /// Checks if a specific item (by ID) is currently performing a remote action.
  bool isItemLoading(String id) => _loadingItemIds.contains(id);

  /// Executes a remote action safely with loading state management and error handling.
  ///
  /// [loadingId]: Optional ID of the item to mark as loading (e.g., waiting for delete).
  /// [remoteCall]: The async remote operation (e.g., API call).
  /// [onSuccessLocalUpdate]: Callback to update local state logic only if remote succeeds.
  /// [errorMessage]: Message to show in SnackBar if [remoteCall] fails.
  Future<bool> executeRemoteAction({
    String? loadingId,
    required Future<void> Function() remoteCall,
    required VoidCallback onSuccessLocalUpdate,
    required String errorMessage,
  }) async {
    if (loadingId != null) {
      _loadingItemIds.add(loadingId);
      notifyListeners();
    }

    try {
      await remoteCall();
      onSuccessLocalUpdate();
      return true;
    } catch (e) {
      FeedbackUtils.showError(AppStrings.error, "$errorMessage: $e");
      return false;
    } finally {
      if (loadingId != null) {
        _loadingItemIds.remove(loadingId);
        notifyListeners();
      }
    }
  }
}
