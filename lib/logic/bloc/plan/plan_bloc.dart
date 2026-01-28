// lib/logic/bloc/plan/plan_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends HydratedBloc<PlanEvent, PlanState> {
  PlanBloc() : super(const PlanState()) {
    on<StartPlan>((event, emit) {
      final updatedMap = Map<String, String>.from(state.activePlans);
      updatedMap[event.type.toString()] = event.planId;

      emit(state.copyWith(activePlans: updatedMap));
    });

    on<MarkDayAsCompleted>((event, emit) {
      final updatedSet = Set<String>.from(state.completedDayIds);
      updatedSet.add(event.dayId); // Set.add handles duplicates automatically
      emit(state.copyWith(completedDayIds: updatedSet));
    });

    on<ResetPlanProgress>((event, emit) {
      // 1. Gather all day IDs belonging to the target plan
      final planDayIds = <String>{};
      for (var week in event.plan.weeks) {
        for (var day in week.days) {
          planDayIds.add(day.id);
        }
      }

      // 2. Filter the current set to exclude those IDs
      final updatedCompletedIds = state.completedDayIds.where((id) => !planDayIds.contains(id)).toSet();

      // 3. Emit new state (Progress cleared, but plan remains Active)
      emit(state.copyWith(completedDayIds: updatedCompletedIds));
    });
  }

  @override
  PlanState? fromJson(Map<String, dynamic> json) => PlanState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PlanState state) => state.toJson();
}
