import 'package:hive/hive.dart';

import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends TaskEntity {
  TaskModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.title,
    @HiveField(2) required super.description,
    @HiveField(3) required super.isCompleted,
    @HiveField(4) super.dueDate,
    @HiveField(5) required String priorityString,
    @HiveField(6) required super.createdAt,
  }) : super(
         priority: TaskPriority.values.firstWhere((e) => e.name == priorityString, orElse: () => TaskPriority.medium),
       );

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      dueDate: entity.dueDate,
      priorityString: entity.priority.name,
      createdAt: entity.createdAt,
    );
  }

  @HiveField(0)
  @override
  String get id => super.id;

  @HiveField(1)
  @override
  String get title => super.title;

  @HiveField(2)
  @override
  String get description => super.description;

  @HiveField(3)
  @override
  bool get isCompleted => super.isCompleted;

  @HiveField(4)
  @override
  DateTime? get dueDate => super.dueDate;

  @HiveField(5)
  String get priorityString => priority.name;

  @HiveField(6)
  @override
  DateTime get createdAt => super.createdAt;
}
