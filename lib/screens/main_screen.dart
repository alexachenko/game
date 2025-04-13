import 'package:flutter/material.dart';
import 'package:game/widgets/background_choice.dart';
import 'package:game/widgets/cat.dart';
import 'package:game/widgets/fridge_widget.dart';
import 'package:game/services/audio_manager.dart';

class TamagotchiScreen extends StatefulWidget {
  const TamagotchiScreen({super.key});

  @override
  State<TamagotchiScreen> createState() => _TamagotchiScreenState();
}

class _TamagotchiScreenState extends State<TamagotchiScreen> {
  bool _isCatSleeping = false;
  bool _showFridge = false;
  int fishNumbers = 3; // Примерное количество рыбок

  bool _showBackground = false;
  String _currentBackground = 'assets/images/background1.png';
  static const String roomBackground = 'assets/images/background1.png';
  bool _showBackgroundSelection = false;

  final List<Map<String, dynamic>> backgrounds = [
    {'path': 'assets/images/background1.png', 'name': 'Комната'},
    {'path': 'assets/images/background2.png', 'name': 'Кухня'},
    {'path': 'assets/images/background3.png', 'name': 'Двор'},
  ];

  final AudioManager _audioManager = AudioManager();
  bool _isMusicOn = true;

  @override
  void initState() {
    super.initState();
    _audioManager.playBackgroundMusic();
    _loadBackground();
  }

  @override
  void dispose() {
    _audioManager.dispose();
    super.dispose();
  }


  void _loadBackground() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _showBackground = true);
    });
  }

  void _openBackgroundSelection() => setState(() => _showBackgroundSelection = true);
  void _closeBackgroundSelection() => setState(() => _showBackgroundSelection = false);

  void _changeBackground(String newBackground) {
    setState(() {
      _currentBackground = newBackground;
      _showBackgroundSelection = false;
      if (_isCatSleeping) _wakeUpCat(); // Пробуждаем при смене локации
    });
  }

  void _handleFridgeTap(TapDownDetails details) {
    if (_currentBackground != 'assets/images/background2.png') {
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(details.globalPosition);

    // Проверяем попадание в область холодильника
    if (localPosition.dx >= 0 && localPosition.dx <= 440 &&
        localPosition.dy >= 180 && localPosition.dy <= 980) {
      setState(() => _showFridge = true);
    }
  }

  void _handleFishTap(int fishNumber) {
    setState(() => fishNumbers--);
  }

  void _closeFridge() {
    setState(() => _showFridge = false);
  }

  void _startSleeping() {
    // Проверяем, что текущий фон - комната
    if (_currentBackground != roomBackground) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Котик может спать только в комнате!')),
      // );
      return;
    }

    setState(() => _isCatSleeping = true);
  }

  void _wakeUpCat() {
    setState(() => _isCatSleeping = false);
  }

  void _handleScreenTap(TapDownDetails details) {
    if (_showBackgroundSelection) {
      _closeBackgroundSelection();
    }

    // Если кот спит - любое нажатие его будит
    if (_isCatSleeping) {
      _wakeUpCat();
      return;
    }

    if (_showBackgroundSelection) {
      _closeBackgroundSelection();
    }


    if (_isCatSleeping) {
      _wakeUpCat();
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(details.globalPosition);

    // Проверяем нажатие на домик (координаты примерные)
    if (localPosition.dx <= 400 && localPosition.dy >= 200 && localPosition.dy <= 750) {
      _startSleeping(); // Будет проверять локацию автоматически
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          _handleScreenTap(details);
          if (!_isCatSleeping) {
            _handleFridgeTap(details);
          }
        },
        child: Stack(
          children: [
            if (_showBackground)
              Positioned.fill(
                child: Image.asset(
                  _currentBackground,
                  fit: BoxFit.cover,
                ),
              ),

            if (_showBackground)
              CatWidget(
                isSleeping: _isCatSleeping, // Передаем состояние сна
                onTapDown: (details) {
                  if (_showBackgroundSelection) {
                    _closeBackgroundSelection();
                  }
                },
              ),

            if (_isCatSleeping)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),

            if (_showBackground && !_showBackgroundSelection)
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

            if (_showBackgroundSelection)
              BackgroundSelector(
                backgrounds: backgrounds,
                onBackgroundSelected: _changeBackground,
                onClose: _closeBackgroundSelection,
              ),

            if (_showFridge)
              FridgeWidget(
                fishCount: fishNumbers,
                onClose: _closeFridge,
                onFishTap: _handleFishTap,
              ),
          ],
        ),
      ),
    );
  }
}