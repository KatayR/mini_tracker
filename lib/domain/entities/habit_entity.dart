import 'package:equatable/equatable.dart';

import 'base_entity.dart';

class HabitEntity extends Equatable implements BaseEntity {
  @override
  final String id;
  final String name;
  final int targetDays;
  final int streak;
  final List<DateTime> completionDates;
  final DateTime createdAt;

  const HabitEntity({
    required this.id,
    required this.name,
    required this.targetDays,
    this.streak = 0,
    this.completionDates = const [],
    required this.createdAt,
  });

  bool get isCompletedToday {
    if (completionDates.isEmpty) return false;
    final now = DateTime.now();
    final last = completionDates.last;
    return last.year == now.year && last.month == now.month && last.day == now.day;
  }

  HabitEntity copyWith({
    String? id,
    String? name,
    int? targetDays,
    int? streak,
    List<DateTime>? completionDates,
    DateTime? createdAt,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      targetDays: targetDays ?? this.targetDays,
      streak: streak ?? this.streak,
      completionDates: completionDates ?? this.completionDates,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, targetDays, streak, completionDates, createdAt];

  double get progress {
    if (targetDays == 0) return 0.0;
    return (streak / targetDays).clamp(0.0, 1.0);
  }
}
