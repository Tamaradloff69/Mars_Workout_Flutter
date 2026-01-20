// lib/logic/bloc/plan/plan_state.dart
part of 'plan_bloc.dart';

final class PlanState extends Equatable {
  // Key: WorkoutType.toString() (e.g., "WorkoutType.cycling")
  // Value: Plan ID (e.g., "bn_150km_classic")
  final Map<String, String> activePlans;
  final List<String> completedDayIds;

  const PlanState({this.activePlans = const {}, this.completedDayIds = const []});

  PlanState copyWith({Map<String, String>? activePlans, List<String>? completedDayIds}) {
    return PlanState(activePlans: activePlans ?? this.activePlans, completedDayIds: completedDayIds ?? this.completedDayIds);
  }

  // --- LOGIC: Is THIS plan the single active one for its type? ---
  bool isPlanActive(String planId, WorkoutType type) {
    final activeIdForType = activePlans[type.toString()];
    return activeIdForType == planId;
  }

  @override
  List<Object?> get props => [activePlans, completedDayIds];

  Map<String, dynamic> toJson() {
    return {'activePlans': activePlans, 'completedDayIds': completedDayIds};
  }

  factory PlanState.fromJson(Map<String, dynamic> json) {
    return PlanState(activePlans: Map<String, String>.from(json['activePlans'] ?? {}), completedDayIds: List<String>.from(json['completedDayIds'] ?? []));
  }
}
