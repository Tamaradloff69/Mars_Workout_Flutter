import 'package:flutter/material.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/repositories/workout_repository.dart';
import 'package:mars_workout_app/presentation/screens/details/plan_details.dart';

class PlanListScreen extends StatelessWidget {
  const PlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = WorkoutRepository().getAllPlans();

    return Scaffold(
      appBar: AppBar(title: const Text("Workout Plans")),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return ListTile(
            title: Text(plan.title),
            subtitle: Text(plan.difficulty),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlanDetailScreen(plan: plan),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
