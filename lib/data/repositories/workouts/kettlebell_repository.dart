import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

// ==============================================================================
// 4. NOURISH MOVE LOVE: 35-MIN HIIT (Video Based)
// Source: https://www.nourishmovelove.com/kettlebell-hiit-workout-for-women/
// ==============================================================================

TrainingPlan nourishMoveLoveHiitPlan() {
  return TrainingPlan(
    id: 'nml_35min_hiit',
    title: 'NML: 35-Min Total Body HIIT',
    description: 'High intensity interval training. 7 circuits, supersetting strength (40s) and power (30s). Repeat each circuit x2.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.kettleBell,
    weeks: List.generate(4, (weekIndex) {
      int weekNum = weekIndex + 1;
      return PlanWeek(
        weekNumber: weekNum,
        days: [
          // Suggested schedule: 2-3 times a week
          PlanDay(id: 'nml_w${weekNum}_d1', title: 'HIIT Session A', workout: _nmlHiitWorkout()),
          PlanDay(id: 'nml_w${weekNum}_d2', title: 'HIIT Session B', workout: _nmlHiitWorkout()),
          PlanDay(id: 'nml_w${weekNum}_d3', title: 'Active Recovery', workout: _fullBodyFlow(weekNum)),
        ],
      );
    }),
  );
}

