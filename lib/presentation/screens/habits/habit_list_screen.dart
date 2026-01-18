import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';

class HabitListScreen extends StatelessWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time), // Time Travel Icon
            onPressed: () => context.read<HabitController>().debugAdvanceOneDay(),
          ),
        ],
      ),
      body: Consumer<HabitController>(
        builder: (context, controller, child) {
          final habits = controller.items;
          if (habits.isEmpty) {
            return const Center(child: Text('No habits yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return Dismissible(
                key: Key(habit.id),
                onDismissed: (_) => controller.deleteHabit(habit.id),
                child: Card(
                  child: ListTile(
                    leading: CircularProgressIndicator(value: habit.progress, backgroundColor: Colors.grey.shade200),
                    title: Text(habit.name),
                    subtitle: Text('${habit.streak} day streak'),
                    trailing: IconButton(
                      icon: Icon(
                        habit.isCompletedToday ? Icons.check_circle : Icons.check_circle_outline,
                        color: habit.isCompletedToday ? Colors.green : Colors.grey,
                      ),
                      onPressed: () => controller.toggleHabitCompletion(habit.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick Add for MVP
          context.read<HabitController>().addHabit('New Habit', 7);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
