import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_state.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_detail_screen.dart';

class PlanDetailScreen extends StatelessWidget {
  final TrainingPlan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(plan.description, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                return const SizedBox.shrink(); // Already started
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plan.weeks.length,
              itemBuilder: (context, index) {
                final week = plan.weeks[index];
                return ExpansionTile(
                  title: Text("Week ${week.weekNumber}"),
                  initiallyExpanded: index == 0, // Open first week by default
                  children: week.days.map((day) {
                    return BlocBuilder<PlanBloc, PlanState>(
                      builder: (context, state) {
                        final isComplete = state.completedDayIds.contains(day.id);

                        return ListTile(
                          leading: Icon(
                            isComplete ? Icons.check_circle : Icons.circle_outlined,
                            color: isComplete ? Colors.green : Colors.grey,
                          ),
                          title: Text(day.title),
                          subtitle: Text(day.workout.title),
                          onTap: () {
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
                          },
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
