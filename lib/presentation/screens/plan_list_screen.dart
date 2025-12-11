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

              final isActive = state.isPlanActive(plan.id, workoutType);

              return Card(
                surfaceTintColor: progress >= 1.0
                    ? theme.colorScheme.tertiaryContainer
                    : isActive
                    ? theme.colorScheme.primaryContainer
                    : null,
                shadowColor: null,
                shape: isActive || progress >= 1.0
                    ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                      color: progress >= 1.0
                          ? theme.colorScheme.tertiary
                          : isActive ? theme.primaryColor : Colors.transparent,
                      width: 2
                  ),
                )
                    : null,
                elevation: isActive || progress >= 1.0 ? 4 : 1,
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

                            // STATUS BADGES
                            if (progress >= 1.0)
                              _buildStatusBadge(theme, "Complete", theme.colorScheme.tertiaryContainer, theme.colorScheme.onTertiaryContainer)
                            else if (isActive)
                              _buildStatusBadge(theme, "Active", theme.colorScheme.primaryContainer, theme.colorScheme.onPrimaryContainer),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(plan.description, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),

                        // Progress Bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                  color: progress >= 1.0
                                      ? theme.colorScheme.tertiary
                                      : isActive ? theme.primaryColor : Colors.grey,
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

  Widget _buildStatusBadge(ThemeData theme, String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}