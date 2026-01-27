// lib/logic/bloc/history/history_state.dart

part of 'history_bloc.dart';

class HistoryState extends Equatable {
  /// The list of all completed workouts, ordered from newest to oldest.
  final List<WorkoutHistoryItem> history;

  const HistoryState({
    this.history = const [],
  });

  @override
  List<Object?> get props => [history];

  // Helper to check if the user has any history at all
  bool get isEmpty => history.isEmpty;

  // Helper to calculate total lifetime workout minutes
  int get totalLifetimeMinutes => history.fold(0, (sum, item) => sum + item.totalMinutes);
}