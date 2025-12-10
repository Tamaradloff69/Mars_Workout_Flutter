import 'package:equatable/equatable.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'workout_model.dart'; // Import your existing workout model

class TrainingPlan extends Equatable {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<PlanWeek> weeks;
  final WorkoutType workoutType;

  const TrainingPlan({required this.id, required this.title, required this.description, required this.difficulty, required this.weeks, this.workoutType = WorkoutType.other});

  // Calculate total progress based on completed workout IDs
  double calculateProgress(List<String> completedWorkoutIds) {
    int total = 0;
    int completed = 0;
    for (var week in weeks) {
      for (var day in week.days) {
        total++;
        if (completedWorkoutIds.contains(day.id)) {
          completed++;
        }
      }
    }
    return total == 0 ? 0 : completed / total;
  }

  @override
  List<Object?> get props => [id, title, weeks];

  // Boilerplate JSON serialization would go here
  // For brevity, I'll skip manual toJson/fromJson but it's required for HydratedBloc
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'description': description, 'difficulty': difficulty, 'weeks': weeks.map((w) => w.toJson()).toList(), 'workout_type': workoutType};

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(id: json['id'], title: json['title'], description: json['description'], difficulty: json['difficulty'], weeks: (json['weeks'] as List).map((i) => PlanWeek.fromJson(i)).toList(), workoutType: json['workout_type'] ?? WorkoutType.other);
  }
}

class PlanWeek extends Equatable {
  final int weekNumber;
  final List<PlanDay> days;

  const PlanWeek({required this.weekNumber, required this.days});

  @override
  List<Object?> get props => [weekNumber, days];

  Map<String, dynamic> toJson() => {'weekNumber': weekNumber, 'days': days.map((d) => d.toJson()).toList()};

  factory PlanWeek.fromJson(Map<String, dynamic> json) {
    return PlanWeek(weekNumber: json['weekNumber'], days: (json['days'] as List).map((i) => PlanDay.fromJson(i)).toList());
  }
}

class PlanDay extends Equatable {
  final String id; // Unique ID (e.g., "cycling_w1_d1")
  final String title;
  final Workout workout; // Re-using your existing Workout model

  const PlanDay({required this.id, required this.title, required this.workout});

  @override
  List<Object?> get props => [id, title, workout];

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title,
    // We assume Workout has toJson, or we reconstruct it manually here
    'workout': {
      'title': workout.title,
      'description': workout.description,
      'stages': workout.stages.map((s) => {'name': s.name, 'duration': s.duration.inSeconds}).toList(),
    },
  };

  factory PlanDay.fromJson(Map<String, dynamic> json) {
    // Reconstruct logic needed here matching your Workout model structure
    // This is a simplified example
    return PlanDay(
      id: json['id'],
      title: json['title'],
      workout: Workout(
        title: json['workout']['title'],
        description: json['workout']['description'],
        stages: (json['workout']['stages'] as List)
            .map(
              (s) => WorkoutStage(
                name: s['name'],
                duration: Duration(seconds: s['duration']),
              ),
            )
            .toList(),
      ),
    );
  }
}
