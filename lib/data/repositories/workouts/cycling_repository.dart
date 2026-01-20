import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import '../../models/training_plan.dart';
import '../../models/workout_model.dart';
import '../misc/misc_repository.dart';

// ==============================================================================
// ZONE DESCRIPTIONS (Single Source of Truth)
// ==============================================================================
class ZoneDesc {
  static const String z0 =
      "Warm Up: Very light spinning.\n"
      "Get the blood flowing and legs ready. Minimal effort, just turning the pedals.";

  static const String z1 =
      "Active Recovery: Can sing a song.\n"
      "Very easy spinning with minimal resistance. Use this to flush out legs and recover.";

  static const String z2 =
      "Endurance: Can hold a full conversation.\n"
      "'All day' pace. You are working but not struggling. This burns fat and builds your aerobic engine.";

  static const String z3 =
      "Tempo: Can speak in short sentences.\n"
      "'Comfortably Hard.' You have to focus to keep this pace up. Breathing is deeper and rhythmic.";

  static const String sweetSpot =
      "Sweet Spot: Can speak a few words at a time.\n"
      "The 'Goldilocks' zone. Hard enough to build big power, but sustainable for long blocks (10-20m).";

  static const String z4 =
      "Threshold: Can hardly speak.\n"
      "Your 1-hour race pace. Legs start to burn significantly. Requires mental toughness to hold.";

  static const String z5 =
      "Max Effort: Cannot speak.\n"
      "All-out effort. Sprints or steep hill attacks. You should be gasping for air.";
}

// ==============================================================================
// 1. DISCOVERY 30KM BEGINNER PLAN
// ==============================================================================

TrainingPlan discovery30kmBeginnerPlan() {
  return TrainingPlan(
    id: 'discovery_30km_beginner',
    title: 'Discovery: Beginner 30km',
    description: 'The official 8-week Discovery Vitality programme. Designed to take you from zero to a comfortable 30km race finish.',
    difficulty: 'Beginner',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(8, (index) {
      int weekNum = index + 1;

      Workout tuesdayRide = _restDayWorkout();
      Workout thursdayRide = _restDayWorkout();
      Workout saturdayRide = _restDayWorkout();
      Workout sundayRide = _discRecoveryRide();

      // --- WEEKLY SCHEDULE ---
      if (weekNum == 1) {
        tuesdayRide = _discBaseRide(30);
        thursdayRide = _discBaseRide(40);
        saturdayRide = _discBaseRide(60);
      } else if (weekNum == 2) {
        tuesdayRide = _discIMTGRide(30);
        thursdayRide = _discBaseRide(45);
        saturdayRide = _discBaseRide(70);
      } else if (weekNum == 3) {
        tuesdayRide = _discIMTGRide(40);
        thursdayRide = _discIntervals(15, 4, 2, 4, 10);
        saturdayRide = _discBaseRide(70);
      } else if (weekNum == 4) {
        tuesdayRide = _discBaseRide(50);
        thursdayRide = _discIntervals(15, 4, 3, 4, 10);
        saturdayRide = _discBaseRide(80);
      } else if (weekNum == 5) {
        tuesdayRide = _discBaseRide(60);
        thursdayRide = _discHillIntervals(20, 2, 8, 10);
        saturdayRide = _discBaseRide(90);
      } else if (weekNum == 6) {
        tuesdayRide = _discHillIntervals(20, 3, 6, 10);
        thursdayRide = _discBaseRide(60);
        saturdayRide = _discBaseRide(100);
      } else if (weekNum == 7) {
        tuesdayRide = _discIntervals(20, 5, 2, 5, 20);
        thursdayRide = _discBaseRide(60);
        saturdayRide = _discBaseRide(75);
      } else if (weekNum == 8) {
        tuesdayRide = _discIntervals(20, 4, 2, 5, 10);
        thursdayRide = _discPrimingRide();
        saturdayRide = _restDayWorkout();
        sundayRide = _discRaceDayWorkout();
      }

      return PlanWeek(
        weekNumber: weekNum,
        days: [
          PlanDay(id: 'disc_w${weekNum}_d1', title: 'Rest Day', workout: _restDayWorkout()),
          PlanDay(id: 'disc_w${weekNum}_d2', title: 'Training Ride', workout: tuesdayRide),
          PlanDay(id: 'disc_w${weekNum}_d3', title: 'Rest Day', workout: _restDayWorkout()),
          PlanDay(id: 'disc_w${weekNum}_d4', title: 'Training Ride', workout: thursdayRide),
          PlanDay(id: 'disc_w${weekNum}_d5', title: 'Rest Day', workout: _restDayWorkout()),
          PlanDay(id: 'disc_w${weekNum}_d6', title: weekNum == 8 ? 'Rest Day' : 'Long Ride', workout: saturdayRide),
          PlanDay(id: 'disc_w${weekNum}_d7', title: weekNum == 8 ? 'RACE DAY' : 'Recovery Ride', workout: sundayRide),
        ],
      );
    }),
  );
}

