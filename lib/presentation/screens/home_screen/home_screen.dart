import 'package:flutter/material.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/presentation/screens/plan_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mars Workout"),
          bottom: TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(icon: Icon(Icons.directions_bike), text: "Cycling"),
              Tab(icon: Icon(Icons.rowing), text: "Rowing"),
              Tab(icon: Icon(Icons.fitness_center), text: "Kettlebell"),
            ],
          ),
        ),
        body: Center(
          child: TabBarView(
            children: [
              PlanListScreen(workoutType: WorkoutType.cycling),
              PlanListScreen(workoutType: WorkoutType.rowing),
              PlanListScreen(workoutType: WorkoutType.kettleBell),
            ],
          ),
        ),
      ),
    );
  }
}
