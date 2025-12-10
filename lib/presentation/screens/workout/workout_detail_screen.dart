import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/repositories/misc/gif_repository.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;
  final String planDayId;

  const WorkoutDetailScreen({super.key, required this.workout, required this.planDayId});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => TimerBloc(widget.workout.stages),
      child: Scaffold(
        backgroundColor: Colors.white, // Clean background for the GIF
        appBar: AppBar(
          title: Text(widget.workout.title),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        extendBodyBehindAppBar: true, // Allow GIF to go behind App Bar if desired
        body: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state.isFinished) {
              context.read<PlanBloc>().add(MarkDayAsCompleted(widget.planDayId));
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              // --- 1. TOP SECTION: GIF ANIMATION ---
              Expanded(
                flex: 5, // Takes up top 50% roughly
                child: BlocBuilder<TimerBloc, TimerState>(
                  buildWhen: (previous, current) =>
                  previous.currentStageIndex != current.currentStageIndex,
                  builder: (context, state) {
                    final gifUrl = GifRepository.getGifUrl(
                        widget.workout.title,
                        state.currentStage.name
                    );

                    return Container(
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Image.network(
                        gifUrl,
                        fit: BoxFit.cover,
                        // Add a loading builder for smoother transitions
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator(color: theme.primaryColor));
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.fitness_center, size: 64, color: Colors.grey)),
                      ),
                    );
                  },
                ),
              ),

              // --- 2. BOTTOM SECTION: CONTROLS & TIMER ---
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StageInfoAndSegmentBar(),
                      Spacer(),
                      _LinearTimerDisplay(),
                      SizedBox(height: 32),
                      _TimerControls(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageInfoAndSegmentBar extends StatelessWidget {
  const _StageInfoAndSegmentBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Column(
          children: [
            // Segment Bar (Total Progress)
            SizedBox(
              height: 4,
              child: Row(
                children: List.generate(state.stages.length, (index) {
                  Color color;
                  if (index < state.currentStageIndex) {
                    color = theme.primaryColor;
                  } else if (index == state.currentStageIndex) {
                    color = theme.primaryColor;
                  } else {
                    color = Colors.grey.shade200;
                  }
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Stage Name & Instructions
            Text(
              state.currentStage.name.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.currentStage.description.isNotEmpty
                  ? state.currentStage.description
                  : "Keep pushing!",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        );
      },
    );
  }
}

class _LinearTimerDisplay extends StatelessWidget {
  const _LinearTimerDisplay();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final totalSeconds = state.currentStage.duration.inSeconds;
        final elapsedSeconds = state.elapsed.inSeconds;
        // Linear Progress: 0.0 to 1.0 (fills up)
        double progress = totalSeconds > 0 ? (elapsedSeconds / totalSeconds) : 0.0;

        final duration = state.currentStage.duration - state.elapsed;
        final minutes = (duration.inSeconds / 60).floor().toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        return Column(
          children: [
            // Big Countdown Text
            Text(
              '$minutes:$seconds',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 80,
                fontWeight: FontWeight.w800,
                color: theme.textTheme.bodyLarge?.color,
                height: 1.0,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 24),

            // Linear Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade100,
                  color: progress > 0.8 ? theme.colorScheme.error : theme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TimerControls extends StatelessWidget {
  const _TimerControls();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pause/Play Button
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    if (state.isRunning) {
                      context.read<TimerBloc>().add(PauseTimer());
                    } else {
                      context.read<TimerBloc>().add(StartTimer());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.isRunning ? Colors.amber.shade100 : theme.primaryColor,
                    foregroundColor: state.isRunning ? Colors.amber.shade900 : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(state.isRunning ? "PAUSE" : "START WORKOUT"),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Skip Button
            SizedBox(
              width: 64,
              height: 64,
              child: OutlinedButton(
                onPressed: () => context.read<TimerBloc>().add(NextStage()),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.skip_next, color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }
}