Workout _nmlHiitWorkout() {
  List<WorkoutStage> stages = [];

  // --- Warm Up ---
  stages.add(const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Light cardio, arm circles, air squats, and halos.'));

  // --- Helper for Circuit Building ---
  // Strength: 40s work, 20s rest
  // Power: 30s work, 10s rest
  // Repeat x2
  void addCircuit(String cName, String strengthName, String strengthDesc, String powerName, String powerDesc, {bool isUnilateral = false}) {
    // Set 1
    stages.add(WorkoutStage(
      // CHANGE: Use strengthName instead of generic "Strength" so GIF repo can find keywords
        name: '$strengthName (Set 1)',
        duration: const Duration(seconds: 40),
        description: isUnilateral ? '(RIGHT/First Side)\n$strengthDesc' : strengthDesc
    ));
    stages.add(const WorkoutStage(name: 'Rest', duration: Duration(seconds: 20), description: 'Breathe. Prepare for power.'));

    stages.add(WorkoutStage(
      // CHANGE: Use powerName instead of generic "Power"
        name: '$powerName (Set 1)',
        duration: const Duration(seconds: 30),
        description: isUnilateral ? '(RIGHT/First Side)\n$powerDesc' : powerDesc
    ));
    stages.add(const WorkoutStage(name: 'Rest', duration: Duration(seconds: 10), description: 'Quick shake out.'));

    // Set 2
    stages.add(WorkoutStage(
        name: '$strengthName (Set 2)',
        duration: const Duration(seconds: 40),
        description: isUnilateral ? '(LEFT/Second Side)\n$strengthDesc' : strengthDesc
    ));
    stages.add(const WorkoutStage(name: 'Rest', duration: Duration(seconds: 20), description: 'Recover.'));

    stages.add(WorkoutStage(
        name: '$powerName (Set 2)',
        duration: const Duration(seconds: 30),
        description: isUnilateral ? '(LEFT/Second Side)\n$powerDesc' : powerDesc
    ));
    stages.add(const WorkoutStage(name: 'Circuit Rest', duration: Duration(seconds: 30), description: 'Longer rest before next circuit. Grab water.'));
  }
  // --- CIRCUIT 1: Squats ---
  addCircuit(
      'Circuit 1',
      'KB Pick Up Squats', 'Squat deep, tap bell to floor, pick it up. Drive through heels.',
      'Alt Clean & Front Squat', 'Clean to rack, squat, return to floor. Alternate hands.'
  );

  // --- CIRCUIT 2: Lunge & Swing ---
  addCircuit(
      'Circuit 2',
      'Split Lunge Hold & Row', 'Hold bottom of lunge. Row bell to hip.',
      'Kettlebell Swings', 'Hinge hard. Snap hips. Chest up.',
      isUnilateral: true
  );

  // --- CIRCUIT 3: Deadlift & Press ---
  addCircuit(
      'Circuit 3',
      'Staggered Deadlift', 'Kickstand stance. Hinge back.',
      'Staggered DL + Clean + Press', 'Complex: Deadlift, Clean, Press overhead.',
      isUnilateral: true
  );

  // --- CIRCUIT 4: Push & Burpee ---
  addCircuit(
      'Circuit 4',
      'Push Up + Pull Through', 'Plank position. Drag bell under body to other side.',
      'Burpee + Swing', 'Chest to floor burpee, stand, 1 KB swing.',
      isUnilateral: false // Alternating inside the set
  );

  // --- CIRCUIT 5: Lateral & Swing ---
  addCircuit(
      'Circuit 5',
      'Lateral Lunge + Curl', 'Step side deep. Return to center. Bicep curl.',
      'Staggered Swing + Lateral Lunge', 'Swing in kickstand, rack it, step into lateral lunge.',
      isUnilateral: true
  );

  // --- CIRCUIT 6: Core & Complex ---
  addCircuit(
      'Circuit 6',
      'Around the World + March', 'Orbit bell around body. Knee drive (march) when bell is front.',
      'DL + Clean + Squat + Press', 'The "Man Maker" complex. One rep of everything.',
      isUnilateral: false // Alternating
  );

  // --- CIRCUIT 7: Glute & Abs ---
  addCircuit(
      'Circuit 7',
      'Glute Bridge + Skull Crusher', 'Hold bridge hips high. Bend elbows to lower bell to forehead.',
      'Hollow Rock + Twist', 'Hollow body hold. Crunch up. 4 Russian Twists.',
      isUnilateral: false
  );

  // --- Cool Down ---
  stages.add(const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Walk it off. Static stretching for hamstrings and quads.'));

  return Workout(
    title: '35-Min HIIT (NML)',
    description: '7 Circuits x 2 Sets. Strength (40s) / Power (30s). High intensity, total body.',
    stages: stages,
  );
}

TrainingPlan kettlebellPlan() {
  return TrainingPlan(
    id: 'kettlebell_simple_sinister',
    title: 'Kettlebell: Simple & Sinister',
    workoutType: WorkoutType.kettleBell,
    description: 'A minimalist program based on ladders and EMOM (Every Minute on the Minute) circuits. Focuses on the "big six" fundamental movements.',
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
  ladderStages.add(const WorkoutStage(
      name: 'Warm-up: Halos',
      duration: Duration(minutes: 2),
      description: 'Circle the bell around your head. Keep your core braced and ribs down to mobilize the shoulders.'
  ));

  // The Ladder Loop
  for (int i = startReps; i >= 2; i -= 2) { // 10, 8, 6, 4, 2
    ladderStages.add(WorkoutStage(
        name: '$i x KB Swings',
        duration: const Duration(seconds: 45),
        description: 'Hinge at the hips, snap to standing. Squeeze glutes at the top. Let the bell float momentarily before hiking it back.'
    ));
    ladderStages.add(WorkoutStage(
        name: '$i x Goblet Squats',
        duration: const Duration(seconds: 45),
        description: 'Hold bell by the horns at chest level. Sink deep, keeping elbows inside knees. Drive up through your heels.'
    ));
    ladderStages.add(const WorkoutStage(
        name: 'Rest',
        duration: Duration(seconds: 30),
        description: 'Nasal breathing. Shake out the tension in your arms and legs. Stay loose.'
    ));
  }

  ladderStages.add(const WorkoutStage(
      name: 'Cool-down',
      duration: Duration(minutes: 3),
      description: 'Light static stretching. Focus on hip flexors and hamstrings to unwind from the hinge movements.'
  ));

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
    description: '2 Cleans, 1 Press, 3 Squats. Repeat for rounds. Focus on smooth transitions between movements.',
    stages: [
      const WorkoutStage(
          name: 'Warm-up: Halos',
          duration: Duration(minutes: 2),
          description: 'Orbit the head with the bell. Keep glutes tight so only the shoulders move.'
      ),
      for(int i=1; i<=rounds; i++) ...[
        const WorkoutStage(
            name: '2 Cleans (Left)',
            duration: Duration(seconds: 20),
            description: 'Zip the bell up your centerline. Tame the arc to avoid banging your wrist. End in a strong rack position.'
        ),
        const WorkoutStage(
            name: '1 Overhead Press (Left)',
            duration: Duration(seconds: 15),
            description: 'Root feet into the floor. Squeeze glutes and press straight up. Bicep should end by the ear.'
        ),
        const WorkoutStage(
            name: '3 Goblet Squats',
            duration: Duration(seconds: 30),
            description: 'Hold the bell tight to your chest. Keep your chest proud and back flat as you descend.'
        ),
        // RIGHT SIDE
        const WorkoutStage(
            name: '2 Cleans (Right)',
            duration: Duration(seconds: 20),
            description: 'Switch hands. Hinge hips back, drive hips forward. Keep elbow tucked close to ribs.'
        ),
        const WorkoutStage(
            name: '1 Overhead Press (Right)',
            duration: Duration(seconds: 15),
            description: 'Maintain a tight core. Do not lean back. Lower the bell with control.'
        ),
        const WorkoutStage(
            name: 'Rest',
            duration: Duration(minutes: 1),
            description: 'Shake it off. Walk around to clear lactic acid. Prepare for the next round.'
        ),
      ],
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 3),
          description: 'Focus on chest openers and quad stretches.'
      ),
    ],
  );
}

