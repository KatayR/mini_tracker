import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/task_entity.dart';
import '../../controllers/task_controller.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: Consumer<TaskController>(
        builder: (context, controller, child) {
          final tasks = controller.tasks;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: Key(task.id),
                onDismissed: (_) => controller.deleteTask(task.id),
                child: Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => controller.toggleTaskCompletion(task.id),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null),
                    ),
                    subtitle: task.description.isNotEmpty ? Text(task.description) : null,
                    trailing: _buildPriorityIcon(task.priority),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const Icon(Icons.flag, color: Colors.red);
      case TaskPriority.medium:
        return const Icon(Icons.flag, color: Colors.orange);
      case TaskPriority.low:
        return const Icon(Icons.flag, color: Colors.green);
    }
  }
}
