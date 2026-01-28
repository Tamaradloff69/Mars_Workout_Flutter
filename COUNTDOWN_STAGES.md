# Countdown Stages Feature

## Overview
Countdown stages are now integrated as actual workout stages instead of being an overlay. This means:
- Countdown timers appear as regular stages in the workout
- They're visible in the progress bar (shown in orange)
- YouTube videos continue playing uninterrupted through countdown stages
- The workout flow is more predictable and consistent

## How It Works

### Automatic Countdown Injection
When a workout starts, countdown stages are automatically added:
- **5 seconds** before the very first work stage ("Get Ready")
- **10 seconds** before each subsequent work stage ("Get Ready")
- **No countdown** before rest/recovery/cooldown stages

### Visual Indicators
- **Progress bar**: Countdown stages show in orange, work stages in blue
- **Stage name**: "GET READY" appears in orange text
- **Countdown overlay**: Full-screen countdown appears during "Get Ready" stages
- **Next stage preview**: Shows which exercise is coming next

### YouTube Video Behavior
- Videos play continuously through ALL stages (including countdown stages)
- No interruptions or restarts when transitioning between stages
- User controls video playback independently of the workout timer

## Implementation Details

### Files Created
1. **`lib/data/models/workout_helper.dart`**
   - `addCountdownStages()` - Injects countdown stages into workout
   - `isCountdownStage()` - Identifies if a stage is a countdown

### Files Modified
1. **`lib/logic/bloc/timer/timer_state.dart`**
   - Removed `isPrep` flag (no longer needed)
   - Simplified state management

2. **`lib/logic/bloc/timer/timer_bloc.dart`**
   - Removed prep timer logic
   - Simplified stage transitions
   - All stages are now treated equally

3. **`lib/logic/bloc/timer/timer_event.dart`**
   - Updated `RestoreTimer` to remove `isPrep` parameter

4. **`lib/presentation/screens/workout/workout_screen.dart`**
   - Removed `PrepOverlay` import
   - Added countdown detection in GIF builder
   - Shows countdown overlay only for "Get Ready" stages
   - YouTube video section unaffected (plays continuously)

5. **`lib/presentation/screens/workout/widgets/stage_info/stage_info_and_segment_bar.dart`**
   - Countdown stages display in orange in progress bar
   - Stage name shows in orange for countdown stages

6. **`lib/presentation/screens/workout/workout_preview/workout_preview_screen.dart`**
   - Adds countdown stages when starting a new workout

7. **`lib/data/models/workout_session.dart`**
   - Removed `isPrep` from session storage
   - Countdown stages are part of the saved workout structure

### Files Deleted
1. **`lib/presentation/screens/workout/widgets/timer/prep_overlay.dart`**
   - No longer needed (functionality moved to workout_screen.dart)

## Example Workout Flow

### Before (with prep overlay):
```
[PREP OVERLAY 5s] → Warm Up → [PREP OVERLAY 10s] → Work Set 1 → Rest → [PREP OVERLAY 10s] → Work Set 2
```

### After (with countdown stages):
```
Get Ready 5s → Warm Up → Get Ready 10s → Work Set 1 → Rest → Get Ready 10s → Work Set 2
```

### Visual Progress Bar:
```
🟠🟦🟠🟦⬜🟠⬜
↑ Current stage (Get Ready)
🟠 = Countdown stages
🟦 = Work stages completed
⬜ = Upcoming stages
```

## Benefits

1. **Predictable Duration**: Users can see exact workout length including all countdown times
2. **Consistent Experience**: All stages work the same way
3. **Better Resume**: Saved workouts preserve countdown stages
4. **Simpler Code**: Removed complex prep logic from timer
5. **YouTube Friendly**: Videos play uninterrupted through entire workout
6. **Visual Progress**: Users can see countdown stages in the progress bar

## User Experience

### During Countdown Stages:
- Full-screen black overlay appears
- Large orange countdown timer (circular progress)
- "GET READY" text in orange
- "NEXT UP: [Exercise Name]" preview
- YouTube video (if used) continues playing in background

### During Work/Rest Stages:
- Normal workout UI (GIF or YouTube video visible)
- Timer counts up from 0 to stage duration
- Stage name and description visible
- Progress bar shows position in workout

## Technical Notes

### Stage Detection
Countdown stages are identified by:
```dart
stage.name.toLowerCase() == 'get ready'
```

### Rest Stage Detection
Rest stages (which don't get countdown) are identified by:
```dart
stageName.contains('rest') || 
stageName.contains('recover') || 
stageName.contains('cool')
```

### Countdown Durations
- First countdown: 5 seconds
- Subsequent countdowns: 10 seconds
- Stored as: `Duration(seconds: 5)` or `Duration(seconds: 10)`
