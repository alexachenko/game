import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Для задержки

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем ориентацию перед запуском приложения
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
    );
  }
}

class TamagotchiScreen extends StatefulWidget {
  const TamagotchiScreen({super.key});

  @override
  State<TamagotchiScreen> createState() => _TamagotchiScreenState();
}

class _TamagotchiScreenState extends State<TamagotchiScreen> {
  bool _showBackground = false; // Показывать ли фон

  @override
  void initState() {
    super.initState();
    _loadBackground();
  }

  /// Задержка перед появлением фона
  void _loadBackground() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showBackground = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Фоновое изображение (появляется после задержки)
          if (_showBackground)
            Positioned.fill(
              child: Image.asset(
                'assets/images/background1.png',
                fit: BoxFit.cover, // Растягиваем на весь экран
              ),
            ),

          /// Центр экрана (текст "Тамагочи")
          Center(
            child: Text(
              "",
              style: TextStyle(
                fontSize: 32,
                color: _showBackground
                    ? Colors.white // Белый текст, если фон уже загружен
                    : const Color.fromARGB(255, 198, 21, 136), // Обычный цвет текста
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
