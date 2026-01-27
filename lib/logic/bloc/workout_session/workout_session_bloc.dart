import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/data/models/workout_session.dart';

part 'workout_session_event.dart';
part 'workout_session_state.dart';

/// Manages the saved workout session for resume functionality
class WorkoutSessionBloc extends HydratedBloc<WorkoutSessionEvent, WorkoutSessionState> {
  WorkoutSessionBloc() : super(const WorkoutSessionState()) {
    on<SaveWorkoutSession>(_onSaveWorkoutSession);
    on<ClearWorkoutSession>(_onClearWorkoutSession);
  }

  void _onSaveWorkoutSession(SaveWorkoutSession event, Emitter<WorkoutSessionState> emit) {
    emit(WorkoutSessionState(session: event.session));
  }

  void _onClearWorkoutSession(ClearWorkoutSession event, Emitter<WorkoutSessionState> emit) {
    emit(const WorkoutSessionState());
  }

  @override
  WorkoutSessionState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['session'] == null) {
        return const WorkoutSessionState();
      }
      final session = WorkoutSession.fromJson(json['session']);
      // Only restore if the session is still valid
      if (session.isValid()) {
        return WorkoutSessionState(session: session);
      }
      return const WorkoutSessionState();
    } catch (e) {
      debugPrint('Error loading workout session: $e');
      return const WorkoutSessionState();
    }
  }

  @override
  Map<String, dynamic>? toJson(WorkoutSessionState state) {
    try {
      if (state.session == null) {
        return null;
      }
      return {'session': state.session!.toJson()};
    } catch (e) {
      debugPrint('Error saving workout session: $e');
      return null;
    }
  }
}
