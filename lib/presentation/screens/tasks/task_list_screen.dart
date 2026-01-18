import 'package:flutter/material.dart';

import '../../../domain/entities/task_entity.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      TaskEntity(
        id: '1',
        title: 'Buy groceries',
        description: 'Milk, Eggs, Bread',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      ),
      TaskEntity(id: '2', title: 'Walk the dog', createdAt: DateTime.now(), priority: TaskPriority.medium),
      TaskEntity(
        id: '3',
        title: 'Code Flutter app',
        description: 'Finish the reconstruction',
        createdAt: DateTime.now(),
        isCompleted: true,
        priority: TaskPriority.low,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            child: ListTile(
              leading: Checkbox(value: task.isCompleted, onChanged: (val) {}),
              title: Text(
                task.title,
                style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null),
              ),
              subtitle: task.description.isNotEmpty ? Text(task.description) : null,
              trailing: _buildPriorityIcon(task.priority),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
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
