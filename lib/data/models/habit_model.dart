import 'package:hive/hive.dart';

import '../../domain/entities/habit_entity.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel extends HabitEntity {
  const HabitModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.name,
    @HiveField(2) required super.targetDays,
    @HiveField(3) required super.streak,
    @HiveField(4) required super.completionDates,
    @HiveField(5) required super.createdAt,
  });

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      name: entity.name,
      targetDays: entity.targetDays,
      streak: entity.streak,
      completionDates: entity.completionDates,
      createdAt: entity.createdAt,
    );
  }

  @HiveField(0)
  @override
  String get id => super.id;

  @HiveField(1)
  @override
  String get name => super.name;

  @HiveField(2)
  @override
  int get targetDays => super.targetDays;

  @HiveField(3)
  @override
  int get streak => super.streak;

  @HiveField(4)
  @override
  List<DateTime> get completionDates => super.completionDates;

  @HiveField(5)
  @override
  DateTime get createdAt => super.createdAt;
}