Workout _fullBodyFlow(int week) {
  return Workout(
      title: 'Legs & Lungs',
      description: 'Lunges and Deadlifts for lower body power. Focus on balance and a strong posterior chain.',
      stages: [
        const WorkoutStage(
            name: 'Warm-up: Halos',
            duration: Duration(minutes: 2),
            description: 'Loosen up the shoulder girdle. Keep your head still.'
        ),

        // Circuit x 3
        for(int i=0; i<3; i++) ...[
          const WorkoutStage(
              name: 'Reverse Lunge (Left)',
              duration: Duration(seconds: 40),
              description: 'Hold bell in goblet or at side. Step back with control. Gently kiss the back knee to the floor.'
          ),
          const WorkoutStage(
              name: 'Reverse Lunge (Right)',
              duration: Duration(seconds: 40),
              description: 'Keep your front shin vertical. Drive through the front heel to return to standing.'
          ),
          const WorkoutStage(
              name: 'KB Deadlift',
              duration: Duration(seconds: 60),
              description: 'Place bell between feet. Hinge back. Grip hard. Drive feet through the floor to stand tall. Shoulders back.'
          ),
          const WorkoutStage(
              name: 'Rest',
              duration: Duration(seconds: 45),
              description: 'Focus on slowing your breath. Inhale deep, exhale slow.'
          ),
        ],
        const WorkoutStage(
            name: 'Cool-down',
            duration: Duration(minutes: 5),
            description: 'Deep breathing and static stretching. Focus on the lower back and hamstrings.'
        ),
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
          description: 'Light halos to loosen shoulders. Keep the ribs down and core engaged.'
      ),
      const WorkoutStage(
          name: 'Warm-up: Prying Squats',
          duration: Duration(minutes: 2),
          description: 'Goblet squat position. Use elbows to push knees out. Rock side to side to open the hips.'
      ),
      const WorkoutStage(
          name: 'Warm-up: Easy Swings',
          duration: Duration(minutes: 1),
          description: 'Two-handed easy swings to pattern the hinge. Focus on rhythm, not power yet.'
      ),
      // ---------------------

      // 20 Rounds = 30 Minutes total (10 rounds of each)
      for (int i = 1; i <= 20; i++)
        WorkoutStage(
            name: i.isOdd ? '10 Explosive Swings' : '10 Power Pushups',
            duration: const Duration(seconds: 90),
            description: i.isOdd
                ? 'Perform 10 Hardstyle Swings. Maximum power per rep! Snap the hips. Rest for the remainder of the 90s.'
                : 'Perform 10 Power Pushups. Maintain a rigid plank. Drive into the floor. Rest for the remainder of the 90s.'
        ),
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 5),
          description: 'Walk it off. Do not sit down immediately. Follow up with light stretching.'
      ),
    ],
  );
}