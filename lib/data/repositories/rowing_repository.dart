import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

import 'daily_repository.dart';

TrainingPlan insideIndoorBeginnerPlan() {
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
              workout: simpleIntervalWorkout(
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
              workout: simpleIntervalWorkout(
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
              workout: simpleIntervalWorkout(
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
              workout: simpleIntervalWorkout(
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
              workout: simpleIntervalWorkout(
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
              workout: simpleIntervalWorkout('Interval Mix', 'Alternating intensity.', workDuration: const Duration(minutes: 3), restDuration: const Duration(minutes: 2), reps: 4)
          ),
          PlanDay(
              id: 'ii_beg_w${weekNum}_d2',
              title: 'Session 2: Distance',
              workout: simpleIntervalWorkout('Steady Distance', 'Building up to 2k.', workDuration: const Duration(minutes: 8), restDuration: const Duration(minutes: 3), reps: 2)
          ),
        ];
      }

      return PlanWeek(weekNumber: weekNum, days: days);
    }),
  );
}

// --- NEW: Inside Indoor Intermediate 2km Plan ---
// Source: Inside Indoor / British Rowing Intermediate Plan
TrainingPlan insideIndoorIntermediatePlan() {
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
              workout: simpleIntervalWorkout('Rate Steps', '20-22-24 SPM steps.', workDuration: const Duration(minutes: 4), restDuration: const Duration(minutes: 2), reps: 3)
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


TrainingPlan rowingPlan() {
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

TrainingPlan petePlan() {
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
