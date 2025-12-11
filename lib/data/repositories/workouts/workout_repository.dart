import 'package:mars_workout_app/data/models/training_plan.dart';

import 'elliptical_repository.dart';
import 'cycling_repository.dart';
import 'kettlebell_repository.dart';
import 'rowing_repository.dart';

export 'elliptical_repository.dart';
export 'cycling_repository.dart';
export 'kettlebell_repository.dart';
export 'rowing_repository.dart';

class WorkoutRepository {
  List<TrainingPlan> getAllPlans() {
    return [
      bicycleNetwork150kmPlan(), // NEW
      discovery30kmBeginnerPlan(), // NEW
      cssFitness12WeekPlan(),
      rowingPlan(),
      insideIndoorBeginnerPlan(),
      insideIndoorIntermediatePlan(),
      thePetePlan(),
      kettlebellPlan(),
      plan015KettlebellProgram(),
      nourishMoveLoveHiitPlan(),
      ellipticalTabataPlan(),
      ellipticalHiitPlan(),
      ellipticalHillPlan(),
    ];
  }
}
