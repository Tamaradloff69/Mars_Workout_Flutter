import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/builders/workout_builder.dart';
import 'package:mars_workout_app/data/config/training_zones.dart';
import '../../models/training_plan.dart';
import '../../models/workout_model.dart';
import '../misc/misc_repository.dart';

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
  return WorkoutBuilder.buildRestDay();
}

Workout _discBaseRide(int mins) {
  return WorkoutBuilder.buildSteadyWorkout(title: 'Base Ride ($mins mins)', steadyMinutes: mins - 10, steadyDescription: CyclingZones.z2, workoutDescription: 'Steady aerobic miles. Focus on smooth pedal circles.', warmupDescription: CyclingZones.z0, cooldownDescription: CyclingZones.z1);
}

Workout _discRecoveryRide() {
  return const Workout(
    title: 'Recovery Ride (30m)',
    description: 'Flush out the legs. If you sweat, you are going too hard.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: CyclingZones.z0),
      WorkoutStage(name: 'Recovery Spin', duration: Duration(minutes: 20), description: CyclingZones.z1),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: CyclingZones.z1),
    ],
  );
}

Workout _discIMTGRide(int mins) {
  return Workout(
    title: 'IMTG Ride ($mins mins)',
    description: 'FASTED RIDE (No breakfast). Teaches body to burn fat. Keep intensity LOW.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: CyclingZones.z0),
      WorkoutStage(
        name: 'Fasted Zone 2',
        duration: Duration(minutes: mins),
        description: "${CyclingZones.z2}\nIMPORTANT: Do not spike your heart rate.",
      ),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: CyclingZones.z1),
    ],
  );
}

Workout _discIntervals(int warm, int sets, int work, int rest, int cool) {
  return WorkoutBuilder.buildTimeIntervals(
    title: 'Intervals ($sets x $work min)',
    workMinutes: work,
    restMinutes: rest,
    repetitions: sets,
    workDescription: CyclingZones.z4,
    workoutDescription: 'High intensity efforts to build speed and power.',
    restDescription: CyclingZones.z1,
    warmupMinutes: warm,
    cooldownMinutes: cool,
    warmupDescription: 'Progressive: Start Z0, build to Z2.',
    cooldownDescription: CyclingZones.z1,
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
        description: CyclingZones.z2,
      ),
      for (int i = 0; i < sets; i++) ...[
        WorkoutStage(
          name: 'Seated Climb',
          duration: Duration(minutes: work),
          description: "${CyclingZones.z3}\nTechnique: Stay seated, hands on tops, drive from the glutes.",
        ),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 8), description: CyclingZones.z1),
      ],
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cool),
        description: CyclingZones.z1,
      ),
    ],
  );
}

