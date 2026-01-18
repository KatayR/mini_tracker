import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/task_enums.dart';
import '../../controllers/task_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/generic_list_screen.dart';
import '../../widgets/task_item_widget.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading after frame to ensure Provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        return GenericListScreen(
          title: AppStrings.myTasks,
          searchHint: AppStrings.searchTasks,
          onSearchChanged: (val) => controller.setSearchQuery(val),
          header: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.p16, vertical: AppDimens.p8),
            child: Row(
              children: [
                _buildFilterChip(context, TaskFilter.all, AppStrings.all),
                const SizedBox(width: 8),
                _buildFilterChip(context, TaskFilter.active, AppStrings.active),
                const SizedBox(width: 8),
                _buildFilterChip(context, TaskFilter.completed, AppStrings.done),
              ],
            ),
          ),
          isLoading: controller.isLoading,
          isSyncing: controller.isSyncing,
          filteredItems: controller.filteredTasks,
          onRefresh: () async {
            await controller.syncItems();
          },
          emptyMessage: AppStrings.noTasksFound,
          emptyIcon: AppIcons.emptyTasks,
          onFabPressed: () {
            context.push(AppRoutes.addTask);
          },
          itemBuilder: (context, task) {
            final isTaskLoading = controller.isTaskLoading(task.id);
            return TaskItemWidget(
              task: task,
              isLoading: isTaskLoading,
              onTap: () {
                context.push(AppRoutes.editTask, extra: task);
              },
              onCheckboxChanged: (val) {
                controller.updateTaskStatus(task, val ?? false);
              },
              onDelete: () {
                controller.deleteTask(task.id);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, TaskFilter filter, String label) {
    // Use select to only rebuild when filter changes
    final currentFilter = context.select<TaskController, TaskFilter>((c) => c.currentFilter);
    final isSelected = currentFilter == filter;
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => context.read<TaskController>().setFilter(filter),
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: (isSelected ? AppTextStyles.chipSelected : AppTextStyles.chipUnselected).copyWith(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
      ),
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      showCheckmark: false,
    );
  }
}
