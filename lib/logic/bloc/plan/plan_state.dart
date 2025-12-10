import 'package:equatable/equatable.dart';

import '../../../data/models/training_plan.dart';
import '../../../data/repositories/workout_repository.dart';

class PlanState extends Equatable {
  final String? activePlanId;
  final List<String> completedDayIds;

  // We don't persist the actual plan objects (they are static),
  // just the IDs needed to look them up.

  const PlanState({this.activePlanId, this.completedDayIds = const []});

  PlanState copyWith({String? activePlanId, List<String>? completedDayIds}) {
    return PlanState(activePlanId: activePlanId ?? this.activePlanId, completedDayIds: completedDayIds ?? this.completedDayIds);
  }

  @override
  List<Object?> get props => [activePlanId, completedDayIds];

  // Helpers
  TrainingPlan? get currentPlan {
    if (activePlanId == null) return null;
    final plans = WorkoutRepository().getAllPlans();
    return plans.firstWhere((p) => p.id == activePlanId, orElse: () => plans.first);
  }
}