// --- DISCOVERY WORKOUT HELPERS ---

Workout _restDayWorkout() {
  return const Workout(
    title: 'Rest Day',
    description: 'Rest is vital. Mark this day as complete to stay on track.',
    stages: [WorkoutStage(name: 'Resting...', duration: Duration(seconds: 1), description: 'Relax. Good sleep is the best recovery tool.')],
  );
}

Workout _discBaseRide(int mins) {
  return Workout(
    title: 'Base Ride ($mins mins)',
    description: 'Steady aerobic miles. Focus on smooth pedal circles.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: ZoneDesc.z0),
      WorkoutStage(
        name: 'Steady Ride',
        duration: Duration(minutes: mins - 10),
        description: ZoneDesc.z2,
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout _discRecoveryRide() {
  return const Workout(
    title: 'Recovery Ride (30m)',
    description: 'Flush out the legs. If you sweat, you are going too hard.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: ZoneDesc.z0),
      WorkoutStage(name: 'Recovery Spin', duration: Duration(minutes: 20), description: ZoneDesc.z1),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout _discIMTGRide(int mins) {
  return Workout(
    title: 'IMTG Ride ($mins mins)',
    description: 'FASTED RIDE (No breakfast). Teaches body to burn fat. Keep intensity LOW.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: ZoneDesc.z0),
      WorkoutStage(
        name: 'Fasted Zone 2',
        duration: Duration(minutes: mins),
        description: "${ZoneDesc.z2}\nIMPORTANT: Do not spike your heart rate.",
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout _discIntervals(int warm, int sets, int work, int rest, int cool) {
  return Workout(
    title: 'Intervals ($sets x $work min)',
    description: 'High intensity efforts to build speed and power.',
    stages: [
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warm),
        description: "Progressive: Start Z0, build to Z2.",
      ),
      for (int i = 0; i < sets; i++) ...[
        WorkoutStage(
          name: 'Hard Effort',
          duration: Duration(minutes: work),
          description: ZoneDesc.z4,
        ),
        WorkoutStage(
          name: 'Recovery',
          duration: Duration(minutes: rest),
          description: ZoneDesc.z1,
        ),
      ],
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cool),
        description: ZoneDesc.z1,
      ),
    ],
  );
}

Workout _discHillIntervals(int warm, int sets, int work, int cool) {
  return Workout(
    title: 'Hill Repeats ($sets x $work min)',
    description: 'Seated climbing strength. Keep cadence low (50-65 RPM) to simulate a steep gradient.',
    stages: [
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warm),
        description: ZoneDesc.z2,
      ),
      for (int i = 0; i < sets; i++) ...[
        WorkoutStage(
          name: 'Seated Climb',
          duration: Duration(minutes: work),
          description: "${ZoneDesc.z3}\nTechnique: Stay seated, hands on tops, drive from the glutes.",
        ),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 8), description: ZoneDesc.z1),
      ],
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cool),
        description: ZoneDesc.z1,
      ),
    ],
  );
}

Workout _discPrimingRide() {
  return const Workout(
    title: 'Race Priming (30m)',
    description: 'Short ride with bursts to wake up the legs without fatigue.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
      WorkoutStage(name: 'Accel 1', duration: Duration(minutes: 2), description: "${ZoneDesc.z3}\nHigh gear strength."),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4), description: ZoneDesc.z1),
      WorkoutStage(name: 'Accel 2', duration: Duration(minutes: 2), description: "${ZoneDesc.z4}\nPick up speed."),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4), description: ZoneDesc.z1),
      WorkoutStage(name: 'Accel 3', duration: Duration(minutes: 2), description: "${ZoneDesc.z5}\nRace pace feeling!"),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 6), description: ZoneDesc.z1),
    ],
  );
}

