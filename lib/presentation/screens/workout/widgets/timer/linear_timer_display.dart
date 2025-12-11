import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';

class LinearTimerDisplay extends StatelessWidget {
  const LinearTimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final isPrep = state.isPrep;
        final maxDuration = isPrep
            ? const Duration(seconds: 5)
            : state.currentStage.duration;

        final timeLeft = maxDuration - state.elapsed;
        final secondsDisplay = timeLeft.inSeconds < 0 ? 0 : timeLeft.inSeconds;

        final displayColor = isPrep ? Colors.orange : theme.primaryColor;
        final labelText = isPrep ? "GET READY" : "WORK";

        double progress = 0.0;
        if (maxDuration.inSeconds > 0) {
          progress = state.elapsed.inSeconds / maxDuration.inSeconds;
        }

        return Column(
          children: [
            Text(
              labelText,
              style: theme.textTheme.labelLarge?.copyWith(
                color: displayColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              isPrep
                  ? "$secondsDisplay"
                  : '${(secondsDisplay / 60).floor().toString().padLeft(2, '0')}:${(secondsDisplay % 60).toString().padLeft(2, '0')}',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 80,
                fontWeight: FontWeight.w800,
                color: displayColor,
                height: 1.0,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 24),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade100,
                  color: displayColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
