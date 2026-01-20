import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

// ==============================================================================
// ZONE / PACING DESCRIPTIONS (Rowing Specific)
// ==============================================================================
class RowPace {
  static const String steady =
      "Steady State (UT2): 18-20 SPM.\n"
      "Moderate effort. You should be able to hold a conversation. Focus on technique and rhythm.";

  static const String intermediateSteady =
      "Steady Distance: 20-24 SPM.\n"
      "Solid aerobic work. consistent split.";

  static const String hardDistance =
      "Hard Distance (UT1/AT): Unrestricted Rate.\n"
      "Faster than steady state. This is a time-trial effort (approx 80-90% max).";

  static const String speedInterval =
      "Speed Interval (TR): High Intensity.\n"
      "Row faster than your 2k race pace. Maximum sustainable power.";

  static const String enduranceInterval =
      "Endurance Interval (AT): 2k Pace.\n"
      "Hold your target 2k race pace. These are mentally tough.";
}

// ==============================================================================
// 1. INSIDE INDOOR: INTERMEDIATE 2KM PLAN (100% Accurate to PDF)
// ==============================================================================

TrainingPlan insideIndoorIntermediatePlan() {
  return TrainingPlan(
    id: 'inside_indoor_inter_2k',
    title: 'Inside Indoor: Intermediate 2km',
    description: 'The official 8-week British Rowing plan for improvers. Focuses on rate control (SPM) and building race pace.',
    difficulty: 'Intermediate',
    workoutType: WorkoutType.rowing,
    weeks: List.generate(8, (index) {
      int weekNum = index + 1;
      Workout session1;
      Workout session2;
      Workout session3; // Fitness Boost

      // --- WEEK 1 ---
      if (weekNum == 1) {
        // 10min Pyramid
        session1 = _iiPyramid(10, [2, 2, 2, 2, 2], [20, 22, 24, 22, 20]);
        // 2 sets of 3x1min
        session2 = _iiSetIntervals(2, 3, 1, 1);
        // 20min Steady
        session3 = _iiSteady(20, 'Fitness Boost: 20min Steady');
      }
      // --- WEEK 2 ---
      else if (weekNum == 2) {
        // 4 x 500m
        session1 = _iiDistanceIntervals(500, 120, 4, 'Target 2k Pace');
        // 12min Pyramid (3-2-2-2-3)
        session2 = _iiPyramid(12, [3, 2, 2, 2, 3], [20, 22, 24, 22, 20]);
        // 25min Steady
        session3 = _iiSteady(25, 'Fitness Boost: 25min Steady');
      }
      // --- WEEK 3 ---
      else if (weekNum == 3) {
        // 2 x 1000m
        session1 = _iiDistanceIntervals(1000, 240, 2, 'Target 2k Pace + 2-3s');
        // 10min Step
        session2 = _iiVariableSteps([5, 5], [22, 24], "10 min Step Up");
        // 30min Steady
        session3 = _iiSteady(30, 'Fitness Boost: 30min Steady');
      }
      // --- WEEK 4 ---
      else if (weekNum == 4) {
        // 4 x 500m (Faster)
        session1 = _iiDistanceIntervals(500, 120, 4, 'Target 2k Pace (Faster than Wk2)');
        // 14min Pyramid (3-3-2-3-3)
        session2 = _iiPyramid(14, [3, 3, 2, 3, 3], [20, 22, 24, 22, 20]);
        // 30min Steady
        session3 = _iiSteady(30, 'Fitness Boost: 30min Steady');
      }
      // --- WEEK 5 ---
      else if (weekNum == 5) {
        // 3 x 750m
        session1 = _iiDistanceIntervals(750, 180, 3, 'Target 2k Pace');
        // 12min Step (4-4-4)
        session2 = _iiVariableSteps([4, 4, 4], [22, 24, 22], "12 min Variation");
        // 30min Steady
        session3 = _iiSteady(30, 'Fitness Boost: 30min Steady');
      }
      // --- WEEK 6 ---
      else if (weekNum == 6) {
        // 2 sets of 4x1min
        session1 = _iiSetIntervals(2, 4, 1, 1);
        // 2 x 1000m (Faster)
        session2 = _iiDistanceIntervals(1000, 240, 2, 'Target 2k Pace (Faster than Wk3)');
        // 35min Steady
        session3 = _iiSteady(35, 'Fitness Boost: 35min Steady');
      }
      // --- WEEK 7 ---
      else if (weekNum == 7) {
        // 15min Step (5-5-5)
        session1 = _iiVariableSteps([5, 5, 5], [20, 22, 24], "15 min Build");
        // 3 x 750m (Faster)
        session2 = _iiDistanceIntervals(750, 180, 3, 'Target 2k Pace (Faster than Wk5)');
        // 35min Steady
        session3 = _iiSteady(35, 'Fitness Boost: 35min Steady');
      }
      // --- WEEK 8 (RACE WEEK) ---
      else {
        // 4 x 250m Sprints
        session1 = _iiDistanceIntervals(250, 120, 4, 'Sprints (High Rate)');
        // Light Paddle
        session2 = _iiSteady(10, 'Light Paddle (Recovery)');
        // 2K TEST
        session3 = _iiDistanceTest(2000, '2000m TEST');
      }

      return PlanWeek(
        weekNumber: weekNum,
        days: [
          PlanDay(id: 'ii_int_w${weekNum}_d1', title: 'Session 1', workout: session1),
          PlanDay(id: 'ii_int_w${weekNum}_d2', title: 'Session 2', workout: session2),
          PlanDay(id: 'ii_int_w${weekNum}_d3', title: 'Session 3', workout: session3),
        ],
      );
    }),
  );
}

