import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_decorations.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_validators.dart';
import '../../../core/utils/date_time_extension.dart';
import '../../../domain/entities/task_entity.dart';
import '../../controllers/task_controller.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskEntity? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate;
    _priority = widget.task?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (widget.task == null) {
        // Add
        context.read<TaskController>().addTask(_titleController.text.trim(), _descController.text.trim(), _priority);
      } else {
        // Edit logic to be implemented
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editTask : AppStrings.newTask),
        actions: [IconButton(icon: const Icon(AppIcons.save), onPressed: _saveTask)],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.p16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: AppDecorations.input(label: AppStrings.title),
              validator: (v) => AppValidators.required(v, message: AppStrings.titleRequired),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDimens.p16),
            TextFormField(
              controller: _descController,
              decoration: AppDecorations.input(label: AppStrings.description),
              maxLines: 3,
            ),
            const SizedBox(height: AppDimens.p16),

            // Due Date
            _buildDueDateTile(),
            const Divider(),

            // Priority
            _buildPrioritySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(AppStrings.dueDate),
      subtitle: Text(_dueDate == null ? AppStrings.notSet : _dueDate!.toAppFormat()),
      trailing: const Icon(AppIcons.calendar),
      onTap: _selectDate,
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.priority, style: AppTextStyles.headingSmall),
        const SizedBox(height: AppDimens.p8),
        SegmentedButton<TaskPriority>(
          segments: const [
            ButtonSegment(value: TaskPriority.low, label: Text(AppStrings.low)),
            ButtonSegment(value: TaskPriority.medium, label: Text(AppStrings.medium)),
            ButtonSegment(value: TaskPriority.high, label: Text(AppStrings.high)),
          ],
          selected: {_priority},
          onSelectionChanged: (newSelection) {
            setState(() {
              _priority = newSelection.first;
            });
          },
        ),
      ],
    );
  }
}
