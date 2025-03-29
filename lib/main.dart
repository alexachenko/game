// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeLeft,
//     DeviceOrientation.landscapeRight,
//   ]);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     });

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const TamagotchiScreen(),
//     );
//   }
// }

// class TamagotchiScreen extends StatefulWidget {
//   const TamagotchiScreen({super.key});

//   @override
//   State<TamagotchiScreen> createState() => _TamagotchiScreenState();
// }

// class _TamagotchiScreenState extends State<TamagotchiScreen> {
//   bool _showBackground = false; 
//   String _currentBackground = 'assets/images/background1.png'; 
//   bool _showBackgroundSelection = false; 

//   final List<Map<String, dynamic>> backgrounds = [
//     {
//       'path': 'assets/images/background1.png',
//       'name': 'Комната',
//     },
//     {
//       'path': 'assets/images/background2.png',
//       'name': 'Кухня',
//     },
//     {
//       'path': 'assets/images/background3.png',
//       'name': 'Двор',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadBackground();
//   }

//   void _loadBackground() {
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         _showBackground = true;
//       });
//     });
//   }

//   void _openBackgroundSelection() {
//     setState(() {
//       _showBackgroundSelection = true;
//     });
//   }

//   void _closeBackgroundSelection() {
//     setState(() {
//       _showBackgroundSelection = false;
//     });
//   }

//   void _changeBackground(String newBackground) {
//     setState(() {
//       _currentBackground = newBackground;
//       _showBackgroundSelection = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width; 
//     final screenHeight = MediaQuery.of(context).size.height;
// /// MediaQuery.of(context) - Доступ к данным о медиа-устройстве 
// /// Scaffold - это базовый шаблон для страницы в Material Design
// /// return Scaffold отрисовывает весь макет страницы
//     return Scaffold(
//       body: Stack(
//         children: [
//           if (_showBackground)
//             Positioned.fill(
//               child: Image.asset(
//                 _currentBackground,
//                 fit: BoxFit.cover,
//               ),
//             ),

//           /// Кнопка для открытия меню выбора фона
//           if (_showBackground)
//             Positioned(
//               left: 42, // X координата кнопки
//               top: 10, // Y координата кнопки
//               child: GestureDetector(
//                 onTap: _openBackgroundSelection,
//                 child: Container(
//                   width: 50, 
//                   height: 50, 
//                   color: Colors.transparent,
//                 ),
//               ),
//             ),


//           /// Окно выбора фона
//           if (_showBackgroundSelection)
//             Center(
//               child: Stack(
//                 children: [
//                   // Затемнение фона
//                   Positioned.fill(
//                     child: Container(
//                        color: Color.fromRGBO(0, 0, 0, 0.5),
//                     ),
//                   ),

//                   Center(
//                     child: Image.asset(
//                       'assets/images/map.png',
//                       width: 500, 
//                       height: 550, 
//                     ),
//                   ),

//                   // Кнопки выбора фона 
//                   Positioned(
//                     left: screenWidth / 2 - 251, // Центрируем по горизонтали
//                     top: screenHeight / 2 - 200, // Центрируем по вертикали
//                     child: SizedBox(
//                       width: 500,
//                       height: 400,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // Фон 1 (Комната)
//                           GestureDetector(
//                             onTap: () {
//                               _changeBackground(backgrounds[0]['path']);
//                             },
//                             child: Container(
//                               width: 135, // Ширина области нажатия
//                               height: 150, // Высота области нажатия
//                               color: const Color.fromARGB(0, 0, 0, 0),
//                             ),
//                           ),

//                           // Фон 2 (Кухня)
//                           GestureDetector(
//                             onTap: () {
//                               _changeBackground(backgrounds[1]['path']);
//                             },
//                             child: Container(
//                               width: 135, // Ширина области нажатия
//                               height: 150, // Высота области нажатия
//                               color: const Color.fromARGB(0, 0, 0, 0),
//                             ),
//                           ),

