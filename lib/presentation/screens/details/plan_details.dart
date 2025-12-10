import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/repositories/workout_repository.dart'; // Import Repository
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_state.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_detail_screen.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_selection.dart';

class PlanDetailScreen extends StatelessWidget {
  final TrainingPlan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              plan.description,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<PlanBloc, PlanState>(
              builder: (context, state) {
                if (state.activePlanId != plan.id) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PlanBloc>().add(StartPlan(plan.id));
                      },
                      child: const Text("Start this Plan"),
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    "You are currently working on this plan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: plan.weeks.length,
              itemBuilder: (context, index) {
                final week = plan.weeks[index];
                return Theme(
                  data: theme.copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      "Week ${week.weekNumber}",
                      style: theme.textTheme.titleMedium,
                    ),
                    initiallyExpanded: index == 0,
                    children: week.days.map((day) {
                      return BlocBuilder<PlanBloc, PlanState>(
                        builder: (context, state) {
                          final isComplete = state.completedDayIds.contains(day.id);

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                            leading: Icon(
                              isComplete ? Icons.check_circle : Icons.circle_outlined,
                              color: isComplete ? Colors.green : theme.disabledColor,
                            ),
                            title: Text(day.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                            subtitle: Text(day.workout.title, style: theme.textTheme.bodyMedium),
                            onTap: () {
                              // --- LOGIC CHANGE HERE ---
                              // Check if this is a "Choice" workout based on title convention
                              // In a real app, you might use a specific 'type' field in the model.
                              if (day.title.contains("Choice")) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<PlanBloc>(context),
                                      child: WorkoutSelectionScreen(
                                        title: day.title,
                                        planDayId: day.id,
                                        // Fetch specific options. Currently hardcoded to PowerHour for this example.
                                        options: getPowerHourOptions(),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // Standard Navigation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<PlanBloc>(context),
                                      child: WorkoutDetailScreen(
                                        workout: day.workout,
                                        planDayId: day.id,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}