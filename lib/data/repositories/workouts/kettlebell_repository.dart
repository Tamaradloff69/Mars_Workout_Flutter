import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

TrainingPlan kettlebellPlan() {
  return TrainingPlan(
    id: 'kettlebell_12_week',
    title: '12-Week Kettlebell Program',
    workoutType: WorkoutType.kettleBell, //
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
                // --- SPLIT WARM-UP ---
                const WorkoutStage(
                    name: 'Warm-up: Halos',
                    duration: Duration(minutes: 3),
                    description: 'Circle the bell around your head. Keep core tight. Alternating directions.'
                ),
                const WorkoutStage(
                    name: 'Warm-up: Slingshots',
                    duration: Duration(minutes: 3),
                    description: 'Pass the bell around your waist to engage the core. Keep hips stable.'
                ),
                const WorkoutStage(
                    name: 'Warm-up: Lunges',
                    duration: Duration(minutes: 4),
                    description: 'Bodyweight lunges to mobilize hips and knees.'
                ),
                // ---------------------
                const WorkoutStage(
                    name: 'Main Circuit',
                    duration: Duration(minutes: 20),
                    description: 'Ladder: 5 Swings/5 Squats, rest 30s. Then 10/10. Then 15/15. Repeat.'
                ),
                const WorkoutStage(
                    name: 'Cool-down',
                    duration: Duration(minutes: 5),
                    description: 'Static stretching focusing on hamstrings.'
                ),
              ],
            ),
          );
        }),
      );
    }),
  );
}

// --- NEW PLAN: Plan 015 (Video based) ---
TrainingPlan plan015KettlebellProgram() {
  return TrainingPlan(
    id: 'plan_015_power',
    title: 'Plan 015: Swings & Pushups',
    description: 'A minimalist power program. Perform 10 explosive reps every 90 seconds, alternating exercises. Total time: 30 mins.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.kettleBell,
    weeks: List.generate(4, (weekIndex) {
      return PlanWeek(
        weekNumber: weekIndex + 1,
        days: [
          PlanDay(id: 'p015_w${weekIndex}_d1', title: 'Session 1', workout: _plan015Workout()),
          PlanDay(id: 'p015_w${weekIndex}_d2', title: 'Session 2', workout: _plan015Workout()),
          PlanDay(id: 'p015_w${weekIndex}_d3', title: 'Session 3', workout: _plan015Workout()),
        ],
      );
    }),
  );
}

Workout _plan015Workout() {
  return Workout(
    title: 'Plan 015: Power Intervals',
    description: 'Every 90 seconds, perform 10 reps. Rest for the remainder of the interval. Focus on MAXIMUM explosive power.',
    stages: [
      // --- SPLIT WARM-UP ---
      const WorkoutStage(
          name: 'Warm-up: Halos',
          duration: Duration(minutes: 2),
          description: 'Light halos to loosen shoulders. Keep the ribs down.'
      ),
      const WorkoutStage(
          name: 'Warm-up: Prying Squats',
          duration: Duration(minutes: 2),
          description: 'Goblet squat position. Use elbows to push knees out. Rock side to side.'
      ),
      const WorkoutStage(
          name: 'Warm-up: Easy Swings',
          duration: Duration(minutes: 1),
          description: 'Two-handed easy swings to pattern the hinge before intensity starts.'
      ),
      // ---------------------

      // 20 Rounds = 30 Minutes total (10 rounds of each)
      for (int i = 1; i <= 20; i++)
        WorkoutStage(
            name: i.isOdd ? '10 Explosive Swings' : '10 Power Pushups',
            duration: const Duration(seconds: 90),
            description: i.isOdd
                ? 'Perform 10 Hardstyle Swings. Snap the hips! Rest for the remainder of the 90s.'
                : 'Perform 10 Power Pushups. Drive into the floor. Rest for the remainder of the 90s.'
        ),
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 5),
          description: 'Walk it off and static stretch.'
      ),
    ],
  );
}