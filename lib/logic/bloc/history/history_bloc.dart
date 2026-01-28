// lib/logic/bloc/history/history_bloc.dart

import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_history_item.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends HydratedBloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryState()) {
    on<RemovePlanFromHistory>((event, emit) {
      // Extract all IDs belonging to the plan being reset
      final planDayIds = event.plan.weeks
          .expand((week) => week.days)
          .map((day) => day.id)
          .toSet();

      // Filter history to remove those specific IDs
      final updatedHistory = state.history
          .where((item) => !planDayIds.contains(item.id))
          .toList();

      emit(HistoryState(history: updatedHistory));
    });
    on<SyncCompletedWorkouts>((event, emit) {
      final currentHistoryIds = state.history.map((item) => item.id).toSet();
      final allPlans = WorkoutRepository().getAllPlans();
      final List<WorkoutHistoryItem> newItems = [];

      for (var dayId in event.completedDayIds) {
        // Only process if this ID isn't already in our history list
        if (!currentHistoryIds.contains(dayId)) {
          try {
            // Find the workout details from our repositories using the ID
            // This logic assumes your IDs (e.g., 'disc_w1_d1') are searchable
            for (var plan in allPlans) {
              for (var week in plan.weeks) {
                for (var day in week.days) {
                  if (day.id == dayId) {
                    newItems.add(
                      WorkoutHistoryItem(
                        id: day.id,
                        // Using the dayId as the unique key prevents duplicates
                        workoutTitle: day.title,
                        type: plan.workoutType,
                        completedAt: DateTime.now(),
                        // Estimate for past items
                        totalMinutes: day.workout.stages.fold(0, (sum, s) => sum + s.duration.inMinutes),
                      ),
                    );
                  }
                }
              }
            }
          } catch (e) {
            debugPrint("Could not find workout details for $dayId");
          }
        }
      }

      if (newItems.isNotEmpty) {
        final updatedHistory = List<WorkoutHistoryItem>.from(state.history)..addAll(newItems);
        // Sort by date if necessary, or keep chronological
        emit(HistoryState(history: updatedHistory));
      }
    });
    on<AddWorkoutToHistory>((event, emit) {
      final updatedHistory = List<WorkoutHistoryItem>.from(state.history)..insert(0, event.item); // Most recent first
      emit(HistoryState(history: updatedHistory));
    });
    on<DeleteHistoryItem>((event, emit) {
      final updatedHistory = state.history.where((item) => item.id != event.id).toList();
      emit(HistoryState(history: updatedHistory));
    });
    on<ClearHistory>((event, emit) => emit(const HistoryState()));
  }

  @override
  HistoryState? fromJson(Map<String, dynamic> json) {
    final list = json['history'] as List?;
    if (list == null) return const HistoryState();
    return HistoryState(history: list.map((item) => WorkoutHistoryItem.fromJson(item)).toList());
  }

  @override
  Map<String, dynamic>? toJson(HistoryState state) {
    return {'history': state.history.map((item) => item.toJson()).toList()};
  }
}
