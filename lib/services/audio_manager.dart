
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/widgets.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentTrack;

  String? get currentTrack => _currentTrack;

  factory AudioManager() => _instance;
  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      stopBackgroundMusic();
    }
  }

  AudioManager._internal();

  Future<void> playBackgroundMusic({bool isNight = false}) async {
    final track = isNight
        ? 'audio/background_music_night.mp3'
        : 'audio/background_music.mp3';

    if (_currentTrack == track && _isPlaying) return;

    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.3);
    await _player.play(AssetSource(track));

    _currentTrack = track;
    _isPlaying = true;
  }

  Future<void> playSfx(String assetPath) async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(1.0);
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing SFX: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _player.stop();
    _isPlaying = false;
    _currentTrack = null;
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> dispose() async {
    await _player.stop();
    await _player.dispose();
    await Vibration.cancel();
  }
}