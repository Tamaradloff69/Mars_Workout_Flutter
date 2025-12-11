import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_page.dart';

class WorkoutPreviewScreen extends StatelessWidget {
  final Workout workout;
  final String planDayId;
  final WorkoutType workoutType;

  const WorkoutPreviewScreen({
    super.key,
    required this.workout,
    required this.planDayId,
    required this.workoutType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalDuration = workout.stages.fold(
        Duration.zero,
            (prev, element) => prev + element.duration
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Workout Overview")),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to the actual Timer/Video screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<PlanBloc>(context),
                      child: WorkoutPage(
                        workout: workout,
                        planDayId: planDayId,
                        workoutType: workoutType,
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text("START WORKOUT"),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Text(
              workout.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "${totalDuration.inMinutes} minutes total",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              workout.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            // --- STAGES LIST ---
            Text(
              "WORKOUT STAGES",
              style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.grey,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 16),

            ListView.separated(
              physics: const NeverScrollableScrollPhysics(), // Scroll with whole page
              shrinkWrap: true,
              itemCount: workout.stages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final stage = workout.stages[index];

                // Styling based on stage type
                final isRest = stage.name.toLowerCase().contains('rest') ||
                    stage.name.toLowerCase().contains('recover');
                final isWarmup = stage.name.toLowerCase().contains('warm');


                if (isRest) {
                } else if (isWarmup) {
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Duration Box
                      Container(
                        width: 60,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${stage.duration.inMinutes}:${(stage.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "min",
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stage.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isRest ? Colors.grey[700] : Colors.black,
                              ),
                            ),
                            if (stage.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                stage.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}