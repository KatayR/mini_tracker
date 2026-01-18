import 'package:flutter/material.dart';

import 'app_dimens.dart';

class AppDecorations {
  static InputDecoration input({required String label}) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.all(AppDimens.p16),
    );
  }

  static BoxDecoration priorityBadge(Color color) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppDimens.r8),
      border: Border.all(color: color, width: 1),
    );
  }
}