Workout _discPrimingRide() {
  return const Workout(
    title: 'Race Priming (30m)',
    description: 'Short ride with bursts to wake up the legs without fatigue.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: CyclingZones.z0),
      WorkoutStage(name: 'Accel 1', duration: Duration(minutes: 2), description: "${CyclingZones.z3}\nHigh gear strength."),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4), description: CyclingZones.z1),
      WorkoutStage(name: 'Accel 2', duration: Duration(minutes: 2), description: "${CyclingZones.z4}\nPick up speed."),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4), description: CyclingZones.z1),
      WorkoutStage(name: 'Accel 3', duration: Duration(minutes: 2), description: "${CyclingZones.z5}\nRace pace feeling!"),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 6), description: CyclingZones.z1),
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
    description: 'The perfect 12-week training guide to prepare for a 150km+ ride, leaving you feeling fit and ready. [cite: 1, 2]',
    difficulty: 'Advanced',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(12, (index) {
      int weekNum = index + 1;
      List<PlanDay> days = [];

      // HELPER: Build a cross training day
      PlanDay cross(int d) => buildDay(weekNum, d, 'Cross Training', _bnCrossTraining());
      // HELPER: Build a rest day
      PlanDay rest(int d) => buildDay(weekNum, d, 'Rest Day', WorkoutBuilder.buildRestDay());

      // --- WEEKLY SCHEDULE LOGIC BASED ON PDF TABLE  ---
      switch (weekNum) {
        case 1:
          days = [rest(1), buildDay(weekNum, 2, 'Aerobic Ride', _bnAerobicRide(60)), cross(3), buildDay(weekNum, 4, 'Aerobic Ride', _bnAerobicRide(60)), rest(5), cross(6), buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(90))];
          break;
        case 2:
          days = [buildDay(weekNum, 1, 'Aerobic Ride', _bnAerobicRide(60)), rest(2), cross(3), buildDay(weekNum, 4, 'Tempo Ride', _bnTempoRide(60)), rest(5), cross(6), buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(105))];
          break;
        case 3:
          days = [rest(1), buildDay(weekNum, 2, 'Tempo Ride', _bnTempoRide(60)), cross(3), buildDay(weekNum, 4, 'Aerobic Ride', _bnAerobicRide(90)), rest(5), cross(6), buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(150))];
          break;
        case 4:
          days = [rest(1), rest(2), buildDay(weekNum, 3, 'Aerobic Ride', _bnAerobicRide(90)), cross(4), buildDay(weekNum, 5, 'Tempo Ride', _bnTempoRide(60)), rest(6), buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(180))];
          break;
        case 5:
          days = [buildDay(weekNum, 1, 'Aerobic Ride', _bnAerobicRide(120)), rest(2), cross(3), buildDay(weekNum, 4, 'Tempo Ride', _bnTempoRide(75)), rest(5), buildDay(weekNum, 6, 'Endurance Ride', _bnEnduranceRide(90)), buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(210))];
          break;
        case 6:
          days = [
            buildDay(weekNum, 1, 'Aerobic Ride', _bnAerobicRide(120)),
            rest(2),
            buildDay(weekNum, 3, 'Sweet Spot Blocks', _bnSweetSpotWorkout(reps: 6, workMin: 5, restMin: 7)),
            cross(4),
            rest(5),
            buildDay(weekNum, 6, 'Aerobic Ride', _bnAerobicRide(105)),
            buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(225)),
          ];
          break;
        case 7:
          days = [
            rest(1),
            buildDay(weekNum, 2, 'High Cadence Drills', _bnHighCadenceDrills(8)),
            cross(3),
            buildDay(weekNum, 4, 'Sweet Spot Blocks', _bnSweetSpotWorkout(reps: 6, workMin: 5, restMin: 7)),
            rest(5),
            buildDay(weekNum, 6, 'Endurance Ride', _bnEnduranceRide(150)),
            buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(270)),
          ];
          break;
        case 8:
          days = [rest(1), rest(2), buildDay(weekNum, 3, 'Sweet Spot Blocks', _bnSweetSpotWorkout(reps: 5, workMin: 5, restMin: 7)), cross(4), buildDay(weekNum, 5, 'High Cadence Drills', _bnHighCadenceDrills(8)), rest(6), buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(240))];
          break;
        case 9:
          days = [
            rest(1),
            buildDay(weekNum, 2, 'Sweet Spot Blocks', _bnSweetSpotWorkout(reps: 6, workMin: 8, restMin: 5)),
            cross(3),
            buildDay(weekNum, 4, 'Aerobic Ride', _bnAerobicRide(120)),
            rest(5),
            buildDay(weekNum, 6, 'Endurance Ride', _bnEnduranceRide(135)),
            buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(300)),
          ];
          break;
        case 10:
          days = [
            rest(1),
            buildDay(weekNum, 2, 'Sweet Spot Blocks', _bnSweetSpotWorkout(reps: 6, workMin: 8, restMin: 5)),
            cross(3),
            buildDay(weekNum, 4, 'High Cadence Drills', _bnHighCadenceDrills(10)),
            rest(5),
            rest(6),
            buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(360)),
          ];
          break;
        case 11:
          days = [
            rest(1),
            buildDay(weekNum, 2, 'Sweet Spot Blocks', _bnSweetSpotWorkout(reps: 4, workMin: 8, restMin: 5)),
            cross(3),
            buildDay(weekNum, 4, 'High Cadence Drills', _bnHighCadenceDrills(10)),
            rest(5),
            buildDay(weekNum, 6, 'Endurance Ride', _bnEnduranceRide(150)),
            buildDay(weekNum, 7, 'Endurance Ride', _bnEnduranceRide(270)),
          ];
          break;
        case 12:
          days = [
            rest(1),
            rest(2),
            cross(3),
            rest(4),
            buildDay(weekNum, 5, 'Aerobic Ride', _bnAerobicRide(45)),
            buildDay(weekNum, 6, 'Optional Roll', _bnSteadyWorkout(
                title: 'Optional Roll',
                mins: 20,
                desc: 'Go for a light 20-minute roll if you would like to stay loose and get excited for tomorrow!'
            )),
            buildDay(weekNum, 7, 'EVENT DAY!', _bnEnduranceRide(420)), // Target 150km+ Event
          ];
          break;
      }

      return PlanWeek(weekNumber: weekNum, days: days);
    }),
  );
}

// --- UPDATED BN WORKOUT HELPERS TO MATCH PDF [cite: 11-33] ---

// --- COMPREHENSIVE BN WORKOUT HELPERS ---

