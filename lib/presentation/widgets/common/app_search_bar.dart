import 'package:flutter/material.dart';

import '../../../core/constants/app_icons.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const AppSearchBar({super.key, required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hintText,
      leading: const Icon(AppIcons.search),
      onChanged: onChanged,
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainerHigh),
    );
  }
}
