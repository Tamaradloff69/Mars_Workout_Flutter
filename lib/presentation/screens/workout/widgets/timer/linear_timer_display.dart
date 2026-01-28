import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/workout_helper.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';

class LinearTimerDisplay extends StatelessWidget {
  const LinearTimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (previous, current) => 
            previous.elapsed != current.elapsed || 
            previous.currentStageIndex != current.currentStageIndex,
        builder: (context, state) {
          final maxDuration = state.currentStage.duration;
          final isCountdown = WorkoutHelper.isCountdownStage(state.currentStage);

          // For countdown stages, show time remaining (countdown)
          // For work stages, show time remaining (count down to zero)
          final durationToShow = maxDuration - state.elapsed;
          final secondsDisplay = durationToShow.inSeconds < 0 ? 0 : durationToShow.inSeconds;

          // Progress bar fills up as time elapses
          double progress = 0.0;
          if (maxDuration.inSeconds > 0) {
            progress = state.elapsed.inSeconds / maxDuration.inSeconds;
          }

          // Use orange color for countdown stages
          final timerColor = isCountdown ? Colors.orange : theme.primaryColor;

          return Column(
            children: [
              Text(
                '${(secondsDisplay / 60).floor().toString().padLeft(2, '0')}:${(secondsDisplay % 60).toString().padLeft(2, '0')}',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 80, 
                  fontWeight: FontWeight.w800, 
                  color: timerColor, 
                  height: 1.0, 
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 24),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 12,
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey('stage_${state.currentStageIndex}'),
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.linear,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value, 
                      backgroundColor: Colors.grey.shade100, 
                      color: timerColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