Workout _discRaceDayWorkout() {
  return const Workout(
    title: '30KM RACE',
    description: 'Race Day! Start steady, finish strong.',
    stages: [WorkoutStage(name: 'The Race', duration: Duration(minutes: 90), description: 'Start in Z3 (Tempo). Save Z5 (Max Effort) for the last 5km!')],
  );
}

// ==============================================================================
// 2. BICYCLE NETWORK 150KM PLAN
// ==============================================================================

TrainingPlan bicycleNetwork150kmPlan() {
  return TrainingPlan(
    id: 'bn_150km_classic',
    title: 'Bicycle Network: 150km Classic',
    description: '12-week guide for 150km endurance. Focuses on Sweet Spot and long miles.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(12, (index) {
      int weekNum = index + 1;
      List<PlanDay> days = [];

      if (weekNum <= 4) {
        int enduranceMins = 90 + ((weekNum - 1) * 15);
        days = [
          buildDay(weekNum, 2, 'Aerobic Ride (60m)', _bnAerobicRide(60)),
          buildDay(weekNum, 4, weekNum == 3 ? 'Tempo Ride (60m)' : 'Aerobic Ride (60m)', weekNum == 3 ? _bnTempoRide(60) : _bnAerobicRide(60)),
          buildDay(weekNum, 7, 'Endurance Ride (${enduranceMins}m)', _bnEnduranceRide(enduranceMins)),
        ];
      } else if (weekNum <= 8) {
        bool isSweetSpotWeek = weekNum >= 6;
        int enduranceMins = 210 + ((weekNum - 5) * 15);
        days = [
          buildDay(weekNum, 2, 'Aerobic Ride (2h)', _bnAerobicRide(120)),
          buildDay(weekNum, 4, isSweetSpotWeek ? 'Sweet Spot Blocks' : 'Tempo Ride', isSweetSpotWeek ? _bnSweetSpotWorkout(weekNum) : _bnTempoRide(75)),
          buildDay(weekNum, 7, 'Endurance Ride ($enduranceMins m)', _bnEnduranceRide(enduranceMins)),
        ];
      } else {
        if (weekNum == 12) {
          days = [buildDay(weekNum, 3, 'Taper: Aerobic (45m)', _bnAerobicRide(45)), buildDay(weekNum, 7, 'EVENT DAY: 150KM', _bnEnduranceRide(360))];
        } else {
          days = [buildDay(weekNum, 2, 'Sweet Spot Intervals', _bnSweetSpotWorkout(weekNum)), buildDay(weekNum, 4, 'High Cadence Drills', _bnHighCadenceDrills()), buildDay(weekNum, 7, 'Long Endurance Ride', _bnEnduranceRide(weekNum == 10 ? 360 : 270))];
        }
      }
      return PlanWeek(weekNumber: weekNum, days: days);
    }),
  );
}

Workout _bnAerobicRide(int totalMinutes) {
  return Workout(
    title: 'Aerobic Ride ($totalMinutes mins)',
    description: 'Ride at a pace you could ride all day.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: ZoneDesc.z0),
      WorkoutStage(
        name: 'Aerobic Base',
        duration: Duration(minutes: totalMinutes - 10),
        description: ZoneDesc.z2,
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout _bnTempoRide(int totalMinutes) {
  return Workout(
    title: 'Tempo Ride ($totalMinutes mins)',
    description: 'Harder than aerobic. Breathing becomes audible.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
      WorkoutStage(
        name: 'Tempo Effort',
        duration: Duration(minutes: totalMinutes - 15),
        description: ZoneDesc.z3,
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout _bnEnduranceRide(int totalMinutes) {
  return Workout(
    title: 'Endurance Ride (${(totalMinutes / 60).toStringAsFixed(1)} hrs)',
    description: 'Long steady distance. Build mental and physical stamina.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
      WorkoutStage(
        name: 'The Long Ride',
        duration: Duration(minutes: totalMinutes - 20),
        description: ZoneDesc.z2,
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: ZoneDesc.z1),
    ],
  );
}

Workout _bnSweetSpotWorkout(int week) {
  int reps = week >= 9 ? 6 : 6;
  int workMin = week >= 9 ? 8 : 5;
  int restMin = week >= 9 ? 5 : 7;

  return Workout(
    title: 'Sweet Spot Blocks',
    description: 'Effort just below your threshold.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 15), description: ZoneDesc.z2),
      for (int i = 0; i < reps; i++) ...[
        WorkoutStage(
          name: 'Sweet Spot',
          duration: Duration(minutes: workMin),
          description: ZoneDesc.sweetSpot,
        ),
        WorkoutStage(
          name: 'Recovery',
          duration: Duration(minutes: restMin),
          description: ZoneDesc.z1,
        ),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: ZoneDesc.z1),
    ],
  );
}

Workout _bnHighCadenceDrills() {
  return Workout(
    title: 'High Cadence Drills',
    description: '1 min fast spin, 4 min recovery. Improves efficiency.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 15), description: ZoneDesc.z2),
      for (int i = 0; i < 8; i++) ...[const WorkoutStage(name: 'Spin-Up!', duration: Duration(minutes: 1), description: "Max RPM: Spin as fast as you can without bouncing in the saddle (100-120 RPM)."), const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 4), description: ZoneDesc.z1)],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: ZoneDesc.z1),
    ],
  );
}

// ==============================================================================
// 3. CSS FITNESS (Legacy Plans)
// ==============================================================================

TrainingPlan cssFitness12WeekPlan() {
  return TrainingPlan(
    id: 'css_12_week',
    title: 'CSS Fitness: 12-Week Indoor',
    description: 'A 12-week progression designed to improve speed, power, and climbing ability.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(12, (index) {
      int weekNum = index + 1;
      bool isBasePhase = weekNum >= 1 && weekNum <= 4;
      bool isBuildPhase = weekNum >= 5 && weekNum <= 8;
      bool isTaperPhase = weekNum == 12;

      List<PlanDay> days = [];

      if (isBasePhase || isTaperPhase) {
        days = [
          buildDay(weekNum, 1, 'Speed Intervals (30m)', speedIntervalsWorkout(isShort: true)),
          buildDay(weekNum, 3, 'Ladder Intervals (30m)', ladderIntervalsWorkout(isShort: true)),
          buildDay(weekNum, 5, 'Climbing Bursts (30m)', climbingBurstsWorkout(isShort: true)),
          buildDay(weekNum, 7, 'Sunday Endurance (60m)', sundayRideWorkout()),
        ];
      } else if (isBuildPhase) {
        days = [
          buildDay(weekNum, 1, 'Speed Intervals (60m)', speedIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 3, 'Ladder Intervals (60m)', ladderIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 5, 'Climbing Bursts (60m)', climbingBurstsWorkout(isShort: false)),
          buildDay(weekNum, 7, 'Sunday Endurance (60m)', sundayRideWorkout()),
        ];
      } else {
        // Peak
        days = [
          buildDay(weekNum, 1, 'Speed Intervals (60m)', speedIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 2, 'Ladder Intervals (60m)', ladderIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 4, 'Climbing Bursts (60m)', climbingBurstsWorkout(isShort: false)),
          buildDay(weekNum, 5, 'Power Hour (Hard Choice)', powerHourWorkout()),
          buildDay(weekNum, 7, 'Sunday Endurance (60m)', sundayRideWorkout()),
        ];
      }
      return PlanWeek(weekNumber: weekNum, days: days);
    }),
  );
}

List<Workout> getPowerHourOptions() {
  return [powerHourWorkout(), powerHourThreshold(), powerHourSteady()];
}

