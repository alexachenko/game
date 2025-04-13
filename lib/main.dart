import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/main_screen.dart';
import 'package:game/services/audio_manager.dart'; // Импорт аудио менеджера

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

class AppLifecycleObserver extends NavigatorObserver with WidgetsBindingObserver {
  final AudioManager _audioManager = AudioManager();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _audioManager.stopBackgroundMusic();
        break;
      case AppLifecycleState.resumed:
        _audioManager.playBackgroundMusic();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      // Дополнительные состояния при необходимости
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