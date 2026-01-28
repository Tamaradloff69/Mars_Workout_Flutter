import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();

  // Initialize Audio Context to allow mixing with other apps (Spotify/Apple Music)
  Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setVolume(1.0);

    await _player.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(isSpeakerphoneOn: true, stayAwake: true, contentType: AndroidContentType.music, usageType: AndroidUsageType.media, audioFocus: AndroidAudioFocus.gainTransientMayDuck),
        iOS: AudioContextIOS(
          // 'ambient' allows mixing with other apps
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers, AVAudioSessionOptions.duckOthers},
        ),
      ),
    );
  }

  Future<void> playCountdown() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/countdown.mp3'));
  }

  Future<void> playWorkoutComplete() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/workout_complete.mp3'));
  }

  Future<void> playWeekComplete() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/week_complete.mp3'));
  }

  Future<void> playTrainingPlanComplete() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/training_complete.mp3'));
  }
}