// --- INTERMEDIATE HELPERS ---

Workout _iiPyramid(int totalMins, List<int> minutes, List<int> rates) {
  List<WorkoutStage> stages = [const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10))];

  for (int i = 0; i < minutes.length; i++) {
    stages.add(
      WorkoutStage(
        name: '${minutes[i]} min @ ${rates[i]} spm',
        duration: Duration(minutes: minutes[i]),
        description: 'Hold strict rate ${rates[i]}. Focus on power per stroke.',
      ),
    );
  }

  stages.add(const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)));

  return Workout(title: '$totalMins min Rate Pyramid', description: 'Control your stroke rate. Build intensity as rate goes up.', stages: stages);
}

Workout _iiSetIntervals(int sets, int reps, int workMin, int restMin) {
  List<WorkoutStage> stages = [const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10))];

  for (int s = 1; s <= sets; s++) {
    for (int r = 1; r <= reps; r++) {
      stages.add(
        WorkoutStage(
          name: 'Sprint ($r/$reps)',
          duration: Duration(minutes: workMin),
          description: 'High Intensity! Fast rating.',
        ),
      );
      if (r < reps) {
        stages.add(
          WorkoutStage(
            name: 'Rest',
            duration: Duration(minutes: restMin),
            description: 'Paddle light.',
          ),
        );
      }
    }
    // Rest between sets (3 mins usually per plan)
    if (s < sets) {
      stages.add(const WorkoutStage(name: 'Set Rest', duration: Duration(minutes: 3), description: 'Long recovery paddle.'));
    }
  }

  stages.add(const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)));

  return Workout(title: '$sets Sets of ($reps x ${workMin}min)', description: 'High intensity sprints. 1 min rest between reps, 3 min between sets.', stages: stages);
}

Workout _iiVariableSteps(List<int> minutes, List<int> rates, String title) {
  List<WorkoutStage> stages = [const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10))];

  int totalTime = 0;
  for (int i = 0; i < minutes.length; i++) {
    totalTime += minutes[i];
    stages.add(
      WorkoutStage(
        name: '${minutes[i]} min @ ${rates[i]} spm',
        duration: Duration(minutes: minutes[i]),
        description: 'Main set. Strict rate control.',
      ),
    );
  }

  stages.add(const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)));

  return Workout(title: title, description: '$totalTime min continuous row with rate changes.', stages: stages);
}

