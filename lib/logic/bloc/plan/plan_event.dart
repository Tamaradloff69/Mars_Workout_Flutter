import 'package:equatable/equatable.dart';


// --- EVENTS ---
abstract class PlanEvent extends Equatable {
  const PlanEvent();
  @override
  List<Object> get props => [];
}

class StartPlan extends PlanEvent {
  final String planId;
  const StartPlan(this.planId);
}

class CompleteDay extends PlanEvent {
  final String dayId;
  const CompleteDay(this.dayId);
}

class MarkDayAsCompleted extends PlanEvent {
  final String dayId;

  const MarkDayAsCompleted(this.dayId);

  @override
  List<Object> get props => [dayId];
}

class ResetProgress extends PlanEvent {}
