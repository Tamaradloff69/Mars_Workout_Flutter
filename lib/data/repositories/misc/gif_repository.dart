import '../../../core/constants/enums/workout_type.dart';

class GifRepository {
  static String getGifUrl(WorkoutType workoutType, String stageName) {
    final stage = stageName.toLowerCase();

    if (workoutType == WorkoutType.cycling) {
      if (stage.contains('sprint') ||
          stage.contains('attack') ||
          stage.contains('hard') ||
          stage.contains('climb') ||
          stage.contains('accel') ||
          stage.contains('spin') ||
          stage.contains('threshold') ||
          stage.contains('sweet')) {
        return 'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExczR0cnN2M2tjcDB1bW9sYjB6YmdtN2d4MnM3Nmkzc3gyaXV3ajQyMiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/SyK7sf06U8ficLm5Cf/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery') || stage.contains('cool')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3Z2I4bjZmdzdxNWMzdGFiNzQzd2piZjBneGJnNDJtN2E0YmFoYjgzdCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ftvphb1LgYP9SgoNGn/giphy.gif';
      }
      return 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExYWZiOHNmMHNncTJ6ZHQ4NWhkaXMwY21sbmI5cmdvc3ZxN3J4cnJndyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/K4HgtO6wmyQaEkZP5a/giphy.gif';
    }

    if (workoutType == WorkoutType.rowing) {
      if (stage.contains('sprint') ||
          stage.contains('fast') ||
          stage.contains('high') ||
          stage.contains('burst')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3dmgycGFycTlvaXA0OXdnOGNqcHc1a201ZHE3czdzaGdiY244eHR1ZCZlcD12MV9naWZzX3JlbGF0ZWQmY3Q9Zw/askFpJwK2UeQYPhqKz/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery') || stage.contains('paddle')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
      }
      return 'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYm5zZDNvMTNtNmdoYzZwNjY5a2drdTg1cTgzNnJod250bDB0aW13byZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/eS4ieTIEfrYnfPbC04/giphy.gif';
    }

    if (workoutType == WorkoutType.kettleBell) {

      // -- NEW: NML Plan Specifics --
      if (stage.contains('burpee')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMzR0cnN2M2tjcDB1bW9sYjB6YmdtN2d4MnM3Nmkzc3gyaXV3ajQyMiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/23hPPmr8PnmDAkjLbW/giphy.gif';
      }
      else if (stage.contains('hollow') || stage.contains('twist') || stage.contains('russian')) {
        return 'https://media1.popsugar-assets.com/files/thumbor/2iKsfM5PV4WjulvNvZ3hmkNc3Dw/fit-in/1024x1024/filters:format_auto-!!-:strip_icc-!!-/2020/12/01/844/n/1922729/eda91fe4b67938a4_IMB_MVu242/i/Circuit-4-Exercise-4-Russian-Twist.GIF';
      }
      else if (stage.contains('staggered dl + clean')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Deadlift-and-Kettlebell-Clean-and-Front-Squat-and-Shoulder-Press.gif';
      }
      else if (stage.contains('row')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Split-Lunge-Hold-and-Single-Arm-Row.gif';
      }
      else if (stage.contains('pick up squats')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Kettlebell-Pick-Up-Squats.gif';
      }
      else if (stage.contains('staggered deadlift')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Staggered-Deadlift.gif';
      }
      else if (stage.contains('alt clean & front squat')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Kettlebell-Pick-Up-Squats.gif';
      }
      else if (stage.contains('curl') || stage.contains('bicep')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Lateral-Lunge-and-Bicep-Curl.gif';
      }
      else if (stage.contains('skull') || stage.contains('tricep') || stage.contains('bridge')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Glute-Bridge-and-Tricep-Skull-Crushers.gif';
      }
      else if (stage.contains('pull through') || stage.contains('plank')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Push-Up-and-Kettlebell-Pull-Through.gif';
      }
      else if (stage.contains('march') || stage.contains('world')) {
        return 'https://www.nourishmovelove.com/wp-content/uploads/2023/08/Around-The-World-Clean-and-Uneven-March.gif';
      }

      // -- EXISTING LOGIC --
      else if (stage.contains('halos')) {
        return 'https://www.garagegymreviews.com/wp-content/uploads/2023/04/kettlebell-halo.gif';
      }
      else if (stage.contains('clean')) {
        return 'https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2025/03/Kettlebell-Clean.gif';
      }
      else if (stage.contains('slingshots')) {
        return 'https://www.garagegymreviews.com/wp-content/uploads/2023/05/kettlebell-slingshot.gif';
      }
      else if (stage.contains('swings')) {
        return 'https://www.garagegymreviews.com/wp-content/uploads/2022/07/kettlebell-swing-gif.gif';
      }
      else if (stage.contains('squat')) {
        return 'https://www.garagegymreviews.com/wp-content/uploads/2023/04/kettlbell-goblet-squat.gif';
      }
      else if (stage.contains('deadlift')) {
        return 'https://www.garagegymreviews.com/wp-content/uploads/2023/11/Kettlebell-sumo-deadlift.gif';
      }
      else if (stage.contains('overhead') || stage.contains('shoulder press')) {
        return 'https://www.garagegymreviews.com/wp-content/uploads/2023/04/Kettlebell-Press-1.gif';
      }
      else if (stage.contains('lunge')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExZW16N2NwNDF4cnVxZGN2NjZ0eWM0MjI3a3FkaTZpbHhhN3RiNnk5bSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/58mTBYxhbSUJq/giphy.gif';
      }
      else if (stage.contains('pushup') || stage.contains('push-up') || stage.contains('press')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMW8waGFuamNpcmY4bW44OHVzcGhxaTF5bjhwZmVuam8zZHNyZHBqYSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/xPsKvp0HaXD2FJ4g0J/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery') || stage.contains('cool')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2NzbXcwNnYwZHlka3Q4a3lqdTNlMXcza3c5eWp4cXptMmI5a252dSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ZGmne7bRFBawmz5Gcr/giphy.gif';
      }
    }
    if (workoutType == WorkoutType.elliptical) {
      if (stage.contains('warm') || stage.contains('cool') ) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNTdqMWxxc2hieGppZjR1a3lwZ2JyNTVhd25hbmhlZ3RoMGFlOWp1aSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/EzjCaYFnApVy8/giphy.gif';
      }
      else if (stage.contains('sprint') || stage.contains('fast') || stage.contains('max') || stage.contains('hard')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaWg3aXIwcHEwNzBpN2J6MGw2OWl0eDh1cWc5NXE1bDRsMGg4anV3byZlcD12MV9naWZzX3NlYXJjaCZjdD1n/mBBCFnAf0BgRAQWO8k/giphy.gif';
      }
      return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaWg3aXIwcHEwNzBpN2J6MGw2OWl0eDh1cWc5NXE1bDRsMGg4anV3byZlcD12MV9naWZzX3NlYXJjaCZjdD1n/2grhtvGDP6uC7dIyw4/giphy.gif';
    }
    return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
  }
}