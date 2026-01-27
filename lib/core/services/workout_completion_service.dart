import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';

/// Service to handle workout completion detection logic.
/// Determines if a workout completion results in week or plan completion.
class WorkoutCompletionService {
  /// Result of checking workout completion status.
  CompletionStatus checkCompletion({
    required String completedDayId,
    required Set<String> completedDayIds,
    required List<TrainingPlan> allPlans,
    required WorkoutType workoutType,
    required String? activePlanId,
  }) {
    if (activePlanId == null) {
      return CompletionStatus(
        isWeekComplete: false,
        isPlanComplete: false,
      );
    }

    try {
      final currentPlan = allPlans.firstWhere((p) => p.id == activePlanId);

      // Check if entire plan is complete
      final isPlanComplete = currentPlan.weeks.every(
        (week) => week.days.every((day) => completedDayIds.contains(day.id)),
      );

      bool isWeekComplete = false;

      // If plan is not complete, check if the current week is complete
      if (!isPlanComplete) {
        for (var week in currentPlan.weeks) {
          if (week.days.any((d) => d.id == completedDayId)) {
            isWeekComplete = week.days.every(
              (d) => completedDayIds.contains(d.id),
            );
            break;
          }
        }
      }

      return CompletionStatus(
        isWeekComplete: isWeekComplete,
        isPlanComplete: isPlanComplete,
      );
    } catch (e) {
      // Plan not found or error occurred
      return CompletionStatus(
        isWeekComplete: false,
        isPlanComplete: false,
        error: 'Plan lookup error: $e',
      );
    }
  }
}

/// Represents the completion status after a workout is finished.
class CompletionStatus {
  final bool isWeekComplete;
  final bool isPlanComplete;
  final String? error;

  CompletionStatus({
    required this.isWeekComplete,
    required this.isPlanComplete,
    this.error,
  });

  /// Returns true if this was just a workout completion (not week or plan).
  bool get isWorkoutOnly => !isWeekComplete && !isPlanComplete;
}
