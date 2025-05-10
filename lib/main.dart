import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/main_screen.dart';
import 'package:game/services/audio_manager.dart'; // Импорт аудио менеджера
import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Установка ориентации экрана
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Скрытие системного UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TamagotchiScreen(),
      // Обработчики жизненного цикла приложения
      navigatorObservers: [AppLifecycleObserver()],
    );
  }
}

// main.dart
// main.dart
class AppLifecycleObserver extends NavigatorObserver with WidgetsBindingObserver {
  final AudioManager _audioManager = AudioManager();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _audioManager.stopBackgroundMusic();
        break;
      case AppLifecycleState.resumed:
      // Используем геттер currentTrack вместо прямого доступа к приватному полю
        final currentTrack = _audioManager.currentTrack;
        _audioManager.playBackgroundMusic(
            isNight: currentTrack != null && currentTrack.contains('night')
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addObserver(this);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.removeObserver(this);
    super.didPop(route, previousRoute);
  }
}