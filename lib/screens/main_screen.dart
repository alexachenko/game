import 'dart:async'; // Добавляем для Timer
import 'package:flutter/material.dart';
import 'package:game/widgets/background_choice.dart';
import 'package:game/widgets/cat.dart';
import 'package:game/widgets/fridge_widget.dart';
import 'package:game/services/audio_manager.dart';
import 'package:game/models/cat_state.dart';
import 'package:game/services/audio_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TamagotchiScreen extends StatefulWidget {
  const TamagotchiScreen({super.key});


  @override
  State<TamagotchiScreen> createState() => _TamagotchiScreenState();
}

class _TamagotchiScreenState extends State<TamagotchiScreen> with WidgetsBindingObserver {
  late Box catStateBox; // Добавляем Box для хранения состояния
  final AudioManager _audioManager = AudioManager();
  bool _isCatSleeping = false;
  bool _showFridge = false;
  bool _isFishing = false;
  // int fishNumbers = 3;
  bool _showBackground = false;
  String _currentBackground = 'assets/images/background1.png';
  static const String roomBackground = 'assets/images/background1.png';
  bool _showBackgroundSelection = false;
  late CatState _catState;
  Timer? _stateTimer;
  final Map<String, double> _lastDisplayedValues = {
    'sleep': 100,
    'game': 100,
    'food': 100
  };

  final List<Map<String, dynamic>> backgrounds = [
    {'path': 'assets/images/background1.png', 'name': 'Комната'},
    {'path': 'assets/images/background2.png', 'name': 'Кухня'},
    {'path': 'assets/images/background3.png', 'name': 'Двор'},
  ];

  bool _isMusicOn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initHive();
    _audioManager.playBackgroundMusic(isNight: false); // Явно указываем дневную музыку
    _loadBackground();

    // _catState = CatState(
    //   food: 100,
    //   sleep: 100,
    //   game: 100,
    //   lastUpdated: DateTime.now(),
    // );

