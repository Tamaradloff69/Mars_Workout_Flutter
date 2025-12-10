import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'timer_event.dart';
import 'timer_state.dart';

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

  void _onNextStage(NextStage event, Emitter<TimerState> emit) {
    if (state.isLastStage) {
      // This can signify the end of the workout
      _tickerSubscription?.cancel();
      emit(state.copyWith(isRunning: false, elapsed: state.currentStage.duration)); // Mark as finished
      return;
    }

    emit(state.copyWith(currentStageIndex: state.currentStageIndex + 1, elapsed: Duration.zero));
  }

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.elapsed >= state.currentStage.duration) {
      add(NextStage()); // Auto-advance to next stage
    } else {
      emit(state.copyWith(elapsed: event.elapsed));
    }
  }
}
