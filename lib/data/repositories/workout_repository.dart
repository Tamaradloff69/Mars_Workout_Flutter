import 'package:mars_workout_app/data/models/training_plan.dart';

import 'cycling_repository.dart';
import 'kettlebell_repository.dart';
import 'rowing_repository.dart';


export 'cycling_repository.dart';
export 'kettlebell_repository.dart';
export 'rowing_repository.dart';
class WorkoutRepository {
  List<TrainingPlan> getAllPlans() {
    return [
      cssFitness12WeekPlan(),
      insideIndoorBeginnerPlan(),
      insideIndoorIntermediatePlan(),
      cyclingPlan(),
      rowingPlan(),
      kettlebellPlan(),
      petePlan(),
    ];
  }
}

