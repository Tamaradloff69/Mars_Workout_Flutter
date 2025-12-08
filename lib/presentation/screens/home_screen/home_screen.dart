import 'package:flutter/material.dart';
import 'package:mars_workout_app/presentation/screens/plan_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mars Workout")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlanListScreen()),
                );
              },
              child: const Text("Browse Workout Plans"),
            ),
          ],
        ),
      ),
    );
  }
}
