import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/widgets.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() => _instance;

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMusicPlaying = false;
  bool globalMusicShutdown = false;
  String? _currentTrack;

  String? get currentTrack => _currentTrack;

  AudioManager._internal();

  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      stopBackgroundMusic();
    }
  }

  Future<void> toggleMusic() async {
    globalMusicShutdown = !globalMusicShutdown;

    if (globalMusicShutdown) {
      await stopBackgroundMusic();
    } else {
      // Определяем текущую музыку
      await playBackgroundMusic(
        isNight: _currentTrack == 'audio/background_music_night.mp3',
        isGame: _currentTrack == 'audio/arkanoid_background.mp3',
        isFlappy: _currentTrack == 'audio/background_flappy.mp3',
      );
    }
  }

  Future<void> playBackgroundMusic({
    bool isNight = false,
    bool isGame = false,
    bool isFlappy = false,
  }) async {
    if (globalMusicShutdown) return;

    final track = isGame
        ? 'audio/arkanoid_background.mp3'
        : isFlappy
        ? 'audio/background_flappy.mp3'
        : isNight
        ? 'audio/background_music_night.mp3'
        : 'audio/background_music.mp3';

    if (_isMusicPlaying && _currentTrack == track) return;

    await stopBackgroundMusic();

    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.3);
      await _musicPlayer.play(AssetSource(track));

      _isMusicPlaying = true;
      _currentTrack = track;
    } catch (e) {
      debugPrint('Ошибка запуска музыки: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (!_isMusicPlaying) return;

    try {
      await _musicPlayer.stop();
    } catch (e) {
      debugPrint('Ошибка остановки фоновой музыки: $e');
    } finally {
      _isMusicPlaying = false;
      _currentTrack = null;
    }
  }

  Future<void> playSfx(String assetPath, {bool flag = false}) async {
    try {
      final player = AudioPlayer(); // новый экземпляр
      await player.setVolume(flag ? 0.3 : 1.0);
      await player.play(AssetSource(assetPath));

      // Освободить ресурсы после проигрывания
      player.onPlayerComplete.listen((_) async {
        await player.dispose();
      });
    } catch (e) {
      debugPrint('Ошибка воспроизведения SFX: $e');
    }
  }


  Future<void> setVolume(double volume) async {
    try {
      await _musicPlayer.setVolume(volume);
    } catch (e) {
      debugPrint('Ошибка установки громкости: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await stopBackgroundMusic();
      await _musicPlayer.dispose();
      await _sfxPlayer.dispose();
      await Vibration.cancel();
    } catch (e) {
      debugPrint('Ошибка dispose в AudioManager: $e');
    }
  }
}
