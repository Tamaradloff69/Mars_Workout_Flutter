import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WorkoutCompletedScreen extends StatelessWidget {
  final String workoutTitle;
  final int totalMinutes;

  const WorkoutCompletedScreen({
    super.key,
    required this.workoutTitle,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      Lottie.asset('assets/lottie/confetti_animation.json', repeat: false),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_events_rounded, size: 120, color: Colors.amber),
                          const SizedBox(height: 32),

                          // 2. Title
                          Text(
                            "WORKOUT COMPLETE!",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // 3. Subtext
                          Text(
                            "You crushed $workoutTitle.",
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Total time: $totalMinutes mins",
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                // Pop back to the previous screen (Plan Details)
                                // We pop TWICE: once for this screen, once for WorkoutDetailScreen
                                Navigator.of(context)..pop()..pop();
                              },
                              child: const Text("FINISH"),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}