Workout _bnCrossTraining() {
  return const Workout(
    title: 'Cross Training (60m)',
    description: 'Active recovery to move your body. Choose an activity like a light jog, swimming, gym circuits, pilates, or yoga to improve overall mobility and fitness.',
    stages: [
      WorkoutStage(
          name: 'Cross Training',
          duration: Duration(minutes: 60),
          description: 'Choose any low-impact movement. The goal is to keep the blood flowing and aid recovery without adding significant cycling fatigue.'
      ),
    ],
  );
}

Workout _bnAerobicRide(int totalMinutes) {
  return WorkoutBuilder.buildSteadyWorkout(
    title: 'Aerobic Ride ($totalMinutes mins)',
    steadyMinutes: totalMinutes - 10,
    steadyDescription: 'Maintain a steady effort of 3 to 4 out of 10. This is an "all day" pace where you feel comfortable and can easily hold a full conversation.',
    workoutDescription: 'Focus on aerobic base building. Includes a 5-minute gradual warm-up and a 5-minute cool-down to flush the legs.',
    warmupMinutes: 5,
    cooldownMinutes: 5,
  );
}

Workout _bnEnduranceRide(int totalMinutes) {
  return WorkoutBuilder.buildSteadyWorkout(
    title: 'Endurance Ride ($totalMinutes mins)',
    steadyMinutes: totalMinutes - 20,
    steadyDescription: 'Target a 3 to 4 out of 10 effort. Similar to an aerobic ride, focus on a sustainable pace that builds your stamina for long distances.',
    workoutDescription: 'Long-distance preparation. Includes a full 10-minute warm-up and a 10-minute cool-down to ensure proper recovery for the higher volume.',
    warmupMinutes: 10,
    cooldownMinutes: 10,
  );
}

Workout _bnTempoRide(int totalMinutes) {
  return WorkoutBuilder.buildSteadyWorkout(
    title: 'Tempo Ride ($totalMinutes mins)',
    steadyMinutes: totalMinutes - 15,
    steadyDescription: 'Step up the intensity to a 5 or 6 out of 10. Your breathing should be deep and rhythmic, making it difficult to maintain a continuous conversation.',
    workoutDescription: 'Builds sustained power. Includes a 10-minute warm-up to prepare the legs and a 5-minute cool-down.',
    warmupMinutes: 10,
    cooldownMinutes: 5,
  );
}

Workout _bnSweetSpotWorkout({required int reps, required int workMin, required int restMin}) {
  return Workout(
    title: 'Sweet Spot Blocks',
    description: 'High-intensity intervals at a 6 to 7 out of 10 effort. You should be breathing too hard to say more than one or two words at a time.',
    stages: [
      const WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: 15),
          description: 'Thorough 15-minute warm-up to prepare your cardiovascular system for Sweet Spot intensity.'
      ),
      for (int i = 1; i <= reps; i++) ...[
        WorkoutStage(
          name: 'Sweet Spot ($i/$reps)',
          duration: Duration(minutes: workMin),
          description: 'Work hard at 6-7/10 effort. You should be holding out for the recovery, finishing the block feeling like you could do one more, but would prefer not to!',
        ),
        WorkoutStage(
          name: 'Recovery',
          duration: Duration(minutes: restMin),
          description: 'Ease off the pressure and use this time to prepare your mind and body for the next effort.',
        ),
      ],
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 10),
          description: '10-minute easy spin to lower your heart rate and begin the recovery process.'
      ),
    ],
  );
}

Workout _bnHighCadenceDrills(int reps) {
  return Workout(
    title: 'High Cadence Drills ($reps reps)',
    description: 'Maximum leg speed intervals. Work should be at an 8 or 9 out of 10 effort scale, spinning the legs as quickly as possible.',
    stages: [
      const WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: 15),
          description: 'Essential 15-minute warm-up to ensure your muscles are ready for high-velocity spinning.'
      ),
      for (int i = 1; i <= reps; i++) ...[
         WorkoutStage(
            name: 'Spin-Up! ($i/$reps)',
            duration: const Duration(minutes: 1),
            description: 'The 1-minute effort will feel like a lifetime! Spin your legs as fast as you can while maintaining an 8-9/10 effort.'
        ),
        const WorkoutStage(
            name: 'Recovery',
            duration: Duration(minutes: 4),
            description: '4-minute easy recovery. Focus on deep breathing and clearing the legs to prepare for the next high-speed effort.'
        ),
      ],
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 10),
          description: '10-minute very light spinning to finish the session and aid muscle recovery.'
      ),
    ],
  );
}

Workout _bnSteadyWorkout({required String title, required int mins, required String desc}) {
  return Workout(
    title: title,
    description: 'A continuous, low-intensity effort. $desc',
    stages: [
      WorkoutStage(
          name: 'Steady State',
          duration: Duration(minutes: mins),
          description: 'Focus on a smooth pedal stroke and consistent breathing. This effort should feel like a 3 or 4 out of 10 on the intensity scale, a pace you could maintain for hours.'
      )
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
        description: CyclingZones.z0,
      ),
      for (int i = 0; i < (isShort ? 4 : 8); i++) ...[
        const WorkoutStage(name: 'Tempo Effort', duration: Duration(minutes: 2), description: CyclingZones.z3),
        const WorkoutStage(name: 'Max Sprint', duration: Duration(seconds: 30), description: CyclingZones.z5),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 2), description: CyclingZones.z1),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: CyclingZones.z1),
    ],
  );
}

Workout ladderIntervalsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Ladder Intervals (30m)' : 'Ladder Intervals (60m)',
    description: 'Progressively longer intervals.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: CyclingZones.z0),
      ...[1, 2, 3, 2, 1]
          .map(
            (min) => [
              WorkoutStage(
                name: '$min min Effort',
                duration: Duration(minutes: min),
                description: CyclingZones.z4,
              ),
              const WorkoutStage(name: 'Rest', duration: Duration(minutes: 1), description: CyclingZones.z1),
            ],
          )
          .expand((i) => i),
      if (!isShort) ...[
        const WorkoutStage(name: 'Set Break', duration: Duration(minutes: 5), description: CyclingZones.z1),
        ...[1, 2, 3, 2, 1]
            .map(
              (min) => [
                WorkoutStage(
                  name: '$min min Effort',
                  duration: Duration(minutes: min),
                  description: CyclingZones.z4,
                ),
                const WorkoutStage(name: 'Rest', duration: Duration(minutes: 1), description: CyclingZones.z1),
              ],
            )
            .expand((i) => i),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: CyclingZones.z1),
    ],
  );
}

Workout climbingBurstsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Climbing Bursts (30m)' : 'Climbing Bursts (60m)',
    description: 'Simulated hill attacks.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: CyclingZones.z0),
      for (int i = 0; i < (isShort ? 5 : 10); i++) ...[
        const WorkoutStage(name: 'Climb Base', duration: Duration(minutes: 3), description: "${CyclingZones.z3}\nLow cadence (60rpm)."),
        const WorkoutStage(name: 'Attack!', duration: Duration(seconds: 30), description: "${CyclingZones.z5}\nStand and Pedal 100%."),
        const WorkoutStage(name: 'Descend', duration: Duration(minutes: 1, seconds: 30), description: "${CyclingZones.z1}\nRecover high cadence."),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: CyclingZones.z1),
    ],
  );
}

Workout powerHourWorkout() {
  return const Workout(
    title: 'Power Hour: Sweet Spot',
    description: 'Sustained effort at 88-93% FTP.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: CyclingZones.z0),
      WorkoutStage(name: 'Sweet Spot 1', duration: Duration(minutes: 20), description: CyclingZones.sweetSpot),
      WorkoutStage(name: 'Recovery', duration: Duration(minutes: 5), description: CyclingZones.z1),
      WorkoutStage(name: 'Sweet Spot 2', duration: Duration(minutes: 20), description: CyclingZones.sweetSpot),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: CyclingZones.z1),
    ],
  );
}

Workout powerHourThreshold() {
  return const Workout(
    title: 'Power Hour: Threshold',
    description: 'Higher intensity intervals at 100% FTP.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: CyclingZones.z0),
      WorkoutStage(name: 'Threshold 1', duration: Duration(minutes: 10), description: CyclingZones.z4),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: CyclingZones.z1),
      WorkoutStage(name: 'Threshold 2', duration: Duration(minutes: 10), description: CyclingZones.z4),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: CyclingZones.z1),
      WorkoutStage(name: 'Threshold 3', duration: Duration(minutes: 10), description: CyclingZones.z4),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: CyclingZones.z1),
    ],
  );
}

Workout powerHourSteady() {
  return const Workout(
    title: 'Power Hour: Steady State',
    description: 'One long, unbroken effort.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: CyclingZones.z0),
      WorkoutStage(name: 'The Block', duration: Duration(minutes: 45), description: "${CyclingZones.z3}\nDo not stop."),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: CyclingZones.z1),
    ],
  );
}

Workout sundayRideWorkout() {
  return const Workout(
    title: 'Sunday Endurance',
    description: 'A very low-intensity ride to aid recovery.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: CyclingZones.z0),
      WorkoutStage(name: 'Steady State', duration: Duration(minutes: 40), description: CyclingZones.z2),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: CyclingZones.z1),
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
                WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: CyclingZones.z0),
                WorkoutStage(name: 'Main Set', duration: Duration(minutes: 30), description: CyclingZones.z2),
                WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: CyclingZones.z1),
              ],
            ),
          );
        }),
      );
    }),
  );
}
