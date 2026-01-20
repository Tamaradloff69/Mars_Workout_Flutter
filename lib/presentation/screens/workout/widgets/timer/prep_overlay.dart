import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';

class PrepOverlay extends StatelessWidget {
  const PrepOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (previous, current) => previous.isPrep != current.isPrep || previous.elapsed != current.elapsed || previous.currentStageIndex != current.currentStageIndex,
      builder: (context, state) {
        final stageName = state.currentStage.name.toLowerCase();
        final isRestStage = stageName.contains('rest') || stageName.contains('recover');

        if (!state.isPrep && !isRestStage) return const SizedBox.shrink();

        final isPrep = state.isPrep;

        final maxDuration = isPrep ? Duration(seconds: state.currentStageIndex > 0 ? 10 : 5) : state.currentStage.duration;

        final timeLeft = maxDuration - state.elapsed;
        final secondsDisplay = timeLeft.inSeconds < 0 ? 0 : timeLeft.inSeconds;

        final progress = maxDuration.inMilliseconds > 0 ? state.elapsed.inMilliseconds / maxDuration.inMilliseconds : 0.0;

        final titleText = isPrep ? "GET READY" : "REST";
        final activeColor = isPrep ? Colors.orange : Colors.white;

        String nextUpName = "";
        if (isPrep) {
          nextUpName = state.currentStage.name;
        } else {
          final nextIndex = state.currentStageIndex + 1;
          if (nextIndex < state.stages.length) {
            nextUpName = state.stages[nextIndex].name;
          } else {
            nextUpName = "Finish";
          }
        }

        return Container(
          color: isRestStage ? Colors.lightBlueAccent : Colors.black.withValues(alpha: 0.9),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titleText,
                style: theme.textTheme.headlineMedium?.copyWith(color: activeColor, fontWeight: FontWeight.bold, letterSpacing: 3.0),
              ),
              const SizedBox(height: 40),

              // Big Circular Countdown
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Faint Background Circle
                    SizedBox.expand(
                      child: CircularProgressIndicator(value: 1.0, strokeWidth: 15, color: Colors.white.withValues(alpha: isRestStage ? 0.2 : 0.1)),
                    ),
                    // Animated Foreground Circle (Filling UP)
                    SizedBox.expand(
                      child: TweenAnimationBuilder<double>(
                        // Key ensures animation restarts smoothly on stage change
                        key: ValueKey('${state.currentStageIndex}_$isPrep'),
                        tween: Tween<double>(begin: 0.0, end: progress),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, _) => CircularProgressIndicator(value: value, strokeWidth: 15, color: activeColor, strokeCap: StrokeCap.round),
                      ),
                    ),
                    // The Number
                    Text(
                      "$secondsDisplay",
                      style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold, color: Colors.white, fontFeatures: [FontFeature.tabularFigures()]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Upcoming Stage Preview
              if (nextUpName.isNotEmpty) ...[
                Text("NEXT UP:", style: theme.textTheme.labelLarge?.copyWith(color: Colors.white54, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    nextUpName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
