import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

TrainingPlan kettlebellPlan() {
  return TrainingPlan(
    id: 'kettlebell_simple_sinister',
    title: 'Kettlebell: Simple & Sinister',
    workoutType: WorkoutType.kettleBell,
    description: 'A minimalist program based on ladders and EMOM (Every Minute on the Minute) circuits.',
    difficulty: 'Intermediate',
    weeks: List.generate(12, (weekIndex) {
      int weekNum = weekIndex + 1;

      // Progression Logic:
      // Weeks 1-4: Foundation (Longer Rests)
      // Weeks 5-8: Endurance (Shorter Rests)
      // Weeks 9-12: Power (More Rounds)

      return PlanWeek(
        weekNumber: weekNum,
        days: [
          // DAY 1: The Swing Ladder
          PlanDay(
            id: 'kb_w${weekNum}_d1',
            title: 'Swing Ladder',
            workout: _swingLadderWorkout(weekNum),
          ),
          // DAY 2: The "Armor Building" Circuit
          PlanDay(
            id: 'kb_w${weekNum}_d2',
            title: 'Armor Building Circuit',
            workout: _armorBuildingCircuit(weekNum),
          ),
          // DAY 3: Conditioning Flow
          PlanDay(
            id: 'kb_w${weekNum}_d3',
            title: 'Full Body Flow',
            workout: _fullBodyFlow(weekNum),
          ),
        ],
      );
    }),
  );
}

// --- WORKOUT 1: The "Ladder" (10 down to 1) ---
Workout _swingLadderWorkout(int week) {
  // Advanced logic: Add more volume as weeks progress
  int startReps = (week > 6) ? 15 : 10;

  List<WorkoutStage> ladderStages = [];

  // Warmup
  ladderStages.add(const WorkoutStage(name: 'Warm-up: Halos', duration: Duration(minutes: 2), description: ' loosen up shoulders.'));

  // The Ladder Loop
  for (int i = startReps; i >= 2; i -= 2) { // 10, 8, 6, 4, 2
    ladderStages.add(WorkoutStage(
        name: '$i x KB Swings',
        duration: const Duration(seconds: 45),
        description: 'Perform $i explosive swings. Hinge deeply.'
    ));
    ladderStages.add(WorkoutStage(
        name: '$i x Goblet Squats',
        duration: const Duration(seconds: 45),
        description: 'Perform $i deep squats. Elbows inside knees.'
    ));
    ladderStages.add(const WorkoutStage(
        name: 'Rest',
        duration: Duration(seconds: 30),
        description: 'Shake it off.'
    ));
  }

  ladderStages.add(const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 3)));

  return Workout(
    title: 'Swing & Squat Ladder',
    description: 'Perform Swings and Squats in a descending ladder ($startReps down to 2). High intensity.',
    stages: ladderStages,
  );
}

// --- WORKOUT 2: The "Armor Building" (EMOM Style) ---
Workout _armorBuildingCircuit(int week) {
  int rounds = (week > 4) ? 5 : 3;

  return Workout(
    title: 'Armor Building',
    description: '2 Cleans, 1 Press, 3 Squats. Repeat for rounds.',
    stages: [
      const WorkoutStage(name: 'Warm-up: Halos', duration: Duration(minutes: 2)),
      for(int i=1; i<=rounds; i++) ...[
        const WorkoutStage(
            name: '2 Cleans (Left)',
            duration: Duration(seconds: 20),
            description: 'Clean to rack position.'
        ),
        const WorkoutStage(
            name: '1 Overhead Press (Left)',
            duration: Duration(seconds: 15),
            description: 'Strict press overhead.'
        ),
        const WorkoutStage(
            name: '3 Goblet Squats',
            duration: Duration(seconds: 30),
            description: 'Deep squats.'
        ),
        // Switch Sides
        const WorkoutStage(
            name: '2 Cleans (Right)',
            duration: Duration(seconds: 20),
            description: 'Switch hands.'
        ),
        const WorkoutStage(
            name: '1 Overhead Press (Right)',
            duration: Duration(seconds: 15),
            description: 'Strict press overhead.'
        ),
        const WorkoutStage(
            name: 'Rest',
            duration: Duration(minutes: 1),
            description: 'Recover fully before next round.'
        ),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 3)),
    ],
  );
}

// --- WORKOUT 3: Full Body Flow (Lunges & Deadlifts) ---
Workout _fullBodyFlow(int week) {
  return Workout(
      title: 'Legs & Lungs',
      description: 'Lunges and Deadlifts for lower body power.',
      stages: [
        const WorkoutStage(name: 'Warm-up: Halos', duration: Duration(minutes: 2)),

        // Circuit x 3
        for(int i=0; i<3; i++) ...[
          const WorkoutStage(
              name: 'Reverse Lunge (Left)',
              duration: Duration(seconds: 40),
              description: 'Step back, tap knee gently.'
          ),
          const WorkoutStage(
              name: 'Reverse Lunge (Right)',
              duration: Duration(seconds: 40),
              description: 'Keep chest up.'
          ),
          const WorkoutStage(
              name: 'KB Deadlift',
              duration: Duration(seconds: 60),
              description: 'Heavy hinge movement. Flat back.'
          ),
          const WorkoutStage(
              name: 'Rest',
              duration: Duration(seconds: 45),
              description: 'Shake out legs.'
          ),
        ],
        const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
      ]
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