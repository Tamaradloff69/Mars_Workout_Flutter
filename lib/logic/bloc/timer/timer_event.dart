part of 'timer_bloc.dart';

class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class StartTimer extends TimerEvent {}

class PauseTimer extends TimerEvent {}

class ResetTimer extends TimerEvent {}

class NextStage extends TimerEvent {}

class TimerTicked extends TimerEvent {
  final Duration elapsed;

  const TimerTicked(this.elapsed);

  @override
  List<Object> get props => [elapsed];
}
