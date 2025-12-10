import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

TrainingPlan kettlebellPlan() {
  return TrainingPlan(
    id: 'kettlebell_12_week',
    title: '12-Week Kettlebell Program',
    description: 'Build strength and power with this kettlebell program.',
    difficulty: 'Intermediate',
    weeks: List.generate(12, (weekIndex) {
      return PlanWeek(
        weekNumber: weekIndex + 1,
        days: List.generate(3, (dayIndex) {
          return PlanDay(
            id: 'kettlebell_w${weekIndex + 1}_d${dayIndex + 1}',
            title: 'Full Body Strength',
            workout: Workout(
              title: 'Kettlebell Swings & Goblet Squats',
              description: 'Focus on explosive power.',
              stages: [
                const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Halo, Slingshot.'),
                const WorkoutStage(name: 'Main Circuit', duration: Duration(minutes: 20), description: 'Ladder: 5/5, 10/10.'),
                const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Static stretching.'),
              ],
            ),
          );
        }),
      );
    }),
  );
}
