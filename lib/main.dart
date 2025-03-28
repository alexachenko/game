import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

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
  String _currentBackground = 'assets/images/background1.png'; // Текущий фон
  bool _showBackgroundSelection = false; // Показывать ли меню выбора фона

  // Список доступных фонов
  final List<Map<String, dynamic>> backgrounds = [
    {
      'path': 'assets/images/background1.png',
      'name': 'Комната',
    },
    {
      'path': 'assets/images/background2.png',
      'name': 'Кухня',
    },
    {
      'path': 'assets/images/background3.png',
      'name': 'Двор',
    },
  ];

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

  /// Открыть меню выбора фона
  void _openBackgroundSelection() {
    setState(() {
      _showBackgroundSelection = true;
    });
  }

  /// Закрыть меню выбора фона
  void _closeBackgroundSelection() {
    setState(() {
      _showBackgroundSelection = false;
    });
  }

  /// Изменить текущий фон
  void _changeBackground(String newBackground) {
    setState(() {
      _currentBackground = newBackground;
      _showBackgroundSelection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// Фоновое изображение (появляется после задержки)
          if (_showBackground)
            Positioned.fill(
              child: Image.asset(
                _currentBackground,
                fit: BoxFit.cover,
              ),
            ),

          /// Кнопка для открытия меню выбора фона
          if (_showBackground)
            Positioned(
              left: 42, // X координата кнопки
              top: 10, // Y координата кнопки
              child: GestureDetector(
                onTap: _openBackgroundSelection,
                child: Container(
                  width: 50, // Ширина кнопки
                  height: 50, // Высота кнопки
                  color: Colors.transparent, // Прозрачная, так как будет на фоне
                ),
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
                    : const Color.fromARGB(255, 198, 21, 136),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Модальное окно выбора фона
          if (_showBackgroundSelection)
            Center(
              child: Stack(
                children: [
                  // Затемнение фона
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),

                  // Карта с выбором фонов
                  Center(
                    child: Image.asset(
                      'assets/images/map.png',
                      width: 500, // Ширина карты
                      height: 550, // Высота карты
                    ),
                  ),

                  // Кнопки выбора фона (прозрачные поверх карты)
                  Positioned(
                    left: screenWidth / 2 - 250, // Центрируем по горизонтали
                    top: screenHeight / 2 - 275, // Центрируем по вертикали
                    child: SizedBox(
                      width: 500,
                      height: 550,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Фон 1 (Комната)
                          GestureDetector(
                            onTap: () {
                              // Обработка нажатия на фон 1
                              // Здесь можно изменить координаты области нажатия
                              _changeBackground(backgrounds[0]['path']);
                            },
                            child: Container(
                              width: 150, // Ширина области нажатия
                              height: 550, // Высота области нажатия
                              color: Colors.transparent,
                            ),
                          ),

                          // Фон 2 (Кухня)
                          GestureDetector(
                            onTap: () {
                              // Обработка нажатия на фон 2
                              // Здесь можно изменить координаты области нажатия
                              _changeBackground(backgrounds[1]['path']);
                            },
                            child: Container(
                              width: 150, // Ширина области нажатия
                              height: 550, // Высота области нажатия
                              color: Colors.transparent,
                            ),
                          ),

                          // Фон 3 (Двор)
                          GestureDetector(
                            onTap: () {
                              // Обработка нажатия на фон 3
                              // Здесь можно изменить координаты области нажатия
                              _changeBackground(backgrounds[2]['path']);
                            },
                            child: Container(
                              width: 150, // Ширина области нажатия
                              height: 550, // Высота области нажатия
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Кнопка закрытия (крестик в углу)
                  Positioned(
                    right: screenWidth / 2 - 250 + 20,
                    top: screenHeight / 2 - 275 + 20,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: _closeBackgroundSelection,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}