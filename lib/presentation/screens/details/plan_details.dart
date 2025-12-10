import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_state.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_detail_screen.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_selection.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';

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
            child: Text(plan.description, style: theme.textTheme.bodyLarge),
          ),

          // --- START PLAN BUTTON (Header) ---
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
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
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

          // --- WEEKS LIST ---
          Expanded(
            child: BlocBuilder<PlanBloc, PlanState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: plan.weeks.length,
                  itemBuilder: (context, index) {
                    final week = plan.weeks[index];

                    // 1. Check if THIS week is complete
                    final isWeekComplete = week.days.every(
                            (day) => state.completedDayIds.contains(day.id)
                    );

                    // 2. Check if PREVIOUS week is complete (Locking Logic)
                    bool isWeekLocked = false;
                    if (index > 0) {
                      final previousWeek = plan.weeks[index - 1];
                      final isPrevWeekComplete = previousWeek.days.every(
                              (day) => state.completedDayIds.contains(day.id)
                      );
                      if (!isPrevWeekComplete) {
                        isWeekLocked = true;
                      }
                    }

                    // --- STYLING LOGIC ---
                    Color? titleColor;
                    Icon? leadingIcon;
                    Color? backgroundColor;

                    if (isWeekComplete) {
                      // STYLE: COMPLETE
                      titleColor = Colors.green;
                      leadingIcon = const Icon(Icons.check_circle, color: Colors.green);
                      backgroundColor = Colors.green.withValues(alpha: 0.05);
                    } else if (isWeekLocked) {
                      // STYLE: LOCKED
                      titleColor = Colors.grey;
                      leadingIcon = const Icon(Icons.lock, color: Colors.grey);
                      backgroundColor = Colors.grey.withValues(alpha: 0.05);
                    } else {
                      // STYLE: ACTIVE / NORMAL
                      titleColor = theme.textTheme.titleMedium?.color;
                      leadingIcon = null; // No icon, or maybe a number
                      backgroundColor = null;
                    }

                    return Theme(
                      data: theme.copyWith(dividerColor: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          elevation: 0,
                          color: backgroundColor ?? theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isWeekComplete
                                ? const BorderSide(color: Colors.green, width: 1)
                                : BorderSide.none,
                          ),
                          child: ExpansionTile(
                            enabled: !isWeekLocked,
                            leading: leadingIcon,
                            textColor: titleColor,
                            iconColor: titleColor,
                            collapsedTextColor: titleColor,
                            collapsedIconColor: titleColor,

                            title: Text(
                              "Week ${week.weekNumber}${isWeekComplete ? ' (Completed!)' : ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: titleColor
                              ),
                            ),

                            // Auto-expand the first available week (not locked, not complete)
                            initiallyExpanded: index == 0 && !isWeekComplete,

                            children: week.days.map((day) {
                              final isDayComplete = state.completedDayIds.contains(day.id);

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                leading: Icon(
                                  isDayComplete ? Icons.check_circle : Icons.circle_outlined,
                                  color: isDayComplete ? Colors.green : theme.disabledColor,
                                ),
                                title: Text(
                                  day.title,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: isDayComplete ? TextDecoration.lineThrough : null,
                                    color: isDayComplete ? Colors.grey : null,
                                  ),
                                ),
                                onTap: () {
                                  // Determine Destination
                                  if (day.title.contains("Choice")) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: BlocProvider.of<PlanBloc>(context),
                                          child: WorkoutSelectionScreen(
                                            title: day.title,
                                            planDayId: day.id,
                                            options: getPowerHourOptions(),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: BlocProvider.of<PlanBloc>(context),
                                          child: WorkoutDetailScreen(
                                            workout: day.workout,
                                            planDayId: day.id,
                                            workoutType: plan.workoutType,
                                          ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}