// ==============================================================================
// 2. INSIDE INDOOR BEGINNER 2KM PLAN
// Source: Inside Indoor / British Rowing "Go Row Indoor" Beginner Plan
// ==============================================================================

TrainingPlan insideIndoorBeginnerPlan() {
  return TrainingPlan(
    id: 'inside_indoor_beginner_2k',
    title: 'Inside Indoor: Beginner 2km',
    description: 'The official 8-week British Rowing plan. Builds from short intervals to your first continuous 2000m row.',
    difficulty: 'Beginner',
    workoutType: WorkoutType.rowing,
    weeks: List.generate(8, (index) {
      int weekNum = index + 1;
      Workout session1;
      Workout session2;
      Workout session3;

      if (weekNum == 1) {
        session1 = _iiIntervals(1, 1, 5, 'Low Intensity');
        session2 = _iiIntervals(5, 3, 2, 'Low Intensity');
        session3 = _iiSteady(10, 'Fitness Boost: 10 min Jog/Row mix');
      } else if (weekNum == 2) {
        session1 = _iiIntervals(2, 1, 5, 'Low Intensity');
        session2 = _iiIntervals(5, 3, 3, 'Low Intensity');
        session3 = _iiSteady(15, 'Fitness Boost: 15 min steady');
      } else if (weekNum == 3) {
        session1 = _iiDistanceIntervals(500, 120, 4, 'Medium Intensity');
        session2 = _iiVariableRow(10, '5 min Low, 5 min Medium');
        session3 = _iiSteady(20, 'Fitness Boost: 20 min steady');
      } else if (weekNum == 4) {
        session1 = _iiDistanceIntervals(1000, 300, 2, 'Medium Intensity');
        session2 = _iiVariableRow(15, '3m Low, 3m Med, 3m Low, 3m Med, 3m Low');
        session3 = _iiSteady(20, 'Fitness Boost: 20 min steady');
      } else if (weekNum == 5) {
        session1 = _iiStrokeBursts(5);
        session2 = _iiDistanceTest(2000, 'First 2km Attempt (Medium Intensity)');
        session3 = _iiSteady(20, 'Fitness Boost: 20 min steady');
      } else if (weekNum == 6) {
        session1 = _iiIntervals(1, 1, 6, 'High Intensity');
        session2 = _iiDistanceIntervals(500, 120, 4, 'Medium Intensity');
        session3 = _iiSteady(25, 'Fitness Boost: 25 min steady');
      } else if (weekNum == 7) {
        session1 = _iiBurstIntervals(1000, 2);
        session2 = _iiPyramidIntervals();
        session3 = _iiSteady(25, 'Fitness Boost: 25 min steady');
      } else {
        session1 = _iiIntervals(5, 3, 4, 'Medium Intensity');
        session2 = _iiMixedDistance();
        session3 = _iiDistanceTest(2000, 'FINAL 2KM TEST');
      }

      return PlanWeek(
        weekNumber: weekNum,
        days: [
          PlanDay(id: 'ii_w${weekNum}_d1', title: 'Session 1', workout: session1),
          PlanDay(id: 'ii_w${weekNum}_d2', title: 'Session 2', workout: session2),
          PlanDay(id: 'ii_w${weekNum}_d3', title: 'Session 3 (Optional)', workout: session3),
        ],
      );
    }),
  );
}

// --- INSIDE INDOOR / BRITISH ROWING BEGINNER HELPERS ---

