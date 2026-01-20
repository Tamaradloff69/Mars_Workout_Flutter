import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Stores a user-chosen YouTube URL/ID per workout session (keyed by planDayId).
class WorkoutVideoCubit extends HydratedCubit<Map<String, String>> {
  WorkoutVideoCubit() : super(const {});

  void setVideoForSession(String sessionKey, String urlOrId) {
    final cleanedKey = sessionKey.trim();
    if (cleanedKey.isEmpty) return;
    final updated = Map<String, String>.from(state);
    updated[cleanedKey] = urlOrId.trim();
    emit(updated);
  }

  void clearVideoForSession(String sessionKey) {
    if (!state.containsKey(sessionKey)) return;
    final updated = Map<String, String>.from(state)..remove(sessionKey);
    emit(updated);
  }

  String? getVideoForSession(String sessionKey) => state[sessionKey];

  @override
  Map<String, String>? fromJson(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(key, value as String));
  }

  @override
  Map<String, dynamic>? toJson(Map<String, String> state) {
    return Map<String, dynamic>.from(state);
  }
}
