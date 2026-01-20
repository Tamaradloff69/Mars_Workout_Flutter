import '../../../core/constants/enums/workout_type.dart';

class VideoRepository {
  /// Returns a YouTube video id (the `v=` value) for a given workout type.
  /// Return null when no video is available.
  static String? getYoutubeVideoId(WorkoutType workoutType) {
    switch (workoutType) {
      case WorkoutType.cycling:
        // TODO: replace with your preferred cycling workout video
        return '1V4cAqf9m6c';
      case WorkoutType.rowing:
        // TODO: replace with your preferred rowing workout video
        return 'zQ82RYIFLN8';
      case WorkoutType.elliptical:
        // TODO: replace with your preferred elliptical workout video
        return 'f1g1L3PqI3k';
      case WorkoutType.other:
        return null;
    }
  }
}
