import 'package:flutter/material.dart';
class AppPalette {
  // Brand
  static const Color brandPurple = Color(0xFF6750A4);

  // Semantic
  static const Color errorRed = Colors.red;
  static const Color successGreen = Colors.green;
  static const Color warningOrange = Colors.orange;

  // Semantic Dark Variants (for backgrounds like SnackBars)
  static final Color errorRedDark = Colors.red.shade700;
  static final Color successGreenDark = Colors.green.shade700;

  /// Text color for SnackBars with dark semantic backgrounds.
  static const Color onSnackBar = Colors.white;
}
