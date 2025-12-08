import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_state.dart';

class PlanBloc extends HydratedBloc<PlanEvent, PlanState> {
  PlanBloc() : super(const PlanState()) {
    on<StartPlan>((event, emit) {
      emit(state.copyWith(activePlanId: event.planId));
    });

    on<CompleteDay>((event, emit) {
      final updatedList = List<String>.from(state.completedDayIds);
      if (!updatedList.contains(event.dayId)) {
        updatedList.add(event.dayId);
      }
      emit(state.copyWith(completedDayIds: updatedList));
    });

    on<MarkDayAsCompleted>((event, emit) {
      final updatedList = List<String>.from(state.completedDayIds);
      if (!updatedList.contains(event.dayId)) {
        updatedList.add(event.dayId);
      }
      emit(state.copyWith(completedDayIds: updatedList));
    });

    on<ResetProgress>((event, emit) {
      emit(const PlanState(activePlanId: null, completedDayIds: []));
    });
  }

  @override
  PlanState? fromJson(Map<String, dynamic> json) {
    return PlanState(
      activePlanId: json['activePlanId'],
      completedDayIds: List<String>.from(json['completedDayIds'] ?? []),
    );
  }

  @override
  Map<String, dynamic>? toJson(PlanState state) {
    return {
      'activePlanId': state.activePlanId,
      'completedDayIds': state.completedDayIds,
    };
  }
}