Workout speedIntervalsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Speed Intervals (30m)' : 'Speed Intervals (60m)',
    description: 'High-cadence efforts to improve leg speed.',
    stages: [
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: isShort ? 5 : 10),
        description: ZoneDesc.z0,
      ),
      for (int i = 0; i < (isShort ? 4 : 8); i++) ...[
        const WorkoutStage(name: 'Tempo Effort', duration: Duration(minutes: 2), description: ZoneDesc.z3),
        const WorkoutStage(name: 'Max Sprint', duration: Duration(seconds: 30), description: ZoneDesc.z5),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 2), description: ZoneDesc.z1),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout ladderIntervalsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Ladder Intervals (30m)' : 'Ladder Intervals (60m)',
    description: 'Progressively longer intervals.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: ZoneDesc.z0),
      ...[1, 2, 3, 2, 1]
          .map(
            (min) => [
              WorkoutStage(
                name: '$min min Effort',
                duration: Duration(minutes: min),
                description: ZoneDesc.z4,
              ),
              const WorkoutStage(name: 'Rest', duration: Duration(minutes: 1), description: ZoneDesc.z1),
            ],
          )
          .expand((i) => i),
      if (!isShort) ...[
        const WorkoutStage(name: 'Set Break', duration: Duration(minutes: 5), description: ZoneDesc.z1),
        ...[1, 2, 3, 2, 1]
            .map(
              (min) => [
                WorkoutStage(
                  name: '$min min Effort',
                  duration: Duration(minutes: min),
                  description: ZoneDesc.z4,
                ),
                const WorkoutStage(name: 'Rest', duration: Duration(minutes: 1), description: ZoneDesc.z1),
              ],
            )
            .expand((i) => i),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout climbingBurstsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Climbing Bursts (30m)' : 'Climbing Bursts (60m)',
    description: 'Simulated hill attacks.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: ZoneDesc.z0),
      for (int i = 0; i < (isShort ? 5 : 10); i++) ...[
        const WorkoutStage(name: 'Climb Base', duration: Duration(minutes: 3), description: "${ZoneDesc.z3}\nLow cadence (60rpm)."),
        const WorkoutStage(name: 'Attack!', duration: Duration(seconds: 30), description: "${ZoneDesc.z5}\nStand and Pedal 100%."),
        const WorkoutStage(name: 'Descend', duration: Duration(minutes: 1, seconds: 30), description: "${ZoneDesc.z1}\nRecover high cadence."),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout powerHourWorkout() {
  return const Workout(
    title: 'Power Hour: Sweet Spot',
    description: 'Sustained effort at 88-93% FTP.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
      WorkoutStage(name: 'Sweet Spot 1', duration: Duration(minutes: 20), description: ZoneDesc.sweetSpot),
      WorkoutStage(name: 'Recovery', duration: Duration(minutes: 5), description: ZoneDesc.z1),
      WorkoutStage(name: 'Sweet Spot 2', duration: Duration(minutes: 20), description: ZoneDesc.sweetSpot),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout powerHourThreshold() {
  return const Workout(
    title: 'Power Hour: Threshold',
    description: 'Higher intensity intervals at 100% FTP.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
      WorkoutStage(name: 'Threshold 1', duration: Duration(minutes: 10), description: ZoneDesc.z4),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: ZoneDesc.z1),
      WorkoutStage(name: 'Threshold 2', duration: Duration(minutes: 10), description: ZoneDesc.z4),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: ZoneDesc.z1),
      WorkoutStage(name: 'Threshold 3', duration: Duration(minutes: 10), description: ZoneDesc.z4),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: ZoneDesc.z1),
    ],
  );
}

Workout powerHourSteady() {
  return const Workout(
    title: 'Power Hour: Steady State',
    description: 'One long, unbroken effort.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
      WorkoutStage(name: 'The Block', duration: Duration(minutes: 45), description: "${ZoneDesc.z3}\nDo not stop."),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: ZoneDesc.z1),
    ],
  );
}

Workout sundayRideWorkout() {
  return const Workout(
    title: 'Sunday Endurance',
    description: 'A very low-intensity ride to aid recovery.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
      WorkoutStage(name: 'Steady State', duration: Duration(minutes: 40), description: ZoneDesc.z2),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: ZoneDesc.z1),
    ],
  );
}

TrainingPlan cyclingPlan() {
  return TrainingPlan(
    id: 'cycling_12_week',
    title: 'Cycling: 12-Week Power',
    description: 'A comprehensive plan for building cycling endurance and power.',
    difficulty: 'Intermediate',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(12, (weekIndex) {
      return PlanWeek(
        weekNumber: weekIndex + 1,
        days: List.generate(3, (dayIndex) {
          return PlanDay(
            id: 'cycling_w${weekIndex + 1}_d${dayIndex + 1}',
            title: 'Session ${dayIndex + 1}',
            workout: const Workout(
              title: 'Endurance Ride',
              description: 'Focus on maintaining a steady pace.',
              stages: [
                WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: ZoneDesc.z0),
                WorkoutStage(name: 'Main Set', duration: Duration(minutes: 30), description: ZoneDesc.z2),
                WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: ZoneDesc.z1),
              ],
            ),
          );
        }),
      );
    }),
  );
}
