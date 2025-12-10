import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_state.dart';
import 'package:mars_workout_app/presentation/screens/details/plan_details.dart';

class PlanListScreen extends StatelessWidget {
  final WorkoutType workoutType;
  const PlanListScreen({super.key, required this.workoutType});

  @override
  Widget build(BuildContext context) {
    final plans = WorkoutRepository().getAllPlans().where((workout) => workout.workoutType == workoutType).toList();
    final theme = Theme.of(context);

    return SafeArea(
      child: BlocBuilder<PlanBloc, PlanState>(
        builder: (context, state) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: plans.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final plan = plans[index];
              final progress = plan.calculateProgress(state.completedDayIds);
              final isActive = state.activePlanId == plan.id;
              return Card(
                surfaceTintColor: progress * 100 == 100 ? theme.colorScheme.tertiary.withValues(alpha: 0.2) : null,
                shadowColor: null,
                shape: progress * 100 == 100
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: theme.colorScheme.tertiary, width: 2),
                      )
                    : isActive
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: theme.primaryColor, width: 2),
                      )
                    : null, // Falls back to AppTheme
                elevation: progress * 100 == 100 || isActive ? 2 : 0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PlanDetailScreen(plan: plan)));
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(plan.title, style: theme.textTheme.titleLarge)),
                            if (progress * 100 == 100) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: theme.colorScheme.tertiary.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Complete",
                                  style: TextStyle(color: theme.colorScheme.tertiary, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ] else if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: theme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Active",
                                  style: TextStyle(color: theme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(plan.description, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: theme.colorScheme.surface,
                                  color: progress * 100 == 100
                                      ? theme.colorScheme.tertiary
                                      : isActive
                                      ? theme.primaryColor
                                      : Colors.grey,
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text("${(progress * 100).toInt()}%", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
