import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mini_tracker/presentation/core/constants/app_icons.dart';
import 'package:mini_tracker/presentation/core/theme/app_dimens.dart';
import '../../controllers/theme_controller.dart';
import 'app_search_bar.dart';
import 'empty_state_widget.dart';
import 'sync_indicator_widget.dart';

class GenericListScreen<T> extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final String searchHint;
  final Function(String) onSearchChanged;
  final Widget? header; // For filter chips etc.
  final bool isLoading;
  final bool isSyncing;
  final List<T> filteredItems;
  final Future<void> Function() onRefresh;
  final String emptyMessage;
  final IconData emptyIcon;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback onFabPressed;

  const GenericListScreen({
    super.key,
    required this.title,
    this.actions,
    required this.searchHint,
    required this.onSearchChanged,
    this.header,
    required this.isLoading,
    required this.isSyncing,
    required this.filteredItems,
    required this.onRefresh,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.itemBuilder,
    required this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Consumer<ThemeController>(
            builder: (context, themeController, _) {
              final isDark = themeController.themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => themeController.toggleTheme(),
              );
            },
          ),
          if (actions != null) ...actions!,
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(AppDimens.h60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.p16, vertical: AppDimens.p8),
            child: AppSearchBar(hintText: searchHint, onChanged: onSearchChanged),
          ),
        ),
      ),
      body: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                ? RefreshIndicator(
                    onRefresh: onRefresh,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Center(
                              child: EmptyStateWidget(message: emptyMessage, icon: emptyIcon),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return itemBuilder(context, filteredItems[index]);
                      },
                    ),
                  ),
          ),
          if (isSyncing) const SyncIndicatorWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: onFabPressed, child: const Icon(AppIcons.add)),
    );
  }
}
