import 'package:flutter/material.dart';

class AppTextStyles {
  // Headings

  static const TextStyle headingSmall = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto');

  /// Semi-bold title for list items (habits, tasks).
  static const TextStyle titleMedium = TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Roboto');

  // Body

  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontFamily: 'Roboto');

  // Specific Use Cases
  static const TextStyle emptyStateMessage = TextStyle(fontSize: 16, fontFamily: 'Roboto');

  static const TextStyle chipSelected = TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto');

  static const TextStyle chipUnselected = TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Roboto');
}
