// lib/presentation/screens/home_screen/widgets/history_stats_header.dart

import 'package:flutter/material.dart';
import 'package:mars_workout_app/logic/bloc/history/history_bloc.dart';

class HistoryStatsHeader extends StatelessWidget {
  final HistoryState state;

  const HistoryStatsHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Aggregate data using the helpers in HistoryState
    final totalWorkouts = state.history.length;
    final totalMinutes = state.totalLifetimeMinutes;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            label: "Workouts",
            value: totalWorkouts.toString(),
            icon: Icons.fitness_center,
          ),
          Container(width: 1, height: 40, color: theme.dividerColor),
          _buildStatItem(
            context,
            label: "Total Minutes",
            value: totalMinutes.toString(),
            icon: Icons.timer,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, {
        required String label,
        required String value,
        required IconData icon,
      }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.1,
            color: theme.disabledColor,
          ),
        ),
      ],
    );
  }
}