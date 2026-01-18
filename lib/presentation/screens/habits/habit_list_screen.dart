import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../controllers/habit_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/generic_list_screen.dart';
import '../../widgets/common/habit_item_widget.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading after frame to ensure Provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitController>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch logic
    final controller = context.watch<HabitController>();

    return GenericListScreen(
      title: AppStrings.myHabits,
      actions: [
        IconButton(
          icon: const Icon(AppIcons.timeTravel, color: Colors.orange),
          tooltip: AppStrings.debugTimeTravel,
          onPressed: () => controller.debugAdvanceOneDay(),
        ),
      ],
      searchHint: AppStrings.searchHabits,
      onSearchChanged: (val) => controller.setSearchQuery(val),
      isLoading: controller.isLoading,
      isSyncing: controller.isSyncing,
      filteredItems: controller.filteredHabits,
      onRefresh: () async {
        await controller.loadItems();
      },
      emptyMessage: AppStrings.noHabitsFound,
      emptyIcon: AppIcons.emptyHabits,
      onFabPressed: () {
        context.push(AppRoutes.addHabit);
      },
      itemBuilder: (context, habit) {
        final isHabitLoading = controller.isHabitLoading(habit.id);
        return HabitItemWidget(
          habit: habit,
          isLoading: isHabitLoading,
          onTap: () {
            context.push(AppRoutes.editHabit, extra: habit);
          },
          onToggle: () {
            controller.toggleHabitCompletion(habit);
          },
          onDelete: () {
            controller.deleteHabit(habit.id);
          },
        );
      },
    );
  }
}
