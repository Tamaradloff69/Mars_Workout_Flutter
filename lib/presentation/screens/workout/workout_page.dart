import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/core/services/audio_service.dart';
import 'package:mars_workout_app/core/services/workout_completion_service.dart';
import 'package:mars_workout_app/data/models/workout_history_item.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/models/workout_session.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';
import 'package:mars_workout_app/logic/bloc/history/history_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/workout_session/workout_session_bloc.dart';
import 'package:mars_workout_app/presentation/screens/workout/completion/workout_completion_screen.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_screen.dart';

class WorkoutPage extends StatefulWidget {
  final Workout workout;
  final String planDayId;
  final WorkoutType workoutType;

  const WorkoutPage({super.key, required this.workout, required this.planDayId, required this.workoutType});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Save workout state when app goes to background or paused
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveWorkoutSession();
    }
  }

  void _saveWorkoutSession() {
    final timerBloc = context.read<TimerBloc>();
    final timerState = timerBloc.state;

    // Only save if workout is not actually finished to prevent "zombie" resumes
    if (!timerState.isFinished) {
      final session = WorkoutSession(workout: widget.workout, planDayId: widget.planDayId, workoutType: widget.workoutType, currentStageIndex: timerState.currentStageIndex, elapsed: timerState.elapsed, isRunning: timerState.isRunning, savedAt: DateTime.now());

      context.read<WorkoutSessionBloc>().add(SaveWorkoutSession(session));
    }
  }

  /// Critical handler for workout completion to ensure persistence
  Future<void> _handleWorkoutCompletion(BuildContext context, TimerState state) async {
    // 1. Calculate stats immediately
    final totalMins = widget.workout.stages.fold(0, (sum, s) => sum + s.duration.inMinutes);

    // 2. CRITICAL: Clear the resume session first so the user isn't prompted to resume
    // a finished workout if the app crashes during the next steps.
    context.read<WorkoutSessionBloc>().add(const ClearWorkoutSession());

    // 3. CRITICAL: Mark progress in the PlanBloc.
    // This adds widget.planDayId to the completedDayIds set.
    context.read<PlanBloc>().add(MarkDayAsCompleted(widget.planDayId));

    // 4. Log to History
    context.read<HistoryBloc>().add(AddWorkoutToHistory(WorkoutHistoryItem(id: DateTime.now().millisecondsSinceEpoch.toString(), workoutTitle: widget.workout.title, type: widget.workoutType, completedAt: DateTime.now(), totalMinutes: totalMins)));

    // 5. Determine Completion Sound/Status using current snapshot of state
    final allPlans = WorkoutRepository().getAllPlans();
    final planBlocState = context.read<PlanBloc>().state;

    // We manually add the ID to the set for the check logic just in case
    // the state hasn't fully propagated to the check service yet.
    final completedIdsSnapshot = Set<String>.from(planBlocState.completedDayIds)..add(widget.planDayId);

    final activePlanId = planBlocState.activePlans[widget.workoutType.toString()];

    final completionStatus = WorkoutCompletionService().checkCompletion(completedDayId: widget.planDayId, completedDayIds: completedIdsSnapshot, allPlans: allPlans, workoutType: widget.workoutType, activePlanId: activePlanId);

    // Play appropriate sound
    if (completionStatus.isPlanComplete) {
      await SoundService().playTrainingPlanComplete();
    } else if (completionStatus.isWeekComplete) {
      await SoundService().playWeekComplete();
    } else {
      await SoundService().playWorkoutComplete();
    }

    // 6. PERSISTENCE INSURANCE:
    // Give HydratedBloc a tiny window (250ms) to finish disk I/O before we
    // navigate away and potentially allow the user to kill the app.
    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    // 7. Navigate to Completion Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutCompletedScreen(workoutTitle: widget.workout.title, totalMinutes: totalMins, isWeekComplete: completionStatus.isWeekComplete, isPlanComplete: completionStatus.isPlanComplete),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Interval Auto-saver (every 5 seconds)
        BlocListener<TimerBloc, TimerState>(
          listenWhen: (previous, current) {
            return (current.elapsed.inSeconds % 5 == 0 && current.elapsed.inSeconds != 0) || previous.currentStageIndex != current.currentStageIndex;
          },
          listener: (context, state) {
            if (!state.isFinished) {
              _saveWorkoutSession();
            }
          },
        ),

        // THE FINAL COMPLETION LISTENER
        BlocListener<TimerBloc, TimerState>(listenWhen: (previous, current) => !previous.isFinished && current.isFinished, listener: (context, state) => _handleWorkoutCompletion(context, state)),
      ],
      child: WorkoutScreen(workout: widget.workout, planDayId: widget.planDayId, workoutType: widget.workoutType),
    );
  }
}
