import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String title;
  final String description;
  final List<WorkoutStage> stages;

  const Workout({required this.title, required this.description, required this.stages});

  @override
  List<Object?> get props => [title, description, stages];

  Map<String, dynamic> toJson() => {'title': title, 'description': description, 'stages': stages.map((s) => s.toJson()).toList()};

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(title: json['title'], description: json['description'], stages: (json['stages'] as List).map((i) => WorkoutStage.fromJson(i)).toList());
  }
}

class WorkoutStage extends Equatable {
  final String name;
  final Duration duration;
  final String description;

  const WorkoutStage({required this.name, required this.duration, this.description = ""});

  @override
  List<Object?> get props => [name, duration, description];

  Map<String, dynamic> toJson() => {'name': name, 'duration': duration.inSeconds, 'description': description};

  factory WorkoutStage.fromJson(Map<String, dynamic> json) {
    return WorkoutStage(
      name: json['name'],
      duration: Duration(seconds: json['duration']),
      description: json['description'] ?? "",
    );
  }
}
