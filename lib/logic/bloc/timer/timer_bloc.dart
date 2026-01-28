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
    on<RestoreTimer>(_onRestoreTimer);
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

  void _onRestoreTimer(RestoreTimer event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(state.copyWith(
      currentStageIndex: event.currentStageIndex,
      elapsed: event.elapsed,
      isRunning: false, // Start paused
    ));
  }

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.elapsed >= state.currentStage.duration) {
      add(NextStage());
    } else {
      emit(state.copyWith(elapsed: event.elapsed));
    }
  }

  void _onNextStage(NextStage event, Emitter<TimerState> emit) {
    // Check if workout is finished
    if (state.isLastStage) {
      _tickerSubscription?.cancel();
      // Force elapsed to duration so UI shows 100% complete before navigating
      emit(state.copyWith(isRunning: false, elapsed: state.currentStage.duration));
      return;
    }

    // Move to next stage
    emit(
      state.copyWith(
        currentStageIndex: state.currentStageIndex + 1,
        elapsed: Duration.zero,
      ),
    );
  }
}
