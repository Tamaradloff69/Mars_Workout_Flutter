import '../../../core/constants/enums/workout_type.dart';

class GifRepository {
  static String getGifUrl(WorkoutType workoutType, String stageName) {
    // Normalize strings for easier matching
    final stage = stageName.toLowerCase();

    // --- 1. CYCLING (Your Original Links) ---
    if (workoutType == WorkoutType.cycling) {
      if (stage.contains('sprint') || stage.contains('attack')) {
        // Intense cycling
        return 'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExczR0cnN2M2tjcDB1bW9sYjB6YmdtN2d4MnM3Nmkzc3gyaXV3ajQyMiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/SyK7sf06U8ficLm5Cf/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery') || stage.contains('cool')) {
        // Resting on bike
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3Z2I4bjZmdzdxNWMzdGFiNzQzd2piZjBneGJnNDJtN2E0YmFoYjgzdCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ftvphb1LgYP9SgoNGn/giphy.gif';
      }
      // Steady / Default cycling
      return 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExYWZiOHNmMHNncTJ6ZHQ4NWhkaXMwY21sbmI5cmdvc3ZxN3J4cnJndyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/K4HgtO6wmyQaEkZP5a/giphy.gif';
    }

    // --- 2. ROWING (Your Original Links) ---
    if (workoutType == WorkoutType.rowing) {
      if (stage.contains('sprint')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3dmgycGFycTlvaXA0OXdnOGNqcHc1a201ZHE3czdzaGdiY244eHR1ZCZlcD12MV9naWZzX3JlbGF0ZWQmY3Q9Zw/askFpJwK2UeQYPhqKz/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
      }
      // Default Rowing
      return 'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYm5zZDNvMTNtNmdoYzZwNjY5a2drdTg1cTgzNnJod250bDB0aW13byZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/eS4ieTIEfrYnfPbC04/giphy.gif';
    }

    // --- 3. KETTLEBELL (Fleshed Out Logic using YOUR Links) ---
    if (workoutType == WorkoutType.kettleBell) {

      // -- MOVEMENT GROUP: OVERHEAD / CORE --
      // Handles: Halos, Slingshots, and "Clean" (mapped to halo for flow)
      if (stage.contains('halos') || stage.contains('clean')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExbDAxNzRobnllNDcxOWN2Y2ZsYjR4a2UycDBwejJoYTZ4bHZiOGV6NiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/1L8iyggFyXAJjcZiRI/giphy.gif';
      }
      else if (stage.contains('slingshots')) {
        return 'https://gymvisual.com/img/p/1/6/9/0/3/16903.gif';
      }

      else if (stage.contains('swings')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3Z201bjNudHExaXk0dG9zenQ5eThmNHkzNDEwZXZlOXB4bTAzNG5rZyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/7m8d8biUYCgyHRo2uJ/giphy.gif';
      }

      else if (stage.contains('cool')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3MzhwaXdtOXlzcTRtbXlleXpjNmpoM3dsZDdpMDA1anhua2drcmdsNyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/rnvGRog1qklLALH9F8/giphy.gif';
      }

      // -- MOVEMENT GROUP: LEGS / HINGE --
      // Handles: Squats, Deadlifts (mapped to squat)
      if (stage.contains('squat') || stage.contains('deadlift')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExbmw1MzUyb3BpZDZ5enp6OGgxMmZnbmtrbXNzdWQwbTBwOTNwZm5zNSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/MdRI2tmI5e7HX7P76U/giphy.gif';
      }
      if (stage.contains('lunge')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExZW16N2NwNDF4cnVxZGN2NjZ0eWM0MjI3a3FkaTZpbHhhN3RiNnk5bSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/58mTBYxhbSUJq/giphy.gif';
      }

      // -- MOVEMENT GROUP: PUSH / UPPER BODY --
      // Handles: Pushups, Press (mapped to pushup)
      if (stage.contains('pushup') || stage.contains('push-up') || stage.contains('press')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMW8waGFuamNpcmY4bW44OHVzcGhxaTF5bjhwZmVuam8zZHNyZHBqYSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/xPsKvp0HaXD2FJ4g0J/giphy.gif';
      }

      // -- MOVEMENT GROUP: REST --
      else if (stage.contains('rest') || stage.contains('recovery')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2NzbXcwNnYwZHlka3Q4a3lqdTNlMXcza3c5eWp4cXptMmI5a252dSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ZGmne7bRFBawmz5Gcr/giphy.gif';
      }
    }

    // Default Fallback (Generic Fitness GIF)
    return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
  }
}