import 'package:mars_workout_app/data/models/workout_model.dart';

/// Helper to inject countdown stages before work stages
class WorkoutHelper {
  /// Adds countdown stages to a workout:
  /// - 5 seconds "Get Ready" at the very beginning
  /// - 10 seconds "Get Ready" before each subsequent work stage (but not before rest stages)
  static List<WorkoutStage> addCountdownStages(List<WorkoutStage> originalStages) {
    if (originalStages.isEmpty) return originalStages;

    final List<WorkoutStage> stagesWithCountdown = [];
    int workStageCount = 0; // Track which work stage this is
    
    for (int i = 0; i < originalStages.length; i++) {
      final stage = originalStages[i];
      final stageName = stage.name.toLowerCase();
      final isRestStage = stageName.contains('rest') || 
                          stageName.contains('recover') || 
                          stageName.contains('cool');
      
      // Add countdown before non-rest stages
      if (!isRestStage) {
        // First work stage gets 5 seconds, subsequent work stages get 10 seconds
        final countdownDuration = workStageCount == 0 ? 5 : 10;
        
        stagesWithCountdown.add(
          WorkoutStage(
            name: 'Get Ready',
            duration: Duration(seconds: countdownDuration),
            description: 'Next: ${stage.name}',
          ),
        );
        workStageCount++;
      }
      
      // Add the actual stage
      stagesWithCountdown.add(stage);
    }
    
    return stagesWithCountdown;
  }

  /// Check if a stage is a countdown stage
  static bool isCountdownStage(WorkoutStage stage) {
    return stage.name.toLowerCase() == 'get ready';
  }
}
