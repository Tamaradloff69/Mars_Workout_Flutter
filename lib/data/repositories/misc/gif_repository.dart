import '../../../core/constants/enums/workout_type.dart';

class GifRepository {
  static String getGifUrl(WorkoutType workoutType, String stageName) {
    final stage = stageName.toLowerCase();

    if (workoutType == WorkoutType.cycling) {
      if (stage.contains('sprint') || stage.contains('attack') || stage.contains('hard') || stage.contains('climb') || stage.contains('accel') || stage.contains('spin') || stage.contains('threshold') || stage.contains('sweet')) {
        return 'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExczR0cnN2M2tjcDB1bW9sYjB6YmdtN2d4MnM3Nmkzc3gyaXV3ajQyMiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/SyK7sf06U8ficLm5Cf/giphy.gif';
      } else if (stage.contains('rest') || stage.contains('recovery') || stage.contains('cool')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3Z2I4bjZmdzdxNWMzdGFiNzQzd2piZjBneGJnNDJtN2E0YmFoYjgzdCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ftvphb1LgYP9SgoNGn/giphy.gif';
      }
      return 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExYWZiOHNmMHNncTJ6ZHQ4NWhkaXMwY21sbmI5cmdvc3ZxN3J4cnJndyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/K4HgtO6wmyQaEkZP5a/giphy.gif';
    }

    if (workoutType == WorkoutType.rowing) {
      if (stage.contains('sprint') || stage.contains('fast') || stage.contains('high') || stage.contains('burst')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3dmgycGFycTlvaXA0OXdnOGNqcHc1a201ZHE3czdzaGdiY244eHR1ZCZlcD12MV9naWZzX3JlbGF0ZWQmY3Q9Zw/askFpJwK2UeQYPhqKz/giphy.gif';
      } else if (stage.contains('rest') || stage.contains('recovery') || stage.contains('paddle')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
      }
      return 'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYm5zZDNvMTNtNmdoYzZwNjY5a2drdTg1cTgzNnJod250bDB0aW13byZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/eS4ieTIEfrYnfPbC04/giphy.gif';
    }

    if (workoutType == WorkoutType.elliptical) {
      if (stage.contains('warm') || stage.contains('cool') || stage.contains('recover') || stage.contains('easy') || stage.contains('rest')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNTdqMWxxc2hieGppZjR1a3lwZ2JyNTVhd25hbmhlZ3RoMGFlOWp1aSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/EzjCaYFnApVy8/giphy.gif';
      } else if (stage.contains('sprint') ||
          stage.contains('fast') ||
          stage.contains('max') ||
          stage.contains('hard') ||
          stage.contains('push') ||
          stage.contains('climb') ||
          stage.contains('reverse')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaWg3aXIwcHEwNzBpN2J6MGw2OWl0eDh1cWc5NXE1bDRsMGg4anV3byZlcD12MV9naWZzX3NlYXJjaCZjdD1n/mBBCFnAf0BgRAQWO8k/giphy.gif';
      }
      // Default / Steady
      return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaWg3aXIwcHEwNzBpN2J6MGw2OWl0eDh1cWc5NXE1bDRsMGg4anV3byZlcD12MV9naWZzX3NlYXJjaCZjdD1n/2grhtvGDP6uC7dIyw4/giphy.gif';
    }
    return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
  }
}
