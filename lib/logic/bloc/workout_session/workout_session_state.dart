part of 'workout_session_bloc.dart';

class WorkoutSessionState extends Equatable {
  final WorkoutSession? session;

  const WorkoutSessionState({this.session});

  bool get hasSession => session != null;

  @override
  List<Object?> get props => [session];
}
