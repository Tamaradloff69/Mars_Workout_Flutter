import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/core/services/audio_service.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/repositories/misc/gif_repository.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_completion_screen.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutType workoutType;
  final Workout workout;
  final String planDayId;

  const WorkoutDetailScreen({super.key, required this.workout, required this.planDayId, required this.workoutType});

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.workout.title),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            final totalDuration = state.currentStage.duration.inSeconds;
            final elapsed = state.elapsed.inSeconds;
            final timeLeft = totalDuration - elapsed;

            // 1. Play Countdown
            if (!state.isPrep && timeLeft <= 3 && timeLeft > 0) {
              SoundService().playCountdown();
            }

            // 2. Workout Finished Logic
            if (state.isFinished) {
              context.read<PlanBloc>().add(MarkDayAsCompleted(widget.planDayId));

              final planBlocState = context.read<PlanBloc>().state;
              final completedIds = Set<String>.from(planBlocState.completedDayIds);
              completedIds.add(widget.planDayId);

              bool isWeekFinished = false;
              bool isPlanFinished = false;
              final allPlans = WorkoutRepository().getAllPlans();

              // --- FIX: Get the active plan ID for THIS workout type ---
              String? activePlanId = planBlocState.activePlans[widget.workoutType.toString()];

              if (activePlanId != null) {
                try {
                  final currentPlan = allPlans.firstWhere((p) => p.id == activePlanId);

                  isPlanFinished = currentPlan.weeks.every((week) =>
                      week.days.every((day) => completedIds.contains(day.id))
                  );

                  if (!isPlanFinished) {
                    for (var week in currentPlan.weeks) {
                      if (week.days.any((d) => d.id == widget.planDayId)) {
                        isWeekFinished = week.days.every((d) => completedIds.contains(d.id));
                        break;
                      }
                    }
                    if (isWeekFinished) {
                      SoundService().playWeekComplete();
                    }
                    else {
                      SoundService().playWorkoutComplete();
                    }
                  } else {
                    SoundService().playCompleteTraining();

                  }
                } catch (e) {
                  print("Plan lookup error: $e");
                }
              }

              int totalMins = 0;
              for (var s in widget.workout.stages) {
                totalMins += s.duration.inMinutes;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => WorkoutCompletedScreen(
                  workoutTitle: widget.workout.title,
                  totalMinutes: totalMins,
                  isWeekComplete: isWeekFinished,
                  isPlanComplete: isPlanFinished,
                )),
              );
            }
          },
          child: Column(
            children: [
              // --- 1. TOP SECTION: GIF ANIMATION ---
              Expanded(
                flex: 5,
                child: BlocBuilder<TimerBloc, TimerState>(
                  buildWhen: (previous, current) =>
                  previous.currentStageIndex != current.currentStageIndex,
                  builder: (context, state) {
                    final gifUrl = GifRepository.getGifUrl(
                        widget.workoutType,
                        state.currentStage.name
                    );

                    return Container(
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Image.network(
                        gifUrl,
                        fit: BoxFit.contain,
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
                      SizedBox(height: 16),
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
            // Segment Bar
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
              maxLines: 99, // Allow full zone descriptions to show
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

class _TimerControls extends StatelessWidget {
  const _TimerControls();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
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
              SizedBox(
                width: 50,
                height: 50,
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
      ),
    );
  }
}