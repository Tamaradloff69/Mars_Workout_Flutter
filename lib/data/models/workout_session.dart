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

  const WorkoutSession({required this.workout, required this.planDayId, required this.workoutType, required this.currentStageIndex, required this.elapsed, required this.isRunning, required this.savedAt});

  @override
  List<Object?> get props => [workout, planDayId, workoutType, currentStageIndex, elapsed, isRunning, savedAt];

  Map<String, dynamic> toJson() => {'workout': workout.toJson(), 'planDayId': planDayId, 'workoutType': workoutType.toString(), 'currentStageIndex': currentStageIndex, 'elapsed': elapsed.inSeconds, 'isRunning': isRunning, 'savedAt': savedAt.toIso8601String()};

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      workout: Workout.fromJson(json['workout']),
      planDayId: json['planDayId'],
      workoutType: WorkoutType.values.firstWhere((e) => e.toString() == json['workoutType']),
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

  /// Determines if the workout should be considered complete.
  /// This prevents the "Resume" dialog from appearing for a workout
  /// that has actually finished.
  bool isWorkoutFinished() {
    if (workout.stages.isEmpty) return true;

    // If the index is already beyond the last stage, it is definitely finished.
    if (currentStageIndex >= workout.stages.length) return true;

    final isLastStage = currentStageIndex == workout.stages.length - 1;
    if (isLastStage) {
      final lastStage = workout.stages[currentStageIndex];

      // We consider it finished if the elapsed time is greater than or equal
      // to the duration. We remove the 500ms "buffer" to be exact.
      return elapsed >= lastStage.duration;
    }

    return false;
  }

  /// Get a friendly description of workout progress
  String getProgressDescription() {
    final totalStages = workout.stages.length;
    if (totalStages == 0) return 'No stages';

    // A more accurate percentage based on completed stages + current progress
    final completedStages = currentStageIndex;
    final percentComplete = ((completedStages / totalStages) * 100).round();

    return '$percentComplete% complete - Stage ${currentStageIndex + 1}/$totalStages';
  }
}
