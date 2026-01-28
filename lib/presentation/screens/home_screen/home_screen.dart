import 'package:flutter/material.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/presentation/screens/home_screen/history/history_screen.dart';
import 'package:mars_workout_app/presentation/screens/home_screen/plan_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: WorkoutType.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mars Workout"),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(icon: Icon(Icons.directions_bike), text: "Cycle"),
              Tab(icon: Icon(Icons.rowing), text: "Row"),
              Tab(icon: Icon(Icons.directions_run), text: "Elliptical"),
              Tab(icon: Icon(Icons.timer_outlined), text: "History"),
            ],
          ),
        ),
        body: const Center(
          child: TabBarView(
            children: [
              PlanListScreen(workoutType: WorkoutType.cycling),
              PlanListScreen(workoutType: WorkoutType.rowing),
              PlanListScreen(workoutType: WorkoutType.elliptical),
              HistoryScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
