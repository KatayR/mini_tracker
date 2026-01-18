import 'package:flutter/material.dart';

import '../../../domain/entities/task_entity.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_time_extension.dart';
import 'common/dismissible_item_card.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onDelete;

  final bool isLoading;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.onDelete,
    this.isLoading = false,
  });

  Color _getPriorityColor(TaskPriority priority) {
    return AppTheme.priorityColors[priority] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return DismissibleItemCard(
      id: task.id,
      onDelete: onDelete,
      confirmTitle: AppStrings.deleteTaskTitle,
      confirmMessage: AppStrings.deleteTaskMessage,
      isLoading: isLoading,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: task.isCompleted, onChanged: onCheckboxChanged, shape: const CircleBorder()),
        title: Text(
          task.title,
          style: AppTextStyles.headingSmall.copyWith(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            decorationThickness: 2.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (task.dueDate != null)
              Padding(
                padding: const EdgeInsets.only(top: AppDimens.p4),
                child: Row(
                  children: [
                    Icon(AppIcons.calendar, size: AppDimens.iconSmall, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(width: AppDimens.p4),
                    Text(
                      task.dueDate!.toAppFormat(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: task.isOverdue
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.outline,
                        fontWeight: task.isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.p8, vertical: AppDimens.p4),
          decoration: AppDecorations.priorityBadge(_getPriorityColor(task.priority)),
          child: Text(
            task.priority.name.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              color: _getPriorityColor(task.priority),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
