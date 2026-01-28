part of 'workout_session_bloc.dart';

abstract class WorkoutSessionEvent extends Equatable {
  const WorkoutSessionEvent();

  @override
  List<Object?> get props => [];
}

class SaveWorkoutSession extends WorkoutSessionEvent {
  final WorkoutSession session;

  const SaveWorkoutSession(this.session);

  @override
  List<Object?> get props => [session];
}

class ClearWorkoutSession extends WorkoutSessionEvent {
  const ClearWorkoutSession();
}