Workout _iiIntervals(int workMin, int restMin, int reps, String intensity) {
  return Workout(
    title: '${workMin}min Intervals ($reps reps)',
    description: '$intensity. Focus on technique.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Pick drill & easy rowing.'),
      for (int i = 0; i < reps; i++) ...[
        WorkoutStage(
          name: 'Row',
          duration: Duration(minutes: workMin),
          description: '$intensity. Maintain consistent stroke rate (18-24).',
        ),
        WorkoutStage(
          name: 'Rest',
          duration: Duration(minutes: restMin),
          description: 'Light paddling or complete rest.',
        ),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _iiDistanceIntervals(int meters, int restSec, int reps, String intensity) {
  return Workout(
    title: '${meters}m Intervals ($reps reps)',
    description: '$intensity. Note your time for each piece.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      for (int i = 0; i < reps; i++) ...[
        WorkoutStage(
          name: '$meters meters',
          duration: Duration(minutes: (meters ~/ 200)),
          description: '$intensity. Estimated time.',
        ),
        WorkoutStage(
          name: 'Rest',
          duration: Duration(seconds: restSec),
          description: 'Recover.',
        ),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _iiSteady(int mins, String title) {
  return Workout(
    title: title,
    description: 'Continuous rowing at a sustainable pace.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 3)),
      WorkoutStage(
        name: 'Steady Row',
        duration: Duration(minutes: mins),
        description: 'Focus on posture and rhythm. 18-22 SPM.',
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 3)),
    ],
  );
}

Workout _iiVariableRow(int mins, String desc) {
  return Workout(
    title: '$mins min Variable Row',
    description: desc,
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      WorkoutStage(
        name: 'Variable Row',
        duration: Duration(minutes: mins),
        description: 'Follow the intensity changes described: $desc',
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _iiStrokeBursts(int reps) {
  return Workout(
    title: 'Stroke Bursts',
    description: '30 strokes low intensity, 10 strokes burst.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      for (int i = 0; i < reps; i++) ...[
        const WorkoutStage(name: '30 Strokes', duration: Duration(seconds: 90), description: 'Low intensity, focus on slide control.'),
        const WorkoutStage(name: '10 Strokes!', duration: Duration(seconds: 30), description: 'Medium intensity BURST! Drive hard with legs.'),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _iiDistanceTest(int meters, String title) {
  // Approximate duration placeholder for progress bar
  int estMin = meters ~/ 200;
  return Workout(
    title: title,
    description: 'Complete the distance. Record your time.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Thorough warm-up.'),
      WorkoutStage(
        name: '$meters meters',
        duration: Duration(minutes: estMin),
        description: 'Pace yourself. Aim for a consistent split.',
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout _iiBurstIntervals(int meters, int reps) {
  return Workout(
    title: '$meters m with Bursts',
    description: 'Medium intensity with high intensity bursts.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      for (int i = 0; i < reps; i++) ...[WorkoutStage(name: '$meters m Row', duration: const Duration(minutes: 5), description: 'Medium intensity. Every minute, include a 10-stroke HIGH intensity burst.'), const WorkoutStage(name: 'Rest', duration: Duration(minutes: 5))],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _iiPyramidIntervals() {
  return const Workout(
    title: 'Pyramid Intensity',
    description: '2 min Low, 2 Med, 1 High, 2 Med, 3 Low.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      // Set 1
      WorkoutStage(name: '2 min Low', duration: Duration(minutes: 2)),
      WorkoutStage(name: '2 min Med', duration: Duration(minutes: 2)),
      WorkoutStage(name: '1 min HIGH', duration: Duration(minutes: 1)),
      WorkoutStage(name: '2 min Med', duration: Duration(minutes: 2)),
      WorkoutStage(name: '3 min Low', duration: Duration(minutes: 3)),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5)),
      // Set 2
      WorkoutStage(name: '2 min Low', duration: Duration(minutes: 2)),
      WorkoutStage(name: '2 min Med', duration: Duration(minutes: 2)),
      WorkoutStage(name: '1 min HIGH', duration: Duration(minutes: 1)),
      WorkoutStage(name: '2 min Med', duration: Duration(minutes: 2)),
      WorkoutStage(name: '3 min Low', duration: Duration(minutes: 3)),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _iiMixedDistance() {
  return const Workout(
    title: 'Mixed Distances',
    description: '500m Med, 1000m Med, 500m High.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      WorkoutStage(name: '500m Med', duration: Duration(minutes: 2, seconds: 30)),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 2)),
      WorkoutStage(name: '1000m Med', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 2)),
      WorkoutStage(name: '500m HIGH', duration: Duration(minutes: 2)),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

// ==============================================================================
// 3. THE PETE PLAN (Continuous / Original)
// ==============================================================================

TrainingPlan thePetePlan() {
  return TrainingPlan(
    id: 'the_pete_plan_original',
    title: 'The Pete Plan (Original)',
    description: 'A continuous, 3-week cyclical plan for intermediate/advanced rowers.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.rowing,
    weeks: List.generate(12, (index) {
      int cycleWeek = (index % 3) + 1;
      int actualWeek = index + 1;

      Workout speedSession;
      Workout enduranceSession;

      if (cycleWeek == 1) {
        speedSession = _ppSpeed8x500();
        enduranceSession = _ppEndurance5x1500();
      } else if (cycleWeek == 2) {
        speedSession = _ppSpeedPyramid();
        enduranceSession = _ppEndurance4x2000();
      } else {
        // Week 3
        speedSession = _ppSpeed4x1000();
        enduranceSession = _ppEnduranceStepDown();
      }

      return PlanWeek(
        weekNumber: actualWeek,
        days: [
          PlanDay(id: 'pp_w${actualWeek}_d1', title: 'Speed Intervals', workout: speedSession),
          PlanDay(id: 'pp_w${actualWeek}_d2', title: 'Steady Distance', workout: _ppSteadyDistance()),
          PlanDay(id: 'pp_w${actualWeek}_d3', title: 'Endurance Intervals', workout: enduranceSession),
          PlanDay(id: 'pp_w${actualWeek}_d4', title: 'Steady Distance', workout: _ppSteadyDistance()),
          PlanDay(id: 'pp_w${actualWeek}_d5', title: 'Hard Distance', workout: _ppHardDistance()),
          PlanDay(id: 'pp_w${actualWeek}_d6', title: 'Steady Distance', workout: _ppSteadyDistance()),
          PlanDay(id: 'pp_w${actualWeek}_d7', title: 'Rest Day', workout: _ppRestDay()),
        ],
      );
    }),
  );
}

// --- PETE PLAN WORKOUT GENERATORS ---

Workout _ppRestDay() {
  return const Workout(
    title: 'Rest Day',
    description: 'Recover. Hydrate. Sleep.',
    stages: [WorkoutStage(name: 'Rest', duration: Duration(seconds: 1), description: 'Rest day complete.')],
  );
}

Workout _ppSteadyDistance() {
  return const Workout(
    title: 'Steady Distance (8k-15k)',
    description: 'Aerobic base building. Recommended: 10,000m or ~40-60 mins.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Steady Row (10km)', duration: Duration(minutes: 45), description: "${RowPace.steady}\nRate: 22-25 spm. Do not go too hard."),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _ppHardDistance() {
  return const Workout(
    title: 'Hard Distance (5k+)',
    description: 'A continuous hard piece. 5km, 6km, or 30mins.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'Hard 5k', duration: Duration(minutes: 20), description: "${RowPace.hardDistance}\nFaster than steady days. No rate limit."),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

// -- Speed Intervals (Week 1, 2, 3) --

Workout _ppSpeed8x500() {
  return Workout(
    title: '8 x 500m / 3:30r',
    description: 'Classic speed. Total: 4000m work.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      for (int i = 1; i <= 8; i++) ...[const WorkoutStage(name: '500m Sprint', duration: Duration(minutes: 1, seconds: 45), description: RowPace.speedInterval), const WorkoutStage(name: 'Rest', duration: Duration(minutes: 3, seconds: 30), description: 'Paddle light.')],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout _ppSpeedPyramid() {
  return const Workout(
    title: 'The Pyramid',
    description: '250m, 500m, 750m, 1k, 750m, 500m, 250m. Rest is 1:30 per 250m rowed.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      // 250m (Rest 1:30)
      WorkoutStage(name: '250m Sprint', duration: Duration(seconds: 50), description: RowPace.speedInterval),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 1, seconds: 30)),
      // 500m (Rest 3:00)
      WorkoutStage(name: '500m Sprint', duration: Duration(minutes: 1, seconds: 45), description: RowPace.speedInterval),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 3)),
      // 750m (Rest 4:30)
      WorkoutStage(name: '750m Sprint', duration: Duration(minutes: 2, seconds: 40), description: RowPace.speedInterval),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4, seconds: 30)),
      // 1000m (Rest 6:00) - The Peak
      WorkoutStage(name: '1000m Sprint', duration: Duration(minutes: 3, seconds: 40), description: RowPace.speedInterval),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 6)),
      // 750m (Rest 4:30)
      WorkoutStage(name: '750m Sprint', duration: Duration(minutes: 2, seconds: 40), description: RowPace.speedInterval),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4, seconds: 30)),
      // 500m (Rest 3:00)
      WorkoutStage(name: '500m Sprint', duration: Duration(minutes: 1, seconds: 45), description: RowPace.speedInterval),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 3)),
      // 250m (Done)
      WorkoutStage(name: '250m Sprint', duration: Duration(seconds: 50), description: "Empty the tank!"),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout _ppSpeed4x1000() {
  return Workout(
    title: '4 x 1000m / 5r',
    description: 'Longer speed intervals. Total: 4000m work.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      for (int i = 1; i <= 4; i++) ...[const WorkoutStage(name: '1000m Fast', duration: Duration(minutes: 3, seconds: 45), description: RowPace.speedInterval), const WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: 'Paddle light.')],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

// -- Endurance Intervals (Week 1, 2, 3) --

Workout _ppEndurance5x1500() {
  return Workout(
    title: '5 x 1500m / 5r',
    description: 'Endurance. Total: 7500m work.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      for (int i = 1; i <= 5; i++) ...[const WorkoutStage(name: '1500m Pace', duration: Duration(minutes: 6), description: RowPace.enduranceInterval), const WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: 'Paddle light.')],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout _ppEndurance4x2000() {
  return Workout(
    title: '4 x 2000m / 5r',
    description: 'The classic endurance grinder. Total: 8000m work.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      for (int i = 1; i <= 4; i++) ...[const WorkoutStage(name: '2000m Pace', duration: Duration(minutes: 8), description: RowPace.enduranceInterval), const WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: 'Paddle light.')],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout _ppEnduranceStepDown() {
  return const Workout(
    title: '3k, 2.5k, 2k / 5r',
    description: 'Descending distance. Get faster as it gets shorter.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      // 3000m
      WorkoutStage(name: '3000m', duration: Duration(minutes: 12), description: "Start slightly slower than 2k pace."),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5)),
      // 2500m
      WorkoutStage(name: '2500m', duration: Duration(minutes: 10), description: "Target 2k pace."),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5)),
      // 2000m
      WorkoutStage(name: '2000m', duration: Duration(minutes: 8), description: "Faster than 2k pace!"),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

// ==============================================================================
// 4. GENERAL ROWING MIX (Existing)
// ==============================================================================

TrainingPlan rowingPlan() {
  return const TrainingPlan(
    id: 'hydrow_rowing_mix',
    title: 'General Rowing Mix',
    description: 'Various workouts for general fitness.',
    difficulty: 'Beginner',
    workoutType: WorkoutType.rowing,
    weeks: [
      PlanWeek(
        weekNumber: 1,
        days: [
          PlanDay(
            id: 'rowing_w1_d1',
            title: 'Technique Focus',
            workout: Workout(
              title: 'Technique Drills',
              description: 'Pause drills and pick drills.',
              stages: [
                WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
                WorkoutStage(name: 'Drills', duration: Duration(minutes: 15)),
                WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
