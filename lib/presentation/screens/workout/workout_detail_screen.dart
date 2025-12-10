// Needed for FontFeature
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
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
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(widget.workout.title),
        ),
        body: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state.isFinished) {
              context.read<PlanBloc>().add(MarkDayAsCompleted(widget.planDayId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Workout Completed!")),
              );
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _StageSegmentBar(),
                const SizedBox(height: 32),

                // --- DYNAMIC DESCRIPTION BOX ---
                BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    // Check if workout has started (running, elapsed time > 0, or past first stage)
                    final hasStarted = state.isRunning || state.elapsed > Duration.zero || state.currentStageIndex > 0;

                    // Switch text based on state
                    final String textToShow = hasStarted
                        ? state.currentStage.description
                        : widget.workout.description;

                    // Fallback if stage description is empty
                    final String displayText = textToShow.isEmpty
                        ? "Maintain target intensity."
                        : textToShow;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      // Animate the size change if text length varies significantly
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.topCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon switches to indicate "Active Instruction" vs "General Info"
                            Icon(
                                hasStarted ? Icons.lightbulb_outline : Icons.info_outline,
                                color: theme.primaryColor,
                                size: 24
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                displayText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                                  height: 1.4, // Good line height for reading instructions
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // --------------------------------

                const Expanded(child: Center(child: _CircularTimerDisplay())),
                const SizedBox(height: 32),
                const _TimerControls(),
                const SizedBox(height: 24),
                const _StageTracker(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ... (Rest of the file remains unchanged: _StageSegmentBar, _CircularTimerDisplay, etc.)
// ... Ensure _CircularTimerDisplay still exists as provided in previous steps.

class _StageSegmentBar extends StatelessWidget {
  const _StageSegmentBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          children: List.generate(state.stages.length, (index) {
            Color color;
            if (index < state.currentStageIndex) {
              color = theme.colorScheme.tertiary;
            } else if (index == state.currentStageIndex) {
              color = theme.primaryColor;
            } else {
              color = theme.disabledColor.withValues(alpha: 0.2);
            }

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _CircularTimerDisplay extends StatelessWidget {
  const _CircularTimerDisplay();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final currentStage = state.currentStage;
        final totalSeconds = currentStage.duration.inSeconds;
        final elapsedSeconds = state.elapsed.inSeconds;

        double progress = totalSeconds > 0 ? 1.0 - (elapsedSeconds / totalSeconds) : 1.0;

        final duration = currentStage.duration - state.elapsed;
        final minutes = (duration.inSeconds / 60).floor().toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        return SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 15,
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
              Transform.rotate(
                angle: 0,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 15,
                  strokeCap: StrokeCap.round,
                  color: progress < 0.2 ? theme.colorScheme.error : theme.primaryColor,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentStage.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$minutes:$seconds',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 56,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                    // Note: Removed stage description from here since it's now at the top
                  ],
                ),
              ),
            ],
          ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                if (state.isRunning) {
                  context.read<TimerBloc>().add(PauseTimer());
                } else {
                  context.read<TimerBloc>().add(StartTimer());
                }
              },
              backgroundColor: state.isRunning ? Colors.amber : theme.primaryColor,
              child: Icon(
                state.isRunning ? Icons.pause : Icons.play_arrow,
                size: 42,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 32),
            Container(
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.skip_next_rounded),
                color: theme.iconTheme.color,
                onPressed: () => context.read<TimerBloc>().add(NextStage()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StageTracker extends StatelessWidget {
  const _StageTracker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state.upcomingStages.isEmpty) {
          return Center(
            child: Text(
              "Final Stage!",
              style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          );
        }

        final next = state.upcomingStages.first;

        return Column(
          children: [
            Text(
              "NEXT UP",
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: theme.disabledColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              next.name,
              style: theme.textTheme.titleMedium,
            ),
          ],
        );
      },
    );
  }
}