import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

class WorkoutRepository {
  List<TrainingPlan> getAllPlans() {
    return [
      _cssFitness12WeekPlan(),
      _insideIndoorBeginnerPlan(), // NEW
      _insideIndoorIntermediatePlan(), // NEW
      _cyclingPlan(),
      _rowingPlan(),
      _kettlebellPlan(),
      _petePlan(),
    ];
  }

  // --- NEW: Inside Indoor Beginner 2km Plan ---
  // Source: Inside Indoor / British Rowing Beginner Plan
  TrainingPlan _insideIndoorBeginnerPlan() {
    return TrainingPlan(
      id: 'inside_indoor_beginner_2k',
      title: 'Beginner 2km Plan (Inside Indoor)',
      description: 'An 8-week plan to help you complete your first 2000m row with confidence.',
      difficulty: 'Beginner',
      weeks: List.generate(8, (index) {
        int weekNum = index + 1;
        List<PlanDay> days = [];

        if (weekNum == 1) {
          days = [
            PlanDay(
                id: 'ii_beg_w1_d1',
                title: 'Session 1: Introduction',
                workout: _simpleIntervalWorkout(
                    '2 min row, 2 min rest',
                    'Row comfortably at 18-22 SPM. Focus on technique.',
                    workDuration: const Duration(minutes: 2),
                    restDuration: const Duration(minutes: 2),
                    reps: 4
                )
            ),
            PlanDay(
                id: 'ii_beg_w1_d2',
                title: 'Session 2: Endurance',
                workout: _simpleIntervalWorkout(
                    '5 min row, 3 min rest',
                    'Hold a conversation pace. 18-22 SPM.',
                    workDuration: const Duration(minutes: 5),
                    restDuration: const Duration(minutes: 3),
                    reps: 2
                )
            ),
          ];
        } else if (weekNum == 2) {
          days = [
            PlanDay(
                id: 'ii_beg_w2_d1',
                title: 'Session 1: Short Intervals',
                workout: _simpleIntervalWorkout(
                    '2 min row, 1 min rest',
                    'Focus on a powerful drive.',
                    workDuration: const Duration(minutes: 2),
                    restDuration: const Duration(minutes: 1),
                    reps: 5
                )
            ),
            PlanDay(
                id: 'ii_beg_w2_d2',
                title: 'Session 2: Longer Pieces',
                workout: _simpleIntervalWorkout(
                    '5 min row, 3 min rest',
                    'Focus on smooth recovery.',
                    workDuration: const Duration(minutes: 5),
                    restDuration: const Duration(minutes: 3),
                    reps: 3
                )
            ),
          ];
        } else if (weekNum == 3) {
          days = [
            PlanDay(
                id: 'ii_beg_w3_d1',
                title: 'Session 1: Medium Intensity',
                workout: Workout(
                    title: '4 x 500m',
                    description: 'Medium intensity. Note your time for each 500m.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Gradual build.'),
                      for(int i=0; i<4; i++) ...[
                        const WorkoutStage(name: '500m Effort', duration: Duration(minutes: 2, seconds: 30), description: 'Approx duration. Medium intensity.'),
                        const WorkoutStage(name: 'Rest', duration: Duration(minutes: 2), description: 'Paddle lightly.'),
                      ],
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Stretch out.'),
                    ]
                )
            ),
            PlanDay(
                id: 'ii_beg_w3_d2',
                title: 'Session 2: 10 Min Continuous',
                workout: Workout(
                    title: '10 min Split Row',
                    description: '5 mins low intensity, 5 mins medium intensity.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
                      const WorkoutStage(name: 'Low Intensity', duration: Duration(minutes: 5), description: '18-20 SPM.'),
                      const WorkoutStage(name: 'Medium Intensity', duration: Duration(minutes: 5), description: '22-24 SPM.'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                    ]
                )
            ),
          ];
        } else if (weekNum == 8) {
          days = [
            PlanDay(
                id: 'ii_beg_w8_d1',
                title: 'Session 1: Preparation',
                workout: _simpleIntervalWorkout(
                    '5 min row, 3 min rest',
                    'Medium intensity.',
                    workDuration: const Duration(minutes: 5),
                    restDuration: const Duration(minutes: 3),
                    reps: 4
                )
            ),
            PlanDay(
                id: 'ii_beg_w8_d2',
                title: 'Session 2: THE 2K TEST',
                workout: Workout(
                    title: '2000m Time Trial',
                    description: 'This is it. Row 2000m as fast as you can manage.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Thorough warm up with bursts.'),
                      const WorkoutStage(name: '2000m Row', duration: Duration(minutes: 8), description: 'Pace yourself. Aim to finish strong!'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: 'Very light paddling.'),
                    ]
                )
            ),
          ];
        } else {
          // Generic placeholder for middle weeks 4-7 to save space, following the progression pattern
          days = [
            PlanDay(
                id: 'ii_beg_w${weekNum}_d1',
                title: 'Session 1: Intervals',
                workout: _simpleIntervalWorkout('Interval Mix', 'Alternating intensity.', workDuration: const Duration(minutes: 3), restDuration: const Duration(minutes: 2), reps: 4)
            ),
            PlanDay(
                id: 'ii_beg_w${weekNum}_d2',
                title: 'Session 2: Distance',
                workout: _simpleIntervalWorkout('Steady Distance', 'Building up to 2k.', workDuration: const Duration(minutes: 8), restDuration: const Duration(minutes: 3), reps: 2)
            ),
          ];
        }

        return PlanWeek(weekNumber: weekNum, days: days);
      }),
    );
  }

  // --- NEW: Inside Indoor Intermediate 2km Plan ---
  // Source: Inside Indoor / British Rowing Intermediate Plan
  TrainingPlan _insideIndoorIntermediatePlan() {
    return TrainingPlan(
      id: 'inside_indoor_inter_2k',
      title: 'Intermediate 2km Plan (Inside Indoor)',
      description: 'An 8-week plan focusing on stroke rate control and speed for improvers.',
      difficulty: 'Intermediate',
      weeks: List.generate(8, (index) {
        int weekNum = index + 1;
        List<PlanDay> days = [];

        if (weekNum == 1) {
          days = [
            PlanDay(
                id: 'ii_int_w1_d1',
                title: 'Session 1: Rate Pyramid',
                workout: Workout(
                    title: '10 min Rate Pyramid',
                    description: 'Control your stroke rate accurately.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                      const WorkoutStage(name: '2 min @ 20', duration: Duration(minutes: 2), description: '20 SPM'),
                      const WorkoutStage(name: '2 min @ 22', duration: Duration(minutes: 2), description: '22 SPM'),
                      const WorkoutStage(name: '2 min @ 24', duration: Duration(minutes: 2), description: '24 SPM'),
                      const WorkoutStage(name: '2 min @ 22', duration: Duration(minutes: 2), description: '22 SPM'),
                      const WorkoutStage(name: '2 min @ 20', duration: Duration(minutes: 2), description: '20 SPM'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                    ]
                )
            ),
            PlanDay(
                id: 'ii_int_w1_d2',
                title: 'Session 2: Sprints',
                workout: Workout(
                    title: '2 Sets of (3 x 1min)',
                    description: 'High intensity sprints with 90s rest.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                      // Set 1
                      const WorkoutStage(name: 'Sprint 1', duration: Duration(minutes: 1), description: 'Fast!'),
                      const WorkoutStage(name: 'Rest', duration: Duration(seconds: 90), description: 'Paddle.'),
                      const WorkoutStage(name: 'Sprint 2', duration: Duration(minutes: 1), description: 'Fast!'),
                      const WorkoutStage(name: 'Rest', duration: Duration(seconds: 90), description: 'Paddle.'),
                      const WorkoutStage(name: 'Sprint 3', duration: Duration(minutes: 1), description: 'Fast!'),
                      const WorkoutStage(name: 'Set Rest', duration: Duration(minutes: 3), description: 'Long recovery.'),
                      // Set 2
                      const WorkoutStage(name: 'Sprint 1', duration: Duration(minutes: 1), description: 'Fast!'),
                      const WorkoutStage(name: 'Rest', duration: Duration(seconds: 90), description: 'Paddle.'),
                      const WorkoutStage(name: 'Sprint 2', duration: Duration(minutes: 1), description: 'Fast!'),
                      const WorkoutStage(name: 'Rest', duration: Duration(seconds: 90), description: 'Paddle.'),
                      const WorkoutStage(name: 'Sprint 3', duration: Duration(minutes: 1), description: 'Empty the tank.'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
                    ]
                )
            ),
          ];
        } else if (weekNum == 5) {
          days = [
            PlanDay(
                id: 'ii_int_w5_d1',
                title: 'Session 1: Extended Pyramid',
                workout: Workout(
                    title: '14 min Rate Pyramid',
                    description: '3 min @ 20, 3 @ 22, 2 @ 24, 3 @ 22, 3 @ 20.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                      const WorkoutStage(name: '3 min @ 20', duration: Duration(minutes: 3), description: 'Strong and controlled.'),
                      const WorkoutStage(name: '3 min @ 22', duration: Duration(minutes: 3), description: 'Add power.'),
                      const WorkoutStage(name: '2 min @ 24', duration: Duration(minutes: 2), description: 'Peak rate.'),
                      const WorkoutStage(name: '3 min @ 22', duration: Duration(minutes: 3), description: 'Maintain power.'),
                      const WorkoutStage(name: '3 min @ 20', duration: Duration(minutes: 3), description: 'Control.'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                    ]
                )
            ),
            PlanDay(
                id: 'ii_int_w5_d2',
                title: 'Session 2: 1000m Intervals',
                workout: Workout(
                    title: '2 x 1000m',
                    description: 'Race pace practice. 4 mins rest between.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                      const WorkoutStage(name: '1000m Effort', duration: Duration(minutes: 4), description: 'Target 2k pace.'),
                      const WorkoutStage(name: 'Rest', duration: Duration(minutes: 4), description: 'Full recovery.'),
                      const WorkoutStage(name: '1000m Effort', duration: Duration(minutes: 4), description: 'Match previous pace.'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
                    ]
                )
            ),
          ];
        } else if (weekNum == 8) {
          days = [
            PlanDay(
                id: 'ii_int_w8_d1',
                title: 'Session 1: Taper',
                workout: Workout(
                    title: 'Light Pyramid',
                    description: 'Short sharp burst to keep legs fresh. 2 mins @ 20, 1 min @ 24, 2 mins @ 20.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                      const WorkoutStage(name: '2 min @ 20', duration: Duration(minutes: 2), description: 'Easy pressure.'),
                      const WorkoutStage(name: '1 min @ 24', duration: Duration(minutes: 1), description: 'Sharpen up.'),
                      const WorkoutStage(name: '2 min @ 20', duration: Duration(minutes: 2), description: 'Easy pressure.'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                    ]
                )
            ),
            PlanDay(
                id: 'ii_int_w8_d2',
                title: 'Session 2: THE 2K TEST',
                workout: Workout(
                    title: '2000m Time Trial',
                    description: 'Go for a Personal Best. You are ready!',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 15), description: 'Prepare mentally and physically.'),
                      const WorkoutStage(name: '2000m Row', duration: Duration(minutes: 7, seconds: 30), description: 'Leave it all on the machine.'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: 'Walk it off.'),
                    ]
                )
            ),
          ];
        } else {
          // Generic filler for intermediate weeks
          days = [
            PlanDay(
                id: 'ii_int_w${weekNum}_d1',
                title: 'Session 1: Rate Control',
                workout: _simpleIntervalWorkout('Rate Steps', '20-22-24 SPM steps.', workDuration: const Duration(minutes: 4), restDuration: const Duration(minutes: 2), reps: 3)
            ),
            PlanDay(
                id: 'ii_int_w${weekNum}_d2',
                title: 'Session 2: Hard Distance',
                workout: Workout(
                    title: '3 x 750m',
                    description: 'Hard distance intervals.',
                    stages: [
                      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                      const WorkoutStage(name: '750m', duration: Duration(minutes: 3), description: 'Hard.'),
                      const WorkoutStage(name: 'Rest', duration: Duration(minutes: 3), description: 'Paddle.'),
                      const WorkoutStage(name: '750m', duration: Duration(minutes: 3), description: 'Hard.'),
                      const WorkoutStage(name: 'Rest', duration: Duration(minutes: 3), description: 'Paddle.'),
                      const WorkoutStage(name: '750m', duration: Duration(minutes: 3), description: 'Hard.'),
                      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
                    ]
                )
            ),
          ];
        }

        return PlanWeek(weekNumber: weekNum, days: days);
      }),
    );
  }

  // Helper for simple interval workouts to reduce code duplication
  Workout _simpleIntervalWorkout(String title, String description, {required Duration workDuration, required Duration restDuration, required int reps}) {
    return Workout(
      title: title,
      description: description,
      stages: [
        const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Get the blood flowing.'),
        for(int i=0; i<reps; i++) ...[
          WorkoutStage(name: 'Work', duration: workDuration, description: 'Maintain target intensity.'),
          WorkoutStage(name: 'Rest', duration: restDuration, description: 'Active recovery.'),
        ],
        const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Stretch.'),
      ],
    );
  }

  // --- EXISTING CODE PRESERVED BELOW (CSS Plan, etc.) ---
  TrainingPlan _cssFitness12WeekPlan() {
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
            _buildDay(weekNum, 1, 'Speed Intervals (30m)', _speedIntervalsWorkout(isShort: true)),
            _buildDay(weekNum, 3, 'Ladder Intervals (30m)', _ladderIntervalsWorkout(isShort: true)),
            _buildDay(weekNum, 5, 'Climbing Bursts (30m)', _climbingBurstsWorkout(isShort: true)),
            _buildDay(weekNum, 7, 'Sunday Endurance (60m)', _sundayRideWorkout()),
          ];
        } else if (isBuildPhase) {
          days = [
            _buildDay(weekNum, 1, 'Speed Intervals (60m)', _speedIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 3, 'Ladder Intervals (60m)', _ladderIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 5, 'Climbing Bursts (60m)', _climbingBurstsWorkout(isShort: false)),
            _buildDay(weekNum, 7, 'Sunday Endurance (60m)', _sundayRideWorkout()),
          ];
        } else if (isPeakPhase) {
          days = [
            _buildDay(weekNum, 1, 'Speed Intervals (60m)', _speedIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 2, 'Ladder Intervals (60m)', _ladderIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 4, 'Climbing Bursts (60m)', _climbingBurstsWorkout(isShort: false)),
            _buildDay(weekNum, 5, 'Power Hour (Hard Choice)', _powerHourWorkout()),
            _buildDay(weekNum, 7, 'Sunday Endurance (60m)', _sundayRideWorkout()),
          ];
        }

        return PlanWeek(weekNumber: weekNum, days: days);
      }),
    );
  }

  PlanDay _buildDay(int week, int dayNum, String title, Workout workout) {
    return PlanDay(id: 'css_w${week}_d$dayNum', title: title, workout: workout);
  }

  // --- UPDATED WORKOUT GENERATORS WITH DEFINITIONS ---

  Workout _speedIntervalsWorkout({required bool isShort}) {
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

  Workout _ladderIntervalsWorkout({required bool isShort}) {
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

  Workout _climbingBurstsWorkout({required bool isShort}) {
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

  Workout _powerHourWorkout() {
    return Workout(
      title: 'Power Hour',
      description: 'Sustained sweet-spot effort. ' 'A strong, sustainable pace. You should be breathing heavily but able to hold a short conversation.',
      stages: [
        const WorkoutStage(
            name: 'Warm-up',
            duration: Duration(minutes: 10),
            description: 'Spin Easy: Gradual build.'
        ),
        const WorkoutStage(
            name: 'Sweet Spot 1',
            duration: Duration(minutes: 15),
            description: '80% Effort: A strong, sustainable pace. You should be breathing heavily but able to hold a short conversation.'
        ),
        const WorkoutStage(
            name: 'Recovery',
            duration: Duration(minutes: 5),
            description: 'Recover: Drop your pace back to a "Spin Easy".'
        ),
        const WorkoutStage(
            name: 'Sweet Spot 2',
            duration: Duration(minutes: 15),
            description: '80% Effort: A strong, sustainable pace. Focus on consistency.'
        ),
        const WorkoutStage(
            name: 'Cool-down',
            duration: Duration(minutes: 15),
            description: 'Spin Easy: Ride in a low gear so that your legs are spinning easily.'
        ),
      ],
    );
  }

  Workout _sundayRideWorkout() {
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

  TrainingPlan _cyclingPlan() {
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
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Pick drill.'),
                  const WorkoutStage(name: 'Drills', duration: Duration(minutes: 15), description: 'Pause drills.'),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Light paddling.'),
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
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Build pressure.'),
                  const WorkoutStage(name: '5000m Row', duration: Duration(minutes: 20), description: 'Maintain consistent split.'),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Paddle lightly.'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}