// lib/data/models/workout_history_item.dart

import 'package:equatable/equatable.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';

class WorkoutHistoryItem extends Equatable {
  final String id;
  final String workoutTitle;
  final WorkoutType type;
  final DateTime completedAt;
  final int totalMinutes;

  const WorkoutHistoryItem({
    required this.id,
    required this.workoutTitle,
    required this.type,
    required this.completedAt,
    required this.totalMinutes,
  });

  @override
  List<Object?> get props => [id, workoutTitle, type, completedAt, totalMinutes];

  Map<String, dynamic> toJson() => {
    'id': id,
    'workoutTitle': workoutTitle,
    'type': type.toString(),
    'completedAt': completedAt.toIso8601String(),
    'totalMinutes': totalMinutes,
  };

  factory WorkoutHistoryItem.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryItem(
      id: json['id'],
      workoutTitle: json['workoutTitle'],
      type: WorkoutType.values.firstWhere((e) => e.toString() == json['type']),
      completedAt: DateTime.parse(json['completedAt']),
      totalMinutes: json['totalMinutes'],
    );
  }
}