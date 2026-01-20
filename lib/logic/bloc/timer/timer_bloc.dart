import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

part 'timer_event.dart';
part 'timer_state.dart';

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
    if (state.isRunning) return;

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
    final int prepDurationSeconds = (state.currentStageIndex > 0) ? 10 : 5; // 5 Seconds "Get Ready" time

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
    // 1. Check if workout is finished
    if (state.isLastStage) {
      _tickerSubscription?.cancel();
      // Force elapsed to duration so UI shows 100% complete before navigating
      emit(state.copyWith(isRunning: false, elapsed: state.currentStage.duration));
      return;
    }

    // 2. Identify the next stage
    final nextIndex = state.currentStageIndex + 1;
    final nextStage = state.stages[nextIndex];

    // 3. Check if the next stage is a "Rest" stage
    // We check for "rest" or "recover" to be safe
    final isRestStage = nextStage.name.toLowerCase().contains('rest') || nextStage.name.toLowerCase().contains('recover') || nextStage.name.toLowerCase().contains('cool');

    // 4. Transition
    emit(
      state.copyWith(
        currentStageIndex: nextIndex,
        elapsed: Duration.zero,
        // If it is a rest stage, SKIP prep (isPrep = false).
        // Otherwise, show prep (isPrep = true).
        isPrep: !isRestStage,
      ),
    );
  }
}
