import 'package:mars_workout_app/data/models/workout_model.dart';

/// Shared workout builder to eliminate duplication across repositories.
/// Provides common workout patterns used by rowing, cycling, and elliptical plans.
class WorkoutBuilder {
  /// Creates a time-based interval workout with repeated work/rest cycles.
  ///
  /// Example: 5 reps of 1 min work / 1 min rest
  static Workout buildTimeIntervals({
    required String title,
    required int workMinutes,
    required int restMinutes,
    required int repetitions,
    required String workDescription,
    String? workoutDescription,
    String restDescription = 'Light recovery.',
    int warmupMinutes = 5,
    int cooldownMinutes = 5,
    String warmupDescription = '',
    String cooldownDescription = '',
  }) {
    final stages = <WorkoutStage>[
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warmupMinutes),
        description: warmupDescription,
      ),
      for (int i = 0; i < repetitions; i++) ...[
        WorkoutStage(
          name: 'Work',
          duration: Duration(minutes: workMinutes),
          description: workDescription,
        ),
        WorkoutStage(
          name: 'Rest',
          duration: Duration(minutes: restMinutes),
          description: restDescription,
        ),
      ],
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cooldownMinutes),
        description: cooldownDescription,
      ),
    ];

    return Workout(
      title: title,
      description: workoutDescription ?? '$repetitions x $workMinutes min intervals',
      stages: stages,
    );
  }

  /// Creates a distance-based interval workout (useful for rowing).
  ///
  /// Example: 4 x 500m with 2 min rest
  static Workout buildDistanceIntervals({
    required String title,
    required int meters,
    required int restSeconds,
    required int repetitions,
    required String intensity,
    String? workoutDescription,
    int warmupMinutes = 5,
    int cooldownMinutes = 5,
  }) {
    final estimatedMinutesPerRep = meters ~/ 200;

    final stages = <WorkoutStage>[
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warmupMinutes),
      ),
      for (int i = 0; i < repetitions; i++) ...[
        WorkoutStage(
          name: '$meters meters',
          duration: Duration(minutes: estimatedMinutesPerRep),
          description: '$intensity. Estimated time.',
        ),
        WorkoutStage(
          name: 'Rest',
          duration: Duration(seconds: restSeconds),
          description: 'Recover.',
        ),
      ],
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cooldownMinutes),
      ),
    ];

    return Workout(
      title: title,
      description: workoutDescription ?? '$repetitions x $meters m intervals. $intensity.',
      stages: stages,
    );
  }

  /// Creates a steady-state continuous workout.
  ///
  /// Example: 20 min steady row at Zone 2
  static Workout buildSteadyWorkout({
    required String title,
    required int steadyMinutes,
    required String steadyDescription,
    String? workoutDescription,
    int warmupMinutes = 5,
    int cooldownMinutes = 5,
    String warmupDescription = '',
    String cooldownDescription = '',
  }) {
    final stages = <WorkoutStage>[
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warmupMinutes),
        description: warmupDescription,
      ),
      WorkoutStage(
        name: 'Steady State',
        duration: Duration(minutes: steadyMinutes),
        description: steadyDescription,
      ),
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cooldownMinutes),
        description: cooldownDescription,
      ),
    ];

    return Workout(
      title: title,
      description: workoutDescription ?? 'Continuous workout at a sustainable pace.',
      stages: stages,
    );
  }

  /// Creates a pyramid workout with varying durations and intensities.
  ///
  /// Example: [2, 2, 2, 2, 2] minutes at [20, 22, 24, 22, 20] rates
  static Workout buildPyramid({
    required String title,
    required List<int> durations,
    required List<int> intensities,
    required String Function(int duration, int intensity) stageNameBuilder,
    required String Function(int intensity) descriptionBuilder,
    String? workoutDescription,
    int warmupMinutes = 10,
    int cooldownMinutes = 5,
  }) {
    assert(durations.length == intensities.length,
        'Durations and intensities must have the same length');

    final stages = <WorkoutStage>[
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warmupMinutes),
      ),
      for (int i = 0; i < durations.length; i++)
        WorkoutStage(
          name: stageNameBuilder(durations[i], intensities[i]),
          duration: Duration(minutes: durations[i]),
          description: descriptionBuilder(intensities[i]),
        ),
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cooldownMinutes),
      ),
    ];

    return Workout(
      title: title,
      description: workoutDescription ?? 'Varying intensity pyramid workout.',
      stages: stages,
    );
  }

  /// Creates a workout with multiple sets of intervals with rest between sets.
  ///
  /// Example: 2 sets of (3 x 1min hard / 1min rest) with 3min between sets
  static Workout buildSetIntervals({
    required String title,
    required int sets,
    required int repsPerSet,
    required int workMinutes,
    required int restMinutes,
    required String workDescription,
    String? workoutDescription,
    int setRestMinutes = 3,
    String setRestDescription = 'Long recovery.',
    int warmupMinutes = 10,
    int cooldownMinutes = 10,
  }) {
    final stages = <WorkoutStage>[
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warmupMinutes),
      ),
    ];

    for (int s = 1; s <= sets; s++) {
      for (int r = 1; r <= repsPerSet; r++) {
        stages.add(
          WorkoutStage(
            name: 'Work ($r/$repsPerSet)',
            duration: Duration(minutes: workMinutes),
            description: workDescription,
          ),
        );
        if (r < repsPerSet) {
          stages.add(
            WorkoutStage(
              name: 'Rest',
              duration: Duration(minutes: restMinutes),
              description: 'Recover.',
            ),
          );
        }
      }
      if (s < sets) {
        stages.add(
          WorkoutStage(
            name: 'Set Rest',
            duration: Duration(minutes: setRestMinutes),
            description: setRestDescription,
          ),
        );
      }
    }

    stages.add(
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cooldownMinutes),
      ),
    );

    return Workout(
      title: title,
      description: workoutDescription ??
          '$sets sets of ($repsPerSet x ${workMinutes}min). ${setRestMinutes}min rest between sets.',
      stages: stages,
    );
  }

  /// Creates a variable workout with different segments.
  ///
  /// Example: Progressive intensity builds or step workouts
  static Workout buildVariableWorkout({
    required String title,
    required String description,
    required List<WorkoutStage> mainStages,
    int warmupMinutes = 10,
    int cooldownMinutes = 5,
    String warmupDescription = '',
    String cooldownDescription = '',
  }) {
    final stages = <WorkoutStage>[
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warmupMinutes),
        description: warmupDescription,
      ),
      ...mainStages,
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cooldownMinutes),
        description: cooldownDescription,
      ),
    ];

    return Workout(
      title: title,
      description: description,
      stages: stages,
    );
  }

  /// Creates a distance test workout.
  ///
  /// Example: 2000m time trial
  static Workout buildDistanceTest({
    required int meters,
    required String title,
    String? description,
    int warmupMinutes = 10,
    int cooldownMinutes = 10,
  }) {
    final estimatedMinutes = meters ~/ 200;

    return Workout(
      title: title,
      description: description ?? 'Complete the distance. Record your time.',
      stages: [
        WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: warmupMinutes),
          description: 'Thorough warm-up.',
        ),
        WorkoutStage(
          name: '$meters meters',
          duration: Duration(minutes: estimatedMinutes),
          description: 'Pace yourself. Aim for a consistent split.',
        ),
        WorkoutStage(
          name: 'Cool-down',
          duration: Duration(minutes: cooldownMinutes),
        ),
      ],
    );
  }

  /// Creates a rest day workout.
  static Workout buildRestDay({String title = 'Rest Day'}) {
    return Workout(
      title: title,
      description: 'Rest is vital. Mark this day as complete to stay on track.',
      stages: const [
        WorkoutStage(
          name: 'Resting...',
          duration: Duration(seconds: 1),
          description: 'Relax. Good sleep is the best recovery tool.',
        ),
      ],
    );
  }

  /// Creates interval workout with custom work/rest durations in seconds.
  ///
  /// Useful for Tabata, HIIT, etc.
  static Workout buildSecondIntervals({
    required String title,
    required String description,
    required int workSeconds,
    required int restSeconds,
    required int repetitions,
    required String workDescription,
    String restDescription = 'Recover.',
    int warmupMinutes = 5,
    int cooldownMinutes = 5,
    String warmupDescription = '',
    String cooldownDescription = '',
  }) {
    final stages = <WorkoutStage>[
      WorkoutStage(
        name: 'Warm-up',
        duration: Duration(minutes: warmupMinutes),
        description: warmupDescription,
      ),
      for (int i = 1; i <= repetitions; i++) ...[
        WorkoutStage(
          name: 'Work ($i/$repetitions)',
          duration: Duration(seconds: workSeconds),
          description: workDescription,
        ),
        WorkoutStage(
          name: 'Rest',
          duration: Duration(seconds: restSeconds),
          description: restDescription,
        ),
      ],
      WorkoutStage(
        name: 'Cool-down',
        duration: Duration(minutes: cooldownMinutes),
        description: cooldownDescription,
      ),
    ];

    return Workout(
      title: title,
      description: description,
      stages: stages,
    );
  }
}
