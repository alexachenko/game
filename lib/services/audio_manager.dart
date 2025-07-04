import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/widgets.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentTrack;
  bool globalMusicShutdown=false;

  String? get currentTrack => _currentTrack;

  factory AudioManager() => _instance;

  AudioManager._internal();

  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      stopBackgroundMusic();
    }
  }

  Future<void> toggleMusic() async {
    globalMusicShutdown = !globalMusicShutdown;

    if (!globalMusicShutdown) {
      //определяем текущий тип музыки
      final isNightMode = _currentTrack == 'audio/background_music_night.mp3';
      final isGameMode = _currentTrack == 'audio/arkanoid_background.mp3';

      await playBackgroundMusic(
        isNight: isNightMode,
        isGame: isGameMode,
      );
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> playBackgroundMusic({bool isNight = false, bool isGame = false}) async {
    if (globalMusicShutdown) return;

    final track = isGame
        ? 'audio/arkanoid_background.mp3'
        : (isNight
        ? 'audio/background_music_night.mp3'
        : 'audio/background_music.mp3');

    if (_isPlaying && _currentTrack == track) return;

    await stopBackgroundMusic();

    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.3);
      await _player.play(AssetSource(track));

      _isPlaying = true;
      _currentTrack = track;
    } catch (e) {
      print('Ошибка запуска музыки: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (!_isPlaying) return;

    try {
      await _player.stop();
    } catch (e) {
      print('Ошибка остановки фоновой музыки: $e');
    } finally {
      _isPlaying = false;
      _currentTrack = null;
    }
  }

  Future<void> playSfx(String assetPath) async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(1.0);
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Ошибка воспроизведения SFX: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume);
    } catch (e) {
      print('Ошибка установки громкости: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await stopBackgroundMusic();
      await _player.dispose();
      await _sfxPlayer.dispose();
      await Vibration.cancel();
    } catch (e) {
      print('Ошибка dispose в AudioManager: $e');
    }
  }
}
