import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

class WorkoutRepository {
  // Method to fetch all training plans
  List<TrainingPlan> getAllPlans() {
    return [_cyclingPlan(), _rowingPlan(), _kettlebellPlan(), _petePlan()];
  }

  TrainingPlan _cyclingPlan() {
    return TrainingPlan(
      id: 'cycling_12_week',
      title: '12-Week Indoor Cycling Plan',
      description: 'A comprehensive plan for building cycling endurance and power.',
      difficulty: 'Intermediate',
      weeks: List.generate(12, (weekIndex) {
        return PlanWeek(
          weekNumber: weekIndex + 1,
          days: List.generate(3, (dayIndex) { // 3 sessions per week
            return PlanDay(
              id: 'cycling_w${weekIndex + 1}_d${dayIndex + 1}',
              title: 'Session ${dayIndex + 1}',
              workout: Workout(
                title: 'Endurance Ride',
                description: 'Focus on maintaining a steady pace.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                  const WorkoutStage(name: 'Main Set', duration: Duration(minutes: 30)),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  TrainingPlan _rowingPlan() {
    return TrainingPlan(
      id: 'hydrow_rowing_mix',
      title: 'Hydrow Rowing Workouts',
      description: 'A collection of rowing workouts for all fitness levels.',
      difficulty: 'Beginner',
      weeks: [
        PlanWeek(
          weekNumber: 1,
          days: [
            PlanDay(
              id: 'rowing_w1_d1',
              title: 'Intro to Rowing',
              workout: Workout(
                title: 'Technique Focus',
                description: 'Learn the basics of rowing form.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
                  const WorkoutStage(name: 'Drills', duration: Duration(minutes: 15)),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  TrainingPlan _kettlebellPlan() {
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
                description: 'Focus on explosive power and core stability.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                  const WorkoutStage(name: 'Main Circuit', duration: Duration(minutes: 20)),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  TrainingPlan _petePlan() {
    return TrainingPlan(
      id: 'pete_plan_beginner',
      title: 'The Pete Plan (Beginner)',
      description: 'A popular rowing plan for building a solid aerobic base.',
      difficulty: 'Beginner',
      weeks: [
        PlanWeek(
          weekNumber: 1,
          days: [
            PlanDay(
              id: 'pete_w1_d1',
              title: '5000m Intervals',
              workout: Workout(
                title: '5000m @ 22-24 spm',
                description: 'Focus on long, powerful strokes.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
                  const WorkoutStage(name: '5000m Row', duration: Duration(minutes: 20)), // Placeholder
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