    _stateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _catState.updateStates(DateTime.now());
      });
    });
  }

  void _feedCat() {
    setState(() {
      _catState.food = (_catState.food + 25).clamp(0, 100);
      _catState.lastUpdated = DateTime.now();
      _saveCatState();
    });
  }

  void _playWithCat() {
    setState(() {
      _catState.game = (_catState.game + 25).clamp(0, 100);
      _catState.lastUpdated = DateTime.now();
      _saveCatState();
    });
  }

  void _letCatSleep() {
    setState(() {
      _catState.isSleeping = true;
      _catState.sleepProgress = 0;
      _isCatSleeping = true;
      _audioManager.playBackgroundMusic(isNight: true); // Добавлено
      _saveCatState();
    });
  }

  Future<void> _initHive() async {
    catStateBox = Hive.box('catStateBox');
    _loadCatState();
  }

  Future<void> _saveCatState() async {
    await catStateBox.put('currentState', _catState);
  }


  Future<void> _loadCatState() async {
    final savedState = catStateBox.get('currentState');
    if (savedState != null) {
      setState(() {
        _catState = savedState as CatState;
        _isCatSleeping = _catState.isSleeping;
        // Инициализация fishCount, если его нет в сохраненных данных
        _catState.fishCount ??= 0;
      });
    }

    else {
      _catState = CatState(
        food: 100,
        sleep: 100,
        game: 100,
        lastUpdated: DateTime.now(),
        fishCount: 3, // Начальное количество рыбок
      );
    }
  }

  void _calculateBackgroundDecay() {
    if (_catState.lastClosedTime == null) return;

    final now = DateTime.now();
    final duration = now.difference(_catState.lastClosedTime!);
    final minutesPassed = duration.inMinutes;

    if (minutesPassed > 0) {
      setState(() {
        final decayRate = 5.0;
        final decayAmount = decayRate * minutesPassed;

        _catState.food = (_catState.food - decayAmount).clamp(0, 100);
        _catState.game = (_catState.game - decayAmount).clamp(0, 100);

        _catState.sleep = _catState.isSleeping
            ? (_catState.sleep - decayAmount * 0.5).clamp(0, 100)
            : (_catState.sleep - decayAmount).clamp(0, 100);

        _catState.lastUpdated = now;
        _catState.lastClosedTime = null;
      });

      _saveCatState();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _catState.lastClosedTime = DateTime.now();
      _saveCatState();
    } else if (state == AppLifecycleState.resumed) {
      _loadCatState();
      _catState.calculateOfflineChanges(DateTime.now());
      _saveCatState();
    }
  }

  @override
  void dispose() {
    _stateTimer?.cancel();
    _audioManager.dispose();
    Hive.close();
    super.dispose();
  }

  void _loadBackground() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _showBackground = true);
    });
  }

  void _openBackgroundSelection() => setState(() => _showBackgroundSelection = true);
  void _closeBackgroundSelection() => setState(() => _showBackgroundSelection = false);

  void _eatFish() {
    if (_catState.fishCount > 0) {
      setState(() {
        _catState.fishCount--;
        _catState.food = (_catState.food + 25).clamp(0, 100);
        _catState.lastUpdated = DateTime.now();
      });
      _audioManager.playSfx('audio/meow.mp3');
    }
  }

  void _changeBackground(String newBackground) {
    _audioManager.playSfx('audio/room_switching.mp3');
    setState(() {
      _currentBackground = newBackground;
      _showBackgroundSelection = false;
      if (_isCatSleeping) _wakeUpCat();
    });
  }

  void _handleFridgeTap(TapDownDetails details) {
    print('Fridge tapped! Current background: $_currentBackground');
    if (_currentBackground != 'assets/images/background2.png') {
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(details.globalPosition);

    if (localPosition.dx >= 0 && localPosition.dx <= 440 &&
        localPosition.dy >= 180 && localPosition.dy <= 980) {
      setState(() => _showFridge = true);
    }
  }

  void _handleFishTap(int fishNumber) {
    setState(() {
      _catState.fishCount--;
      _feedCat(); // Добавляем кормление при нажатии на рыбу
    });
  }

  void _closeFridge() {
    setState(() => _showFridge = false);
  }

  void _startSleeping() {
    if (_currentBackground != roomBackground) return;
    _letCatSleep();
  }

  void _wakeUpCat() {
    setState(() {
      if (_catState.sleepProgress > 0) {
        _catState.sleep = (_catState.sleep + _catState.sleepProgress).clamp(0, 100);
      }
      _catState.isSleeping = false;
      _catState.sleepProgress = 0;
      _isCatSleeping = false;
      _catState.lastUpdated = DateTime.now();
      _audioManager.playBackgroundMusic(isNight: false); // Добавлено
      _saveCatState();
    });
  }

  void _handleScreenTap(TapDownDetails details) {
    _audioManager.playSfx('audio/tap.mp3');

    if (_showFridge) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final localPosition = box.globalToLocal(details.globalPosition);

      // Координаты области, где тап НЕ закрывает холодильник
      const fridgeContentLeft = 240.0;
      const fridgeContentRight = 490.0;
      const fridgeContentTop = 0.0;
      const fridgeContentBottom = 600.0;

      // Если тап вне контента холодильника - закрываем
      if (localPosition.dx < fridgeContentLeft ||
          localPosition.dx > fridgeContentRight ||
          localPosition.dy < fridgeContentTop ||
          localPosition.dy > fridgeContentBottom) {
        _closeFridge();
      }
      return;
    }

    if (_showBackgroundSelection) {
      _closeBackgroundSelection();
      return;
    }

    if (_isCatSleeping) {
      _wakeUpCat();
      return;
    }

    // Открытие холодильника (только на фоне кухни)
    if (_currentBackground == 'assets/images/background2.png') {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final localPosition = box.globalToLocal(details.globalPosition);

      // Координаты зоны холодильника (подбираются экспериментально)
      const fridgeZoneLeft = 0;
      const fridgeZoneRight = 200.0;
      const fridgeZoneTop = 100.0;
      const fridgeZoneBottom = 400.0;

      if (localPosition.dx >= fridgeZoneLeft &&
          localPosition.dx <= fridgeZoneRight &&
          localPosition.dy >= fridgeZoneTop &&
          localPosition.dy <= fridgeZoneBottom) {
        setState(() => _showFridge = true);
        return;
      }
    }

    // Ловля рыбы на фоне двора (background3.png)
    if (_currentBackground == 'assets/images/background3.png' && !_isFishing) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final localPosition = box.globalToLocal(details.globalPosition);

      // Координаты моста (настройте под ваш дизайн)
      const bridgeZoneLeft = 110.0;
      const bridgeZoneRight = 330.0;
      const bridgeZoneTop = 100.0;
      const bridgeZoneBottom = 210.0;

      if (localPosition.dx >= bridgeZoneLeft &&
          localPosition.dx <= bridgeZoneRight &&
          localPosition.dy >= bridgeZoneTop &&
          localPosition.dy <= bridgeZoneBottom) {
        _catchFish();
      }
    }


    // Остальная логика (например, сон кота)
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final localPosition = box.globalToLocal(details.globalPosition);

    // Новые координаты (пример для background1.png)
    const sleepZoneLeft = 0;    // Левая граница
    const sleepZoneRight = 200.0;   // Правая граница
    const sleepZoneTop = 150.0;     // Верхняя граница
    const sleepZoneBottom = 335.0;  // Нижняя граница

    if (localPosition.dx >= sleepZoneLeft &&
        localPosition.dx <= sleepZoneRight &&
        localPosition.dy >= sleepZoneTop &&
        localPosition.dy <= sleepZoneBottom) {
      _startSleeping();
    }
  }


  void _increaseGame() {
    setState(() {
      _catState.game = (_catState.game + 25).clamp(0, 100); // Увеличиваем на 25% и ограничиваем до 100
      _catState.lastUpdated = DateTime.now();
    });
  }

  void _catchFish() {
    setState(() {
      _isFishing = true;
      _catState.fishCount++;
    });

    _audioManager.playSfx('audio/fishing_success.mp3'); // Добавьте звук в assets

    // Показываем сообщение об улове
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы поймали рыбку! Всего рыб: ${_catState.fishCount}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Задержка перед следующим возможным уловом
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isFishing = false);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: GestureDetector(
        onTapDown: _handleScreenTap,
        child: Stack(
          children: [

            if (_showBackground)
              Positioned.fill(
                child: Image.asset(
                  _currentBackground,
                  fit: BoxFit.cover,
                ),
              ),
            //


            // // Временная кнопка для теста холодильника
            // Positioned(
            //   bottom: 20,
            //   right: 20,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       if (_currentBackground == 'assets/images/background2.png') {
            //         setState(() => _showFridge = true);
            //       }
            //     },
            //     child: const Text('Открыть холодильник (тест)'),
            //   ),
            // ),

            if (_showBackground)
              CatWidget(
                isSleeping: _isCatSleeping,
                onTapDown: (details) {
                  if (_showBackgroundSelection) {
                    _closeBackgroundSelection();
                  }
                },
                onRunCompleted: _increaseGame, // Передаем callback
              ),

            if (_isCatSleeping)
              Positioned.fill(
                child: Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.7), // Исправляем withOpacity
                ),
              ),

            Positioned(
              top: 5,
              left: 120,
              child: Column(
                children: [
                  _buildStatusIndicator('sleep', _catState.sleep),
                ],
              ),
            ),
            Positioned(
              top: 5,
              left: 320,
              child: Column(
                children: [

                  _buildStatusIndicator('game', _catState.game),
                ],
              ),
            ),
            Positioned(
              top: 5,
              left: 520,
              child: Column(
                children: [
                  _buildStatusIndicator('food', _catState.food),
                ],
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
                fishCount: _catState.fishCount,
                onClose: _closeFridge,
                onFishTap: _handleFishTap,
                onEatFish: _eatFish, // Добавляем новый параметр
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String type, double currentValue) {
    // Определяем, какое изображение показывать
    double displayedValue;

    if (currentValue > 75) {
      displayedValue = 100;
    } else if (currentValue > 50) {
      displayedValue = 75;
    } else if (currentValue > 25) {
      displayedValue = 50;
    } else if (currentValue > 0) {
      displayedValue = 25;
    } else {
      displayedValue = 0;
    }

    // Если значение изменилось на целый уровень (25%)
    if (_lastDisplayedValues[type] != displayedValue) {
      _lastDisplayedValues[type] = displayedValue;
      return _getStatusImage(type, displayedValue);
    }

    // Если уровень не изменился, возвращаем предыдущее изображение
    return _getStatusImage(type, _lastDisplayedValues[type]!);
  }

  Widget _getStatusImage(String type, double value) {
    String imageName = '${type}${value.toInt()}.png';
    return Image.asset(
      'assets/images/$imageName',
      width: 200,
      height: 60,
      fit: BoxFit.contain,
    );
  }

}