import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

// ==============================================================================
// 1. TABATA ELLIPTICAL (The "4-Minute Torch")
// Source: Classic Tabata Protocol adapted for Elliptical
// ==============================================================================

TrainingPlan ellipticalTabataPlan() {
  return TrainingPlan(
    id: 'elliptical_tabata_express',
    title: 'Elliptical: Tabata Express',
    description: 'Ultra-short, maximum intensity. 20 seconds all-out, 10 seconds rest. Proven to boost VO2 max.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.elliptical,
    weeks: List.generate(4, (weekIndex) {
      int weekNum = weekIndex + 1;
      return PlanWeek(
        weekNumber: weekNum,
        days: [
          PlanDay(id: 'el_tab_w${weekNum}_d1', title: 'Standard Tabata (1 Round)', workout: _tabataWorkout(rounds: 1)),
          PlanDay(id: 'el_tab_w${weekNum}_d2', title: 'Double Tabata (2 Rounds)', workout: _tabataWorkout(rounds: 2)),
          PlanDay(id: 'el_tab_w${weekNum}_d3', title: 'Endurance Tabata (3 Rounds)', workout: _tabataWorkout(rounds: 3)),
        ],
      );
    }),
  );
}

Workout _tabataWorkout({required int rounds}) {
  List<WorkoutStage> stages = [];

  // Warm Up
  stages.add(const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Low resistance. Get legs moving comfortably.'));

  for (int r = 1; r <= rounds; r++) {
    for (int i = 1; i <= 8; i++) {
      stages.add(WorkoutStage(
          name: 'SPRINT! ($i/8)',
          duration: const Duration(seconds: 20),
          description: 'Max resistance you can handle while keeping RPM > 80. Go ALL OUT.'
      ));
      stages.add(const WorkoutStage(
          name: 'Rest',
          duration: Duration(seconds: 10),
          description: 'Complete stop or very slow pedal.'
      ));
    }
    // Rest between full Tabata rounds (if more than 1)
    if (r < rounds) {
      stages.add(const WorkoutStage(
          name: 'Recovery Paddle',
          duration: Duration(minutes: 2),
          description: 'Slow down, catch breath before next round.'
      ));
    }
  }

  // Cool Down
  stages.add(const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Easy pace. Let heart rate drop.'));

  return Workout(
    title: 'Tabata: $rounds Round(s)',
    description: '20s Max Effort / 10s Rest x 8. High intensity.',
    stages: stages,
  );
}

// ==============================================================================
// 2. HIIT ELLIPTICAL (Weight Loss Focus)
// ==============================================================================

TrainingPlan ellipticalHiitPlan() {
  return TrainingPlan(
    id: 'elliptical_hiit_burn',
    title: 'Elliptical: Fat Burn HIIT',
    description: 'Longer intervals designed to keep heart rate in the fat burning zone. Good for endurance.',
    difficulty: 'Intermediate',
    workoutType: WorkoutType.elliptical,
    weeks: List.generate(4, (weekIndex) {
      int weekNum = weekIndex + 1;
      return PlanWeek(
        weekNumber: weekNum,
        days: [
          PlanDay(id: 'el_hiit_w${weekNum}_d1', title: 'Pyramid Intervals', workout: _pyramidIntervals()),
          PlanDay(id: 'el_hiit_w${weekNum}_d2', title: '30-20-10 Intervals', workout: _30_20_10_Intervals()),
          PlanDay(id: 'el_hiit_w${weekNum}_d3', title: 'Speed Intervals', workout: _speedIntervals()),
        ],
      );
    }),
  );
}

Workout _speedIntervals() {
  return Workout(
    title: 'Speed Intervals (30s/30s)',
    description: 'Classic 1:1 work-to-rest ratio.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      for(int i=0; i<10; i++) ...[
        const WorkoutStage(name: 'High Resistance Push', duration: Duration(seconds: 30), description: 'Increase resistance level significantly.'),
        const WorkoutStage(name: 'Low Resistance Spin', duration: Duration(seconds: 30), description: 'Drop resistance, keep feet moving.'),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _pyramidIntervals() {
  return const Workout(
    title: 'Pyramid Intervals',
    description: 'Intervals get longer, then shorter.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Hard: 1 min', duration: Duration(minutes: 1)),
      WorkoutStage(name: 'Easy: 1 min', duration: Duration(minutes: 1)),
      WorkoutStage(name: 'Hard: 2 min', duration: Duration(minutes: 2)),
      WorkoutStage(name: 'Easy: 2 min', duration: Duration(minutes: 2)),
      WorkoutStage(name: 'Hard: 3 min', duration: Duration(minutes: 3)),
      WorkoutStage(name: 'Easy: 2 min', duration: Duration(minutes: 2)),
      WorkoutStage(name: 'Hard: 2 min', duration: Duration(minutes: 2)),
      WorkoutStage(name: 'Easy: 1 min', duration: Duration(minutes: 1)),
      WorkoutStage(name: 'Hard: 1 min', duration: Duration(minutes: 1)),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _30_20_10_Intervals() {
  return Workout(
    title: '30-20-10 Intervals',
    description: '30s Moderate, 20s Hard, 10s Sprint. Repeat 5 times.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      for(int i=0; i<5; i++) ...[
        const WorkoutStage(name: 'Moderate Pace', duration: Duration(seconds: 30), description: 'Resistance 5/10. Conversational pace.'),
        const WorkoutStage(name: 'Hard Pace', duration: Duration(seconds: 20), description: 'Resistance 7/10. Labored breathing.'),
        const WorkoutStage(name: 'SPRINT', duration: Duration(seconds: 10), description: 'Resistance 9/10. Max effort!'),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 1), description: 'Catch your breath.'),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

// ==============================================================================
// 3. HILL CLIMB / GLUTE FOCUS (The "Booty Builder")
// ==============================================================================

TrainingPlan ellipticalHillPlan() {
  return TrainingPlan(
    id: 'elliptical_hills_glutes',
    title: 'Elliptical: Glute & Hill Climb',
    description: 'High resistance and incline focus. Includes reverse pedaling to target glutes and hamstrings.',
    difficulty: 'Intermediate',
    workoutType: WorkoutType.elliptical,
    weeks: List.generate(4, (weekIndex) {
      return PlanWeek(
        weekNumber: weekIndex + 1,
        days: [
          PlanDay(id: 'el_hill_d1', title: 'The Mountain', workout: _mountainClimb()),
          PlanDay(id: 'el_hill_d2', title: 'Reverse Targeting', workout: _reversePedalWorkout()),
        ],
      );
    }),
  );
}

Workout _mountainClimb() {
  return const Workout(
    title: 'The Mountain Climb',
    description: 'Progressively increasing resistance.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Flat incline, low resistance.'),
      WorkoutStage(name: 'Base Incline', duration: Duration(minutes: 3), description: 'Increase incline to 15%. Moderate resistance.'),
      WorkoutStage(name: 'Steep Climb', duration: Duration(minutes: 3), description: 'Increase incline to Max. High resistance. Push through heels.'),
      WorkoutStage(name: 'Plateau (Rest)', duration: Duration(minutes: 2), description: 'Keep incline high, lower resistance.'),
      WorkoutStage(name: 'Summit Push', duration: Duration(minutes: 2), description: 'Max incline, Max resistance. Hands on stationary handles to isolate legs.'),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Flat incline, easy spin.'),
    ],
  );
}

Workout _reversePedalWorkout() {
  return const Workout(
    title: 'Glute Focus (Reverse)',
    description: 'Alternating forward and backward motion to hit different leg muscles.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Forward Climb', duration: Duration(minutes: 3), description: 'High resistance. Lean slightly forward.'),
      WorkoutStage(name: 'Reverse Pedal', duration: Duration(minutes: 2), description: 'Pedal backwards. Keep chest up. Target hamstrings/glutes.'),
      WorkoutStage(name: 'Forward Climb', duration: Duration(minutes: 3)),
      WorkoutStage(name: 'Reverse Pedal', duration: Duration(minutes: 2)),
      WorkoutStage(name: 'Forward Climb', duration: Duration(minutes: 3)),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}