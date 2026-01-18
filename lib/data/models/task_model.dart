import 'package:hive/hive.dart';

import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends TaskEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool isCompleted;
  @HiveField(4)
  final DateTime? dueDate;
  @HiveField(5)
  final int priorityIndex; // Storing index for simplicity in MVP
  @HiveField(6)
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.dueDate,
    required this.priorityIndex,
    required this.createdAt,
  }) : super(
         id: id,
         title: title,
         description: description,
         isCompleted: isCompleted,
         dueDate: dueDate,
         priority: TaskPriority.values.firstWhere((e) => e.index == priorityIndex, orElse: () => TaskPriority.medium),
         createdAt: createdAt,
       );

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      dueDate: entity.dueDate,
      priorityIndex: entity.priority.index,
      createdAt: entity.createdAt,
    );
  }
}
