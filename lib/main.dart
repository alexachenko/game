import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/main_screen.dart';
import 'package:game/services/audio_manager.dart'; // Импорт аудио менеджера
import 'package:audioplayers/audioplayers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:game/models/cat_state.dart'; // Убедитесь, что путь правильный

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CatStateAdapter());
  await Hive.openBox('catStateBox'); // Убедитесь, что Box открыт

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
    final box = Hive.box('catStateBox');
    final catState = box.get('currentState') as CatState?;

    if (state == AppLifecycleState.paused && catState != null) {
      catState.lastClosedTime = DateTime.now();
      box.put('currentState', catState);
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