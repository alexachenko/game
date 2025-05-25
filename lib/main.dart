import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/main_screen.dart';
import 'package:game/services/audio_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:game/models/cat_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CatStateAdapter());
  await Hive.openBox('catStateBox');

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TamagotchiScreen(),
      navigatorObservers: [AppLifecycleObserver()],
    );
  }
}


class AppLifecycleObserver extends NavigatorObserver with WidgetsBindingObserver {
  final AudioManager _audioManager = AudioManager();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _audioManager.stopBackgroundMusic();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    WidgetsBinding.instance.removeObserver(this);
  }
}