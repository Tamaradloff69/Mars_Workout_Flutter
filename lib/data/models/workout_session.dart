import 'package:equatable/equatable.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

/// Represents a saved workout session that can be resumed
class WorkoutSession extends Equatable {
  final Workout workout;
  final String planDayId;
  final WorkoutType workoutType;
  final int currentStageIndex;
  final Duration elapsed;
  final bool isRunning;
  final DateTime savedAt;

  const WorkoutSession({
    required this.workout,
    required this.planDayId,
    required this.workoutType,
    required this.currentStageIndex,
    required this.elapsed,
    required this.isRunning,
    required this.savedAt,
  });

  @override
  List<Object?> get props => [
        workout,
        planDayId,
        workoutType,
        currentStageIndex,
        elapsed,
        isRunning,
        savedAt,
      ];

  Map<String, dynamic> toJson() => {
        'workout': workout.toJson(),
        'planDayId': planDayId,
        'workoutType': workoutType.toString(),
        'currentStageIndex': currentStageIndex,
        'elapsed': elapsed.inSeconds,
        'isRunning': isRunning,
        'savedAt': savedAt.toIso8601String(),
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      workout: Workout.fromJson(json['workout']),
      planDayId: json['planDayId'],
      workoutType: WorkoutType.values.firstWhere(
        (e) => e.toString() == json['workoutType'],
      ),
      currentStageIndex: json['currentStageIndex'],
      elapsed: Duration(seconds: json['elapsed']),
      isRunning: json['isRunning'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }

  /// Check if the session is still valid (not too old)
  bool isValid({Duration maxAge = const Duration(hours: 24)}) {
    return DateTime.now().difference(savedAt) < maxAge;
  }

  /// Get a friendly description of workout progress
  String getProgressDescription() {
    final totalStages = workout.stages.length;
    if (totalStages == 0) return 'No stages';

    final completedStages = currentStageIndex;
    final percentComplete = ((completedStages / totalStages) * 100).round();
    return '$percentComplete% complete - Stage ${currentStageIndex + 1}/$totalStages';
  }
}
