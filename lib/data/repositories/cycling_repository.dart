import '../models/training_plan.dart';
import '../models/workout_model.dart';
import 'daily_repository.dart';

TrainingPlan cssFitness12WeekPlan() {
  return TrainingPlan(
    id: 'css_12_week',
    title: '12-Week Indoor Cycling Plan',
    description: 'A 12-week progression from CSS Fitness designed to improve speed, power, and climbing ability.',
    difficulty: 'Advanced',
    weeks: List.generate(12, (index) {
      int weekNum = index + 1;

      bool isBasePhase = weekNum >= 1 && weekNum <= 4;
      bool isBuildPhase = weekNum >= 5 && weekNum <= 8;
      bool isPeakPhase = weekNum >= 9 && weekNum <= 11;
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
      } else if (isPeakPhase) {
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
  return [
    powerHourWorkout(), // The original Sweet Spot version
    powerHourThreshold(),
    powerHourSteady(),
  ];
}




Workout speedIntervalsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Speed Intervals (30m)' : 'Speed Intervals (60m)',
    description: 'High-cadence efforts to improve leg speed. Use a comfortable gear and aim for as high a cadence (pedal speed) as possible.',
    stages: [
      // Warm-up -> Spin Easy
      WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: isShort ? 5 : 10),
          description: 'Ride in a low gear so that your legs are spinning easily. This is used for warmups, cooldowns, and recovery.'
      ),
      // Main Set
      for (int i = 0; i < (isShort ? 4 : 8); i++) ...[
        const WorkoutStage(
            name: 'Tempo Effort',
            duration: Duration(minutes: 2),
            description: '80% Effort: A strong, sustainable pace. You should be breathing heavily but able to hold a short conversation.'
        ),
        const WorkoutStage(
            name: 'Max Sprint',
            duration: Duration(seconds: 30),
            description: '100% Effort: Your maximum, all-out sprint or power. You cannot speak. Give it everything you have for the specified time.'
        ),
        const WorkoutStage(
            name: 'Recovery',
            duration: Duration(minutes: 2),
            description: 'Recover: Drop your pace back to a "Spin Easy" to let your heart rate come down before the next interval.'
        ),
      ],
      // Cool-down -> Spin Easy
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 5),
          description: 'Ride in a low gear so that your legs are spinning easily.'
      ),
    ],
  );
}

Workout ladderIntervalsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Ladder Intervals (30m)' : 'Ladder Intervals (60m)',
    description: 'Progressively longer intervals. ' 'A very hard pace, just below your maximum. You can only say one or two words at a time.',
    stages: [
      const WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: 5),
          description: 'Spin Easy: Ride in a low gear so that your legs are spinning easily.'
      ),
      // Ladder: 1 - 2 - 3 - 2 - 1
      ...[1, 2, 3, 2, 1].map((min) => [
        WorkoutStage(
            name: '$min min Effort',
            duration: Duration(minutes: min),
            description: '90% Effort: A very hard pace, just below your maximum. You can only say one or two words at a time.'
        ),
        const WorkoutStage(
            name: 'Rest',
            duration: Duration(minutes: 1),
            description: 'Recover: Drop your pace back to a "Spin Easy".'
        ),
      ]).expand((i) => i),

      if (!isShort) ...[
        const WorkoutStage(
            name: 'Set Break',
            duration: Duration(minutes: 5),
            description: 'Spin Easy: Active recovery between ladders.'
        ),
        ...[1, 2, 3, 2, 1].map((min) => [
          WorkoutStage(
              name: '$min min Effort',
              duration: Duration(minutes: min),
              description: '90% Effort: A very hard pace, just below your maximum.'
          ),
          const WorkoutStage(
              name: 'Rest',
              duration: Duration(minutes: 1),
              description: 'Recover: Drop your pace back to a "Spin Easy".'
          ),
        ]).expand((i) => i),
      ],
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 5),
          description: 'Ride in a low gear so that your legs are spinning easily.'
      ),
    ],
  );
}

