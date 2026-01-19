import 'package:flutter/material.dart';

import 'package:mini_tracker/presentation/core/constants/app_icons.dart';
import 'package:mini_tracker/presentation/core/theme/app_dimens.dart';
import 'package:mini_tracker/presentation/core/theme/app_shapes.dart';
import 'package:mini_tracker/presentation/core/utils/dialog_utils.dart';

class DismissibleItemCard extends StatelessWidget {
  final String id;
  final Widget child;
  final VoidCallback onDelete;
  final String confirmTitle;
  final String confirmMessage;
  final bool isLoading;

  const DismissibleItemCard({
    super.key,
    required this.id,
    required this.child,
    required this.onDelete,
    required this.confirmTitle,
    required this.confirmMessage,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Dismissible(
        key: Key(id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppDimens.p20),
          child: const Icon(AppIcons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          final confirm = await DialogUtils.showDeleteConfirmation(
            context,
            title: confirmTitle,
            content: confirmMessage,
          );
          if (confirm == true) {
            onDelete();
          }
          return false;
        },
        child: Stack(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: AppDimens.p16, vertical: AppDimens.p8),
              elevation: 2,
              shape: AppShapes.cardShape,
              child: child,
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppDimens.p16, vertical: AppDimens.p8),
                  decoration: BoxDecoration(color: Colors.white.withAlpha(125), borderRadius: AppShapes.roundedMedium),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
