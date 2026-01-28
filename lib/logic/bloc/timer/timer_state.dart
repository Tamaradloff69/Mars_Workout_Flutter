part of 'timer_bloc.dart';

class TimerState extends Equatable {
  final List<WorkoutStage> stages;
  final int currentStageIndex;
  final Duration elapsed;
  final bool isRunning;

  const TimerState({
    required this.stages,
    required this.currentStageIndex,
    required this.elapsed,
    required this.isRunning,
  });

  factory TimerState.initial(List<WorkoutStage> stages) {
    return TimerState(
      stages: stages,
      currentStageIndex: 0,
      elapsed: Duration.zero,
      isRunning: false,
    );
  }

  TimerState copyWith({List<WorkoutStage>? stages, int? currentStageIndex, Duration? elapsed, bool? isRunning}) {
    return TimerState(
      stages: stages ?? this.stages, 
      currentStageIndex: currentStageIndex ?? this.currentStageIndex, 
      elapsed: elapsed ?? this.elapsed, 
      isRunning: isRunning ?? this.isRunning,
    );
  }

  // Helpers
  WorkoutStage get currentStage => stages[currentStageIndex];
  bool get isLastStage => currentStageIndex >= stages.length - 1;
  bool get isFinished => isLastStage && elapsed >= currentStage.duration;

  @override
  List<Object?> get props => [stages, currentStageIndex, elapsed, isRunning];
}
