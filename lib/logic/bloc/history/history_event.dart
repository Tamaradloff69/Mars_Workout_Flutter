// lib/logic/bloc/history/history_event.dart

part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}
class RemovePlanFromHistory extends HistoryEvent {
  final TrainingPlan plan;
  const RemovePlanFromHistory(this.plan);
}
/// Dispatched when a workout is finished to permanently log it.
class AddWorkoutToHistory extends HistoryEvent {
  final WorkoutHistoryItem item;

  const AddWorkoutToHistory(this.item);

  @override
  List<Object?> get props => [item];
}

class SyncCompletedWorkouts extends HistoryEvent {
  final Set<String> completedDayIds;

  const SyncCompletedWorkouts(this.completedDayIds);

  @override
  List<Object?> get props => [completedDayIds];
}
class DeleteHistoryItem extends HistoryEvent {
  final String id;

  const DeleteHistoryItem(this.id);

  @override
  List<Object?> get props => [id];
}
/// Dispatched if the user wants to reset their entire workout log.
class ClearHistory extends HistoryEvent {
  const ClearHistory();
}