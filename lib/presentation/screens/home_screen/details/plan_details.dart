import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/presentation/screens/workout/selection/workout_selection_screen.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_preview/workout_preview_screen.dart';

class PlanDetailScreen extends StatelessWidget {
  final TrainingPlan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.title),
        actions: [
          // --- NEW RESET BUTTON ---
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset') {
                _showResetConfirmation(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'reset',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Reset Progress'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<PlanBloc, PlanState>(
          builder: (context, state) {
            // Check if THIS plan is the active one for its type
            final isActive = state.isPlanActive(plan.id, plan.workoutType);
            // completedDayIds is already a Set for O(1) lookups
            final completedDayIdsSet = state.completedDayIds;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(plan.description, style: theme.textTheme.bodyLarge),
                ),

                // --- START PLAN BUTTON (Header) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: !isActive
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<PlanBloc>().add(StartPlan(plan.id, plan.workoutType));
                            },
                            child: const Text("Start this Plan"),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            "You are currently working on this plan.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                // --- WEEKS LIST ---
                Expanded(
                  // REMOVED IgnorePointer so users can expand/collapse tiles
                  child: Opacity(
                    // Visual cue: Slight fade if inactive, but still readable
                    opacity: isActive ? 1.0 : 0.8,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: plan.weeks.length,
                      itemBuilder: (context, index) {
                        final week = plan.weeks[index];

                        final isWeekComplete = week.days.every((day) => completedDayIdsSet.contains(day.id));

                        // Locking Logic: Only applies if the plan IS active.
                        // If inactive, we let them see everything (preview mode).
                        bool isWeekLocked = false;
                        if (isActive && index > 0) {
                          final previousWeek = plan.weeks[index - 1];
                          final isPrevWeekComplete = previousWeek.days.every((day) => completedDayIdsSet.contains(day.id));
                          if (!isPrevWeekComplete) {
                            isWeekLocked = true;
                          }
                        }

                        // Styling
                        Color? titleColor;
                        Icon? leadingIcon;
                        Color? backgroundColor;

                        if (isWeekComplete) {
                          titleColor = Colors.green;
                          leadingIcon = const Icon(Icons.check_circle, color: Colors.green);
                          backgroundColor = Colors.green.withValues(alpha: 0.05);
                        } else if (isWeekLocked) {
                          titleColor = Colors.grey;
                          leadingIcon = const Icon(Icons.lock, color: Colors.grey);
                          backgroundColor = Colors.grey.withValues(alpha: 0.05);
                        } else {
                          titleColor = theme.textTheme.titleMedium?.color;
                          leadingIcon = null;
                          backgroundColor = null;
                        }

                        return Theme(
                          data: theme.copyWith(dividerColor: Colors.transparent),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Card(
                              elevation: 0,
                              clipBehavior: Clip.antiAlias,
                              color: backgroundColor ?? theme.cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: isWeekComplete ? const BorderSide(color: Colors.green, width: 1) : BorderSide.none,
                              ),
                              child: ExpansionTile(
                                clipBehavior: Clip.antiAlias,
                                enabled: !isWeekLocked,
                                leading: leadingIcon,
                                textColor: titleColor,
                                iconColor: titleColor,
                                collapsedTextColor: titleColor,
                                collapsedIconColor: titleColor,

                                title: Text(
                                  "Week ${week.weekNumber}${isWeekComplete ? ' (Completed!)' : ''}",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                                ),

                                initiallyExpanded: isActive && index == 0 && !isWeekComplete,

                                children: week.days.map((day) {
                                  final isDayComplete = completedDayIdsSet.contains(day.id);

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                    leading: Icon(isDayComplete ? Icons.check_circle : Icons.circle_outlined, color: isDayComplete ? Colors.green : theme.disabledColor),
                                    title: Text(
                                      day.title,
                                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, decoration: isDayComplete ? TextDecoration.lineThrough : null, color: isDayComplete ? Colors.grey : null),
                                    ),
                                    onTap: () {
                                      // 2. Navigate if Active
                                      if (day.title.contains("Choice") && isActive) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: BlocProvider.of<PlanBloc>(context),
                                              child: WorkoutSelectionScreen(title: day.title, planDayId: day.id, options: getPowerHourOptions(), workoutType: plan.workoutType),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: BlocProvider.of<PlanBloc>(context),
                                              child: WorkoutPreviewScreen(workout: day.workout, planDayId: day.id, workoutType: plan.workoutType, isPlanActive: isActive),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Reset Plan?"),
          content: const Text("This will clear all your progress for this specific plan. This action cannot be undone."),
          actions: [
            TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: const Text("Reset", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();

                // Using the context passed to the method (from the widget build)
                context.read<PlanBloc>().add(ResetPlanProgress(plan));

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plan progress has been reset.")));
              },
            ),
          ],
        );
      },
    );
  }
}
