// lib/presentation/screens/home_screen/history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/logic/bloc/history/history_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mars_workout_app/presentation/screens/home_screen/history/widgets/history_stats_header.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout History"),
        actions: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              // Only show the clear button if there is history to clear
              if (state.history.isEmpty) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                onPressed: () => _showClearConfirmation(context),
                tooltip: 'Clear All History',
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text("No workout history yet.", style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              HistoryStatsHeader(state: state), // New Stats Header
              const SizedBox(height: 24),
              Text(
                "RECENT ACTIVITY",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.disabledColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              // Move the previous ListView logic into this child list
              ...state.history.map((item) => Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  context.read<HistoryBloc>().add(DeleteHistoryItem(item.id));

                  // Optional: Show a snackbar to confirm
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${item.workoutTitle} removed from history"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.zero, // Card handles padding via the loop/separator
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                      child: Icon(Icons.fitness_center, color: theme.primaryColor),
                    ),
                    title: Text(item.workoutTitle, style: theme.textTheme.titleMedium),
                    subtitle: Text(DateFormat('EEE, MMM d • h:mm a').format(item.completedAt)),
                    trailing: Text(
                      "${item.totalMinutes}m",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
            ],
          );
        },
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Clear History?"),
        content: const Text("This will permanently delete all your recorded workouts. This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<HistoryBloc>().add(const ClearHistory());
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Workout history cleared")),
              );
            },
            child: const Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}