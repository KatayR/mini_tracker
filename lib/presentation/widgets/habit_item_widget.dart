import 'package:flutter/material.dart';

import '../../../domain/entities/habit_entity.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import 'common/dismissible_item_card.dart';

class HabitItemWidget extends StatelessWidget {
  final HabitEntity habit;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final bool isLoading;

  const HabitItemWidget({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DismissibleItemCard(
      id: habit.id,
      onDelete: onDelete,
      confirmTitle: AppStrings.deleteHabitTitle,
      confirmMessage: AppStrings.deleteHabitMessage,
      isLoading: isLoading,
      child: ListTile(
        onTap: onTap,
        leading: InkWell(
          onTap: onToggle,
          customBorder: const CircleBorder(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: habit.isCompletedToday ? Theme.of(context).colorScheme.primary : Colors.transparent,
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            child: habit.isCompletedToday ? Icon(AppIcons.check, color: Theme.of(context).colorScheme.onPrimary) : null,
          ),
        ),
        title: Text(habit.name, style: AppTextStyles.titleMedium),
        subtitle: Text('${AppStrings.streak}: ${habit.streak} ${AppStrings.days}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${habit.streak} / ${habit.targetDays}',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: AppDimens.p4),
            SizedBox(
              width: 60,
              child: LinearProgressIndicator(
                value: habit.progress,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                minHeight: AppDimens.p4,
                borderRadius: BorderRadius.circular(AppDimens.r2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
