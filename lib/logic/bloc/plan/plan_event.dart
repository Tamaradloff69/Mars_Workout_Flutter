part of 'plan_bloc.dart';

sealed class PlanEvent extends Equatable {
  const PlanEvent();
  @override
  List<Object> get props => [];
}

final class StartPlan extends PlanEvent {
  final String planId;
  final WorkoutType type; // Added Type

  const StartPlan(this.planId, this.type);
}

final class CompleteDay extends PlanEvent {
  final String dayId;
  const CompleteDay(this.dayId);
}

final class MarkDayAsCompleted extends PlanEvent {
  final String dayId;
  const MarkDayAsCompleted(this.dayId);
}

class ResetPlanProgress extends PlanEvent {
  final TrainingPlan plan;
  const ResetPlanProgress(this.plan);
}

class ResetProgress extends PlanEvent {}
