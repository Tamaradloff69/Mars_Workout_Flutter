import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/core/services/audio_service.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';
import 'package:mars_workout_app/presentation/screens/workout/completion/workout_completion_screen.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_screen.dart';

class WorkoutPage extends StatelessWidget {
  final Workout workout;
  final String planDayId;
  final WorkoutType workoutType;

  const WorkoutPage({super.key, required this.workout, required this.planDayId, required this.workoutType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimerBloc>(
      create: (context) => TimerBloc(workout.stages),
      child: BlocListener<TimerBloc, TimerState>(
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
            context.read<PlanBloc>().add(MarkDayAsCompleted(planDayId));

            final planBlocState = context.read<PlanBloc>().state;
            final completedIds = Set<String>.from(planBlocState.completedDayIds);
            completedIds.add(planDayId);

            bool isWeekFinished = false;
            bool isPlanFinished = false;
            final allPlans = WorkoutRepository().getAllPlans();

            // --- FIX: Get the active plan ID for THIS workout type ---
            String? activePlanId = planBlocState.activePlans[workoutType.toString()];

            if (activePlanId != null) {
              try {
                final currentPlan = allPlans.firstWhere((p) => p.id == activePlanId);

                isPlanFinished = currentPlan.weeks.every((week) =>
                    week.days.every((day) => completedIds.contains(day.id))
                );

                if (!isPlanFinished) {
                  for (var week in currentPlan.weeks) {
                    if (week.days.any((d) => d.id == planDayId)) {
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
                  SoundService().playTrainingPlanComplete();

                }
              } catch (e) {
                print("Plan lookup error: $e");
              }
            }

            int totalMins = 0;
            for (var s in workout.stages) {
              totalMins += s.duration.inMinutes;
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WorkoutCompletedScreen(
                workoutTitle: workout.title,
                totalMinutes: totalMins,
                isWeekComplete: isWeekFinished,
                isPlanComplete: isPlanFinished,
              )),
            );
          }
        },

        child: WorkoutScreen(workout: workout, planDayId: planDayId, workoutType: workoutType),
      ),
    );
  }
}
