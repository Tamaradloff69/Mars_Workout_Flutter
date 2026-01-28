# Resume Workout Feature & Countdown Stages

## Overview
This feature allows users to resume a workout if they exit the app during a workout session. The workout state is automatically saved and the user is prompted to resume when they reopen the app.

Additionally, countdown stages have been integrated as actual workout stages, making them visible in the workout progress bar and allowing YouTube videos to play continuously through all stages.

## How It Works

### 1. Workout State Persistence
- When a user starts a workout, the `WorkoutPage` monitors the workout state
- State is automatically saved:
  - Every 5 seconds during the workout
  - When stage changes
  - When the app goes to background (paused/inactive)
  - When the user backs out of the workout

### 2. State Storage
- Uses `hydrated_bloc` for persistent storage
- `WorkoutSessionBloc` manages the saved session
- Session includes:
  - Complete workout data
  - Current stage index
  - Elapsed time
  - Timer state (running/paused, prep mode)
  - Plan day ID and workout type
  - Timestamp of when it was saved

### 3. Resume on Startup
- When the app starts, `HomePageWithResumeCheck` checks for saved sessions
- If a valid session exists (less than 24 hours old), a dialog is shown
- User can choose to:
  - **Resume**: Continue the workout from where they left off
  - **Discard**: Delete the saved session and start fresh

### 4. Exit Confirmation
- When a user tries to back out during a workout, they get a confirmation dialog
- The dialog explains their progress will be saved
- Options:
  - **Cancel**: Stay in the workout
  - **Exit & Save**: Save the workout and return to home

### 5. Automatic Cleanup
- Saved sessions are automatically cleared when:
  - The workout is completed successfully
  - The session is older than 24 hours
  - The user chooses to discard

## Files Modified/Created

### New Files:
1. `lib/data/models/workout_session.dart` - Model for saved workout sessions
2. `lib/logic/bloc/workout_session/workout_session_bloc.dart` - BLoC for managing sessions
3. `lib/logic/bloc/workout_session/workout_session_event.dart` - Session events
4. `lib/logic/bloc/workout_session/workout_session_state.dart` - Session state
5. `lib/presentation/widgets/resume_workout_dialog.dart` - UI for resume dialog

### Modified Files:
1. `lib/presentation/app/main.dart` - Added WorkoutSessionBloc provider and resume check
2. `lib/presentation/screens/workout/workout_page.dart` - Added state saving logic
3. `lib/presentation/screens/workout/workout_screen.dart` - Added exit confirmation
4. `lib/logic/bloc/timer/timer_bloc.dart` - Added RestoreTimer event
5. `lib/logic/bloc/timer/timer_event.dart` - Added RestoreTimer event class

## User Experience

### Scenario 1: App Backgrounded
1. User starts a workout
2. User receives a phone call (app goes to background)
3. Workout state is automatically saved
4. User returns to app later
5. Dialog prompts to resume with progress shown

### Scenario 2: User Exits Workout
1. User starts a workout
2. User presses back button
3. Confirmation dialog appears
4. User confirms exit
5. Workout state is saved
6. Next time app opens, resume dialog appears

### Scenario 3: Workout Completed
1. User completes workout
2. Saved session is automatically cleared
3. No resume prompt on next app launch

## Technical Details

### State Saving Frequency
- Every 5 seconds (to minimize performance impact)
- On stage transitions (important milestones)
- On app lifecycle changes (background/foreground)
- On explicit user exit

### Session Validity
- Sessions expire after 24 hours
- Invalid sessions are automatically discarded
- Only one session can be saved at a time

### Resume Behavior
- Timer starts in paused state (gives user time to prepare)
- All workout context is preserved (stage, elapsed time, prep mode)
- Video/GIF position is restored to current stage
- Plan progress tracking continues correctly

## Future Enhancements (Optional)
- Support for multiple saved workouts
- Custom session expiry time
- Workout history/analytics from saved sessions
- Share workout progress
