import 'package:flutter/material.dart';

import '../../../domain/entities/habit_entity.dart';

class HabitListScreen extends StatelessWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = [
      HabitEntity(id: '1', name: 'Drink Water', targetDays: 7, streak: 3, createdAt: DateTime.now()),
      HabitEntity(id: '2', name: 'Read Book', targetDays: 30, streak: 12, createdAt: DateTime.now()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Habits')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return Card(
            child: ListTile(
              leading: CircularProgressIndicator(value: habit.progress, backgroundColor: Colors.grey.shade200),
              title: Text(habit.name),
              subtitle: Text('${habit.streak} day streak'),
              trailing: IconButton(icon: const Icon(Icons.check), onPressed: () {}),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const snackBar = SnackBar(content: Text('Add Habit functionality not implemented yet'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
