import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  Future<void> playBackgroundMusic() async {
    if (_isPlaying) return;

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setSourceAsset('assets/audio/background_music.mp3');
    await _player.resume();
    _isPlaying = true;
  }

  Future<void> stopBackgroundMusic() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  void dispose() {
    _player.dispose();
  }
}