Workout climbingBurstsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Climbing Bursts (30m)' : 'Climbing Bursts (60m)',
    description: 'Simulated hill attacks. ' 'Increase your gear/resistance, stand up out of the saddle, and attack the ‘climb’.',
    stages: [
      const WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: 5),
          description: 'Spin Easy: Ride in a low gear so that your legs are spinning easily.'
      ),
      for (int i = 0; i < (isShort ? 5 : 10); i++) ...[
        const WorkoutStage(
            name: 'Climb Base',
            duration: Duration(minutes: 3),
            description: '80% Effort: A strong, sustainable pace. Increase gear/resistance to lower cadence (60-70 RPM).'
        ),
        const WorkoutStage(
            name: 'Attack!',
            duration: Duration(seconds: 30),
            description: 'Stand and Pedal at 100%: Increase your gear/resistance, stand up out of the saddle, and attack the ‘climb’ at 100% effort.'
        ),
        const WorkoutStage(
            name: 'Descend',
            duration: Duration(minutes: 1, seconds: 30),
            description: 'Recover: Drop your pace back to a "Spin Easy" with high cadence to flush legs.'
        ),
      ],
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 5),
          description: 'Ride in a low gear so that your legs are spinning easily.'
      ),
    ],
  );
}

Workout powerHourWorkout() {
  return Workout(
    title: 'Power Hour: Sweet Spot',
    description: 'Sustained effort at 88-93% FTP. Uncomfortably comfortable building resilience.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Spin Easy: Gradual build.'),
      const WorkoutStage(name: 'Sweet Spot 1', duration: Duration(minutes: 20), description: '80% Effort: Strong, sustainable pace.'),
      const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 5), description: 'Recover: Spin Easy.'),
      const WorkoutStage(name: 'Sweet Spot 2', duration: Duration(minutes: 20), description: '80% Effort: Hold the effort!'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Spin Easy.'),
    ],
  );
}

// NEW Variant: Threshold
Workout powerHourThreshold() {
  return Workout(
    title: 'Power Hour: Threshold',
    description: 'Higher intensity intervals at 100% FTP. Mental toughness required.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Spin Easy.'),
      const WorkoutStage(name: 'Threshold 1', duration: Duration(minutes: 10), description: '90% Effort: Right below max sustainable.'),
      const WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: 'Recover: Spin Easy.'),
      const WorkoutStage(name: 'Threshold 2', duration: Duration(minutes: 10), description: '90% Effort: Keep cadence high.'),
      const WorkoutStage(name: 'Rest', duration: Duration(minutes: 5), description: 'Recover.'),
      const WorkoutStage(name: 'Threshold 3', duration: Duration(minutes: 10), description: '90% Effort: Empty the tank.'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: 'Spin Easy.'),
    ],
  );
}

// NEW Variant: Steady State
Workout powerHourSteady() {
  return Workout(
    title: 'Power Hour: Steady State',
    description: 'One long, unbroken effort at moderate intensity (Tempo).',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Spin Easy.'),
      const WorkoutStage(name: 'The Block', duration: Duration(minutes: 45), description: '80% Effort: Do not stop. Find a rhythm and stay there.'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Spin Easy.'),
    ],
  );
}
Workout sundayRideWorkout() {
  return Workout(
    title: 'Sunday Endurance',
    description: 'A very low-intensity ride to aid recovery and improve base fitness.',
    stages: [
      const WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: 10),
          description: 'Spin Easy: Ease into the ride.'
      ),
      const WorkoutStage(
          name: 'Steady State',
          duration: Duration(minutes: 40),
          description: 'Gentle Ride: A very low-intensity ride to aid recovery and improve base fitness. You should be able to hold a full conversation easily.'
      ),
      const WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: 10),
          description: 'Spin Easy: Easy spin to finish.'
      ),
    ],
  );
}

TrainingPlan cyclingPlan() {
  return TrainingPlan(
    id: 'cycling_12_week',
    title: '12-Week Indoor Cycling Plan',
    description: 'A comprehensive plan for building cycling endurance and power.',
    difficulty: 'Intermediate',
    weeks: List.generate(12, (weekIndex) {
      return PlanWeek(
        weekNumber: weekIndex + 1,
        days: List.generate(3, (dayIndex) {
          return PlanDay(
            id: 'cycling_w${weekIndex + 1}_d${dayIndex + 1}',
            title: 'Session ${dayIndex + 1}',
            workout: Workout(
              title: 'Endurance Ride',
              description: 'Focus on maintaining a steady pace.',
              stages: [
                const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Spin easy.'),
                const WorkoutStage(name: 'Main Set', duration: Duration(minutes: 30), description: 'Hold Zone 2/3 power.'),
                const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: 'Spin legs out.'),
              ],
            ),
          );
        }),
      );
    }),
  );
}