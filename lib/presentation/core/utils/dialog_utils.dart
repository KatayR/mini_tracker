import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';
import '../theme/app_shapes.dart';

class DialogUtils {
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: AppShapes.dialogShape,
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(onPressed: () => context.pop(false), child: const Text(AppStrings.cancel)),
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text(AppStrings.delete, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
