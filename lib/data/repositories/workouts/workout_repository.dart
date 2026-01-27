import 'package:mars_workout_app/data/models/training_plan.dart';

import 'elliptical_repository.dart';
import 'cycling_repository.dart';
import 'rowing_repository.dart';

export 'elliptical_repository.dart';
export 'cycling_repository.dart';
export 'rowing_repository.dart';

class WorkoutRepository {
  // Singleton pattern
  static final WorkoutRepository _instance = WorkoutRepository._internal();
  factory WorkoutRepository() => _instance;
  WorkoutRepository._internal();

  // Cached plans list
  List<TrainingPlan>? _cachedPlans;

  /// Returns all available training plans.
  /// Plans are cached after first access to improve performance.
  List<TrainingPlan> getAllPlans() {
    _cachedPlans ??= _buildAllPlans();
    return _cachedPlans!;
  }

  /// Builds the complete list of training plans.
  /// This is called only once and cached.
  List<TrainingPlan> _buildAllPlans() {
    return [
      bicycleNetwork150kmPlan(),
      discovery30kmBeginnerPlan(),
      cssFitness12WeekPlan(),
      rowingPlan(),
      insideIndoorBeginnerPlan(),
      insideIndoorIntermediatePlan(),
      thePetePlan(),
      ellipticalTabataPlan(),
      ellipticalHiitPlan(),
      ellipticalHillPlan(),
    ];
  }

  /// Clears the cached plans (useful for testing or if plans are updated).
  void clearCache() {
    _cachedPlans = null;
  }
}
