import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

PlanDay buildDay(int week, int dayNum, String title, Workout workout) {
  return PlanDay(id: 'css_w${week}_d$dayNum', title: title, workout: workout);
}

Workout simpleIntervalWorkout(String title, String description, {required Duration workDuration, required Duration restDuration, required int reps}) {
  return Workout(
    title: title,
    description: description,
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Get the blood flowing.'),
      for (int i = 0; i < reps; i++) ...[WorkoutStage(name: 'Work', duration: workDuration, description: 'Maintain target intensity.'), WorkoutStage(name: 'Rest', duration: restDuration, description: 'Active recovery.')],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Stretch.'),
    ],
  );
}
