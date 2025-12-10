import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc(List<WorkoutStage> stages) : super(TimerState.initial(stages)) {
    on<StartTimer>(_onStartTimer);
    on<PauseTimer>(_onPauseTimer);
    on<ResetTimer>(_onResetTimer);
    on<NextStage>(_onNextStage);
    on<TimerTicked>(_onTimerTicked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
    if (state.isRunning) return; // Already running

    _tickerSubscription?.cancel();
    _tickerSubscription = Stream.periodic(const Duration(seconds: 1), (x) => x).listen((tick) => add(TimerTicked(state.elapsed + const Duration(seconds: 1))));

    emit(state.copyWith(isRunning: true));
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  void _onResetTimer(ResetTimer event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerState.initial(state.stages));
  }

  // Inside _onTimerTicked method:

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    const int prepDurationSeconds = 5; // 5 Seconds "Get Ready" time

    // 1. Handle "Get Ready" Phase
    if (state.isPrep) {
      if (state.elapsed.inSeconds >= prepDurationSeconds) {
        // Prep is done! Switch to Work.
        emit(state.copyWith(isPrep: false, elapsed: Duration.zero));
      } else {
        // Continue Prep countdown
        emit(state.copyWith(elapsed: event.elapsed));
      }
      return;
    }

    // 2. Handle "Work" Phase
    if (event.elapsed >= state.currentStage.duration) {
      add(NextStage());
    } else {
      emit(state.copyWith(elapsed: event.elapsed));
    }
  }

// Inside _onNextStage method:
  void _onNextStage(NextStage event, Emitter<TimerState> emit) {
    if (state.isLastStage) {
      _tickerSubscription?.cancel();
      // Force elapsed to duration so UI shows 100% complete before navigating
      emit(state.copyWith(isRunning: false, elapsed: state.currentStage.duration));
      return;
    }

    // Move to next stage, BUT start in "Prep" mode again
    // Exception: If next stage is "Rest", maybe skip prep?
    // For now, let's keep it simple: Prep before everything.
    emit(state.copyWith(
      currentStageIndex: state.currentStageIndex + 1,
      elapsed: Duration.zero,
      isPrep: true, // Reset to Get Ready mode
    ));
  }
}
