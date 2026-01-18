import 'package:flutter/material.dart';

import 'app_dimens.dart';
import 'app_palette.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.brandPurple, brightness: Brightness.light),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.r12)),
      filled: true,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.brandPurple, brightness: Brightness.dark),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.r12)),
      filled: true,
    ),
  );
}
