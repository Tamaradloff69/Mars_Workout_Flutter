import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

PlanDay buildDay(int week, int dayNum, String title, Workout workout) {
  return PlanDay(id: 'css_w${week}_d$dayNum', title: title, workout: workout);
}
