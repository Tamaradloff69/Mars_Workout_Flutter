part of 'timer_bloc.dart';

class TimerState extends Equatable {
  final List<WorkoutStage> stages;
  final int currentStageIndex;
  final Duration elapsed;
  final bool isRunning;
  final bool isPrep; // <--- NEW: Tracks if we are in "Get Ready" mode

  const TimerState({
    required this.stages,
    required this.currentStageIndex,
    required this.elapsed,
    required this.isRunning,
    this.isPrep = true, // Default to true so workout starts with "Get Ready"
  });

  factory TimerState.initial(List<WorkoutStage> stages) {
    return TimerState(
      stages: stages,
      currentStageIndex: 0,
      elapsed: Duration.zero,
      isRunning: false,
      isPrep: true, // Start with prep
    );
  }

  TimerState copyWith({List<WorkoutStage>? stages, int? currentStageIndex, Duration? elapsed, bool? isRunning, bool? isPrep}) {
    return TimerState(stages: stages ?? this.stages, currentStageIndex: currentStageIndex ?? this.currentStageIndex, elapsed: elapsed ?? this.elapsed, isRunning: isRunning ?? this.isRunning, isPrep: isPrep ?? this.isPrep);
  }

  // Helpers
  WorkoutStage get currentStage => stages[currentStageIndex];
  bool get isLastStage => currentStageIndex >= stages.length - 1;
  // Finished only if it's the last stage AND we are done with work (not prep)
  bool get isFinished => isLastStage && !isPrep && elapsed >= currentStage.duration;

  @override
  List<Object?> get props => [stages, currentStageIndex, elapsed, isRunning, isPrep];
}
