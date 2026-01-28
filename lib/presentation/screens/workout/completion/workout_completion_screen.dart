import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkoutCompletedScreen extends StatelessWidget {
  final String workoutTitle;
  final int totalMinutes;
  final bool isWeekComplete;
  final bool isPlanComplete;

  const WorkoutCompletedScreen({super.key, required this.workoutTitle, required this.totalMinutes, this.isWeekComplete = false, this.isPlanComplete = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String titleText;
    String subText;
    Color primaryColor;
    String icon;

    if (isPlanComplete) {
      titleText = "PLAN CONQUERED!";
      subText = "You have finished the entire program. Incredible work!";
      primaryColor = Colors.amber;
      icon = 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExMXV6a2h1c2N3bTFtOWxkOWZuNDc5dXVrMTRuaTVnamQwcXd0aXN1OSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3Gm15eZOsNk0tptIuG/giphy.gif';
    } else if (isWeekComplete) {
      titleText = "WEEK CRUSHED!";
      subText = "Another week down. You're getting stronger.";
      primaryColor = Colors.purple;
      icon = 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3cW94YndpcGY0bTV0cWZ2OG1tcDl5eW5ybmNkYjdja3hxODM5NTRhdSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/4sPHesuyPZHRvGbDc9/giphy.gif';
    } else {
      titleText = "WORKOUT COMPLETE!";
      subText = "You crushed $workoutTitle.";
      primaryColor = theme.colorScheme.tertiary;
      icon = 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3ZGNoaGdsaWRzc24zZHluOTM4bzBqMzlqeXRoczExcnd4MmcxMHg3OCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/tf9jjMcO77YzV4YPwE/giphy.gif';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      if (isPlanComplete || isWeekComplete) Lottie.asset('assets/lottie/confetti_animation.json', repeat: isPlanComplete ? true : false),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: icon,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.fitness_center, size: 64),
                            memCacheWidth: 400,
                            memCacheHeight: 400,
                          ),
                          const SizedBox(height: 32),

                          // Title
                          Text(
                            titleText,
                            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Subtext
                          Text(
                            subText,
                            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // Stats
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                            child: Text("Session Time: $totalMinutes mins", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                          ),

                          const SizedBox(height: 16),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
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
