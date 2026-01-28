import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_helper.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_preview/workout_preview_screen.dart';

class WorkoutSelectionScreen extends StatelessWidget {
  final String title;
  final String planDayId;
  final List<Workout> options;
  final WorkoutType workoutType;

  const WorkoutSelectionScreen({super.key, required this.title, required this.planDayId, required this.options, this.workoutType = WorkoutType.cycling});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Choose your variation for today:", style: theme.textTheme.bodyLarge),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final workout = options[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: theme.dividerColor),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<PlanBloc>(context),
                            child: WorkoutPreviewScreen(
                              workout: workout, // The specific option selected
                              planDayId: planDayId,
                              workoutType: workoutType,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(workout.title, style: theme.textTheme.titleMedium)),
                              Icon(Icons.arrow_forward_ios, size: 16, color: theme.primaryColor),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(workout.description, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 16, color: theme.disabledColor),
                              const SizedBox(width: 6),
                              Text("${_calculateTotalDuration(workout)} mins", style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotalDuration(Workout workout) {
    // Use the helper to get the real stage list that will be used during the workout
    final stagesWithCountdown = WorkoutHelper.addCountdownStages(workout.stages);

    int totalSeconds = 0;
    for (var stage in stagesWithCountdown) {
      totalSeconds += stage.duration.inSeconds;
    }

    // Round to the nearest minute for display
    return (totalSeconds / 60).round();
  }
}
