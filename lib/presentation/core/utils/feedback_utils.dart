import 'package:flutter/material.dart';

import '../../routes/app_router.dart';
import '../constants/app_constants.dart';
import '../theme/app_palette.dart';

/// Utility class for showing user feedback via SnackBars.
///
/// Uses semantic colors from [AppPalette] to ensure consistent theming
/// and avoid hardcoded color values throughout the codebase.
class FeedbackUtils {
  /// Shows a success snackbar with a green background.
  ///
  /// [title] - Bold header text for the message.
  /// [message] - Descriptive body text.
  static void showSuccess(String title, String message) {
    _showSnackBar(title: title, message: message, backgroundColor: AppPalette.successGreenDark);
  }

  /// Shows an error snackbar with a red background.
  ///
  /// [title] - Bold header text for the error.
  /// [message] - Descriptive error details.
  static void showError(String title, String message) {
    _showSnackBar(title: title, message: message, backgroundColor: AppPalette.errorRedDark);
  }

  /// Internal helper to build and display a styled SnackBar.
  static void _showSnackBar({required String title, required String message, required Color backgroundColor}) {
    AppRouter.rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppPalette.onSnackBar),
            ),
            Text(message, style: const TextStyle(color: AppPalette.onSnackBar)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: AppConstants.snackBarDuration,
      ),
    );
  }
}
