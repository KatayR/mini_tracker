import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_validators.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../controllers/habit_controller.dart';

class AddEditHabitScreen extends StatefulWidget {
  final HabitEntity? habit;

  const AddEditHabitScreen({super.key, this.habit});

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  int _targetDays = 21;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _targetDays = widget.habit?.targetDays ?? 21;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool success;
      if (widget.habit == null) {
        // Add
        success = await context.read<HabitController>().addHabit(_nameController.text.trim(), _targetDays);
      } else {
        // Edit
        final updatedHabit = widget.habit!.copyWith(name: _nameController.text.trim(), targetDays: _targetDays);
        success = await context.read<HabitController>().updateHabitDetails(updatedHabit);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (success) {
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editHabit : AppStrings.newHabit),
        actions: [
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(AppDimens.p16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.onSurface),
              ),
            )
          else
            IconButton(icon: const Icon(AppIcons.save), onPressed: _saveHabit),
        ],
      ),
      body: IgnorePointer(
        ignoring: _isLoading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.p16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: AppDecorations.input(label: AppStrings.habitName),
                validator: (v) => AppValidators.required(v, message: AppStrings.nameRequired),
              ),
              const SizedBox(height: AppDimens.p24),

              // Target Days
              _buildTargetDaysSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetDaysSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.targetDays, style: AppTextStyles.headingSmall),
        const SizedBox(height: AppDimens.p8),
        // Requirement: "Target Number of Days (e.g., 7 / 21 / 30)"
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 7, label: Text(AppStrings.sevenDays)),
            ButtonSegment(value: 21, label: Text(AppStrings.twentyOneDays)),
            ButtonSegment(value: 30, label: Text(AppStrings.thirtyDays)),
          ],
          selected: {_targetDays},
          onSelectionChanged: (newSelection) {
            setState(() {
              _targetDays = newSelection.first;
            });
          },
        ),
      ],
    );
  }
}
