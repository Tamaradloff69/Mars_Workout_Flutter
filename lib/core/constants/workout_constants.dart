/// Centralized workout-related constants to eliminate magic numbers and strings.
library;

class WorkoutConstants {
  // ==========================================================================
  // VIDEO PLAYBACK
  // ==========================================================================

  /// Workouts longer than this threshold will offer YouTube video playback.
  /// Workouts shorter than this use GIF animations.
  static const Duration youtubeThreshold = Duration(minutes: 10);

  // ==========================================================================
  // SESSION SAVING
  // ==========================================================================

  /// Interval in seconds for auto-saving workout session progress.
  static const int autoSaveIntervalSeconds = 5;

  // ==========================================================================
  // DEFAULT WORKOUT DURATIONS
  // ==========================================================================

  /// Default warm-up duration for most workouts.
  static const int defaultWarmupMinutes = 5;

  /// Default cool-down duration for most workouts.
  static const int defaultCooldownMinutes = 5;

  /// Extended warm-up for advanced workouts.
  static const int extendedWarmupMinutes = 10;

  /// Extended cool-down for advanced workouts.
  static const int extendedCooldownMinutes = 10;

  // ==========================================================================
  // STAGE NAMES
  // ==========================================================================

  static const String stageNameWarmup = 'Warm-up';
  static const String stageNameCooldown = 'Cool-down';
  static const String stageNameGetReady = 'Get Ready';
  static const String stageNameRest = 'Rest';
  static const String stageNameWork = 'Work';
  static const String stageNameRecovery = 'Recovery';
  static const String stageNameSetRest = 'Set Rest';

  // ==========================================================================
  // ROWING SPECIFIC
  // ==========================================================================

  /// Estimated meters per minute for rowing (used for time calculations).
  static const int rowingMetersPerMinute = 200;

  /// Standard stroke rate ranges.
  static const int rowingSpmLow = 18;
  static const int rowingSpmMedium = 22;
  static const int rowingSpmHigh = 28;

  // ==========================================================================
  // CYCLING SPECIFIC
  // ==========================================================================

  /// Standard cadence ranges.
  static const int cyclingRpmLow = 60;
  static const int cyclingRpmMedium = 80;
  static const int cyclingRpmHigh = 100;

  // ==========================================================================
  // ELLIPTICAL SPECIFIC
  // ==========================================================================

  /// Standard resistance scale (out of 10).
  static const int ellipticalResistanceMax = 10;
  static const int ellipticalResistanceLow = 3;
  static const int ellipticalResistanceMedium = 6;
  static const int ellipticalResistanceHigh = 8;

  // ==========================================================================
  // COMMON WORKOUT DESCRIPTIONS
  // ==========================================================================

  static const String descriptionRestDay =
      'Rest is vital. Mark this day as complete to stay on track.';

  static const String descriptionRecovery =
      'Light recovery. Focus on breathing and form.';

  static const String descriptionWarmup =
      'Gradually increase intensity to prepare your body.';

  static const String descriptionCooldown =
      'Gradually decrease intensity to help recovery.';
}
