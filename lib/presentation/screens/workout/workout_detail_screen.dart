import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;
  final String planDayId;

  const WorkoutDetailScreen({super.key, required this.workout, required this.planDayId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(workout.stages),
      child: Scaffold(
        appBar: AppBar(title: Text(workout.title)),
        body: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state.isFinished) {
              context.read<PlanBloc>().add(MarkDayAsCompleted(planDayId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Workout Completed!")),
              );
              // Optionally navigate back or show a summary
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(workout.description, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 24),
                  const _TimerDisplay(),
                  const SizedBox(height: 24),
                  const _TimerControls(),
                  const SizedBox(height: 24),
                  const _StageTracker(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  const _TimerDisplay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final duration = state.currentStage.duration - state.elapsed;
        final minutes = (duration.inSeconds / 60).floor().toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        return Column(
          children: [
            Text(
              state.currentStage.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$minutes:$seconds',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
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
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.isRunning)
              IconButton(
                icon: const Icon(Icons.pause, size: 48),
                onPressed: () => context.read<TimerBloc>().add(PauseTimer()),
              )
            else
              IconButton(
                icon: const Icon(Icons.play_arrow, size: 48),
                onPressed: () => context.read<TimerBloc>().add(StartTimer()),
              ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.skip_next, size: 48),
              onPressed: () => context.read<TimerBloc>().add(NextStage()),
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
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Next Up", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...state.upcomingStages.map((stage) => Text(
              stage.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            )),
          ],
        );
      },
    );
  }
}