//                           // Фон 3 (Двор)
//                           GestureDetector(
//                             onTap: () {
//                               _changeBackground(backgrounds[2]['path']);
//                             },
//                             child: Container(
//                               width: 135, // Ширина области нажатия
//                               height: 150, // Высота области нажатия
//                               color: const Color.fromARGB(0, 0, 0, 0),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class _TamagotchiScreenState extends State<TamagotchiScreen> with SingleTickerProviderStateMixin {
  bool _showBackground = false;
  String _currentBackground = 'assets/images/background1.png';
  bool _showBackgroundSelection = false;

  // Кот
  double _catPosition = 0.0;
  bool _isWalking = false;
  bool _isFacingRight = true;
  int _stepCounter = 0;
  AnimationController? _walkController;
  Animation<double>? _walkAnimation;
  double? _targetPosition;

  // Зона хождения кота (уменьшенная)
  double _walkZoneLeft = 0.0;
  double _walkZoneRight = 0.0;
  double _walkZoneHeight = 0.0;
  double _catBasePositionY = 0.0;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCatPosition();
    });
  }

  void _initCatPosition() {
final screenSize = MediaQuery.of(context).size;
    
    // Уменьшенная зона хождения (примерно 60% ширины экрана)
_walkZoneLeft = screenSize.width * 0.29;
    _walkZoneRight = screenSize.width * 0.7;
    _walkZoneHeight = screenSize.height * 0.25;
    
    // Позиция кота по Y - чуть ниже центра
      _catBasePositionY = screenSize.height / 2 + 80;
    
    // Начальная позиция кота - центр зоны хождения
    _catPosition = (_walkZoneLeft + _walkZoneRight) / 2;

    // Инициализация анимации
    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _walkController?.dispose();
    super.dispose();
  }

  void _loadBackground() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showBackground = true;
      });
    });
  }

  void _openBackgroundSelection() {
    setState(() => _showBackgroundSelection = true);
  }

  void _closeBackgroundSelection() {
    setState(() => _showBackgroundSelection = false);
  }

  void _changeBackground(String newBackground) {
    setState(() {
      _currentBackground = newBackground;
      _showBackgroundSelection = false;
    });
  }

   void _startWalking(double targetX) {
    if (_isWalking || _walkController == null) return;

    _targetPosition = targetX.clamp(_walkZoneLeft, _walkZoneRight);
    _isFacingRight = _targetPosition! > _catPosition;

    final distance = (_targetPosition! - _catPosition).abs();
    final duration = Duration(milliseconds: (distance * 8).toInt());

    _walkController?.duration = duration;
    _walkAnimation = Tween<double>(
      begin: _catPosition,
      end: _targetPosition!,
    ).animate(_walkController!)
      ..addListener(() {
        setState(() {
          _catPosition = _walkAnimation?.value ?? _catPosition;
          _stepCounter = (_walkController!.value * 5).toInt() % 2;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isWalking = false);
        }
      });

    setState(() => _isWalking = true);
    _walkController?.forward(from: 0);
  }

  void _onTapDown(TapDownDetails details) {
    if (_showBackgroundSelection) return;

    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    if (localPosition.dx >= _walkZoneLeft &&
        localPosition.dx <= _walkZoneRight &&
        localPosition.dy >= _catBasePositionY - _walkZoneHeight / 2 &&
        localPosition.dy <= _catBasePositionY + _walkZoneHeight / 2) {
      _startWalking(localPosition.dx);
    }
  }

  String _getCatImage() {
    if (!_isWalking) return 'assets/images/catIsSitting.png';
    
    return _isFacingRight
        ? (_stepCounter == 0 
            ? 'assets/images/step1Right.png' 
            : 'assets/images/step2Right.png')
        : (_stepCounter == 0 
            ? 'assets/images/step1Left.png' 
            : 'assets/images/step2Left.png');
  }

 @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Stack(
          children: [
            if (_showBackground)
              Positioned.fill(
                child: Image.asset(
                  _currentBackground,
                  fit: BoxFit.cover,
                ),
              ),

            // Кот
            if (_showBackground)
              Positioned(
                left: _catPosition - 50, // Центрируем кота относительно позиции
                top: _catBasePositionY - 50, // Позиция чуть ниже центра
                child: Image.asset(
                  _getCatImage(),
                  width: 100,
                  height: 100,
                ),
              ),

            // Зона хождения кота (для наглядности)
            if (_showBackground)
              Positioned(
                left: _walkZoneLeft,
                top: _catBasePositionY - _walkZoneHeight / 2,
                child: Container(
                  width: _walkZoneRight - _walkZoneLeft,
                  height: _walkZoneHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(0, 244, 67, 54), width: 2),
                    color: Colors.transparent,
                  ),
                ),
              ),

            // Кнопка для открытия меню выбора фона
            if (_showBackground)
              Positioned(
                left: 42,
                top: 10,
                child: GestureDetector(
                  onTap: _openBackgroundSelection,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.transparent,
                  ),
                ),
              ),

            // Окно выбора фона
            if (_showBackgroundSelection)
              Center(
                child: Stack(
                  children: [
                    // Затемнение фона
                    Positioned.fill(
                      child: Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ),

                    Center(
                      child: Image.asset(
                        'assets/images/map.png',
                        width: 500,
                        height: 550,
                      ),
                    ),

                    // Кнопки выбора фона
                    Positioned(
                      left:  screenSize.width / 2 - 251,
                      top: screenSize.height / 2 - 200,
                      child: SizedBox(
                        width: 500,
                        height: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Фон 1 (Комната)
                            GestureDetector(
                              onTap: () {
                                _changeBackground(backgrounds[0]['path']);
                              },
                              child: Container(
                                width: 135,
                                height: 150,
                                color: const Color.fromARGB(0, 0, 0, 0),
                              ),
                            ),

                            // Фон 2 (Кухня)
                            GestureDetector(
                              onTap: () {
                                _changeBackground(backgrounds[1]['path']);
                              },
                              child: Container(
                                width: 135,
                                height: 150,
                                color: const Color.fromARGB(0, 0, 0, 0),
                              ),
                            ),

                            // Фон 3 (Двор)
                            GestureDetector(
                              onTap: () {
                                _changeBackground(backgrounds[2]['path']);
                              },
                              child: Container(
                                width: 135,
                                height: 150,
                                color: const Color.fromARGB(0, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}