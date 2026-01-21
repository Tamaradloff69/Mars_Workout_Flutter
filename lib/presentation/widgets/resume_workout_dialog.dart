import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/workout_session.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/workout_session/workout_session_bloc.dart';
import 'package:mars_workout_app/logic/cubit/workout_video_cubit.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_page.dart';
import 'package:mars_workout_app/presentation/widgets/session_info_card.dart';

class ResumeWorkoutDialog extends StatelessWidget {
  final WorkoutSession session;

  const ResumeWorkoutDialog({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        spacing: 12,
        children: [
          Icon(Icons.restart_alt_rounded, color: theme.primaryColor, size: 28),
          const Expanded(
            child: Text(
              'Resume Workout?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have an unfinished workout session. Would you like to continue where you left off?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SessionInfoCard(session: session),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () {
            context.read<WorkoutSessionBloc>().add(const ClearWorkoutSession());
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text('Clear'),
        ),
        ElevatedButton(
          onPressed: () => _handleResume(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Resume'),
        ),
      ],
    );
  }

  void _handleResume(BuildContext context) {
    // Capture dependencies before popping the dialog context
    final planBloc = context.read<PlanBloc>();
    final sessionBloc = context.read<WorkoutSessionBloc>();
    final navigator = Navigator.of(context);

    // Initialize and restore TimerBloc state
    final timerBloc = TimerBloc(session.workout.stages);
    timerBloc.add(RestoreTimer(
      currentStageIndex: session.currentStageIndex,
      elapsed: session.elapsed,
    ));

    // Close the dialog
    navigator.pop();

    // Navigate to the workout page
    navigator.push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: planBloc),
            BlocProvider.value(value: sessionBloc),
            BlocProvider<TimerBloc>.value(value: timerBloc),
            BlocProvider<WorkoutVideoCubit>(create: (_) => WorkoutVideoCubit()),
          ],
          child: WorkoutPage(
            workout: session.workout,
            planDayId: session.planDayId,
            workoutType: session.workoutType,
          ),
        ),
      ),
    );
  }
}
