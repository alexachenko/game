import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game/widgets/background_choice.dart';
import 'package:game/widgets/skin_choice.dart';
import 'package:game/widgets/cat.dart';
import 'package:game/widgets/fridge_widget.dart';
import 'package:game/services/audio_manager.dart';
import 'package:game/models/cat_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:game/games/game_selector.dart';
import 'package:game/games/arcanoid/arcanoid_widget.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';
import 'package:game/games/flappy_cat/flappy_widget.dart';

class TamagotchiScreen extends StatefulWidget {
  const TamagotchiScreen({super.key});

  @override
  State<TamagotchiScreen> createState() => _TamagotchiScreenState();
}

class _TamagotchiScreenState extends State<TamagotchiScreen> with WidgetsBindingObserver {
  late Box catStateBox; //добавляем Box для хранения состояния
  final AudioManager _audioManager = AudioManager();
  bool _isCatSleeping = false;
  bool _showFridge = false;
  bool _showBackground = false;
  String _currentBackground = 'assets/images/background1.png';
  String _currentSkin = '1';
  static const String roomBackground = 'assets/images/background1.png';
  bool _showBackgroundSelection = false;
  bool _showSkinSelection = false;
  bool _showGameSelector = false;
  bool _showArcanoidGame = false;
  bool _showFlappyGame = false;
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


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initHive();
    _audioManager.playBackgroundMusic(isNight: false, isGame: false);
    _loadBackground();

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

  void _letCatSleep() {
    setState(() {
      _catState.isSleeping = true;
      _catState.sleepProgress = 0;
      _isCatSleeping = true;
      _audioManager.playBackgroundMusic(isNight: true, isGame: false); // Добавлено
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
        _catState.fishCount;
      });
    }

    else {
      _catState = CatState(
        food: 100,
        sleep: 100,
        game: 100,
        lastUpdated: DateTime.now(),
        fishCount: 1, //начальное количество рыбок
      );
    }
  }

  void _openGameSelector() {
    setState(() {
      _showGameSelector = true;
    });
  }

  void _closeGameSelector() {
    setState(() {
      _showGameSelector = false;
    });
  }

  void _startGame(String gameType) {
    _audioManager.stopBackgroundMusic();
    _audioManager.playBackgroundMusic(isNight: false, isGame: true);

    if (gameType == 'arcanoid') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArcanoidWidget(
            onFishEarned: _earnFishFromGame,
            onGameOver: () {
              _audioManager.stopBackgroundMusic();
              _audioManager.playBackgroundMusic(isNight: false, isGame: false);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
    if (gameType == 'flappy') {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlappyGameWidget(
            onFishEarned: _earnFishFromGame,
            onGameOver: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  void _endArcanoidGame() {
    _audioManager.playBackgroundMusic(isNight: false, isGame: false);
    setState(() {
      _showArcanoidGame = false;
    });
  }

    void _endFlappyGame() {
      _audioManager.playBackgroundMusic(isNight: false, isGame: false);
    setState(() {
      _showFlappyGame = false;
    });
  }

  void _earnFishFromGame(int count) {
    setState(() {
      _catState.fishCount += count;
    });
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
  void _handleMultiTouch() async {
    if (await Vibration.hasVibrator()) {
      //вибрация с паузами для эффекта мурчания
      Vibration.vibrate(
        pattern: [100, 200, 100, 200, 100],
        intensities: [128, 255, 128, 255, 128],
      );
    }
  }

  @override
  void dispose() {
    _stateTimer?.cancel();
    _audioManager.dispose();
    WidgetsBinding.instance.removeObserver(this);
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


  void _openSkinSelection() => setState(() => _showSkinSelection = true);
  void _closeSkinSelection() => setState(() => _showSkinSelection = false);

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

  void _changeSkin(String newSkin) {
    _audioManager.playSfx('audio/room_switching.mp3');
    setState(() {
      _currentSkin = newSkin;
      _showSkinSelection = false;
    });
  }

  void _changeBackground(String newBackground) {
    _audioManager.playSfx('audio/room_switching.mp3');
    setState(() {
      _currentBackground = newBackground;
      _showBackgroundSelection = false;
      if (_isCatSleeping) _wakeUpCat();
    });
  }

  void _handleFishTap(int fishNumber) {
    setState(() {
      _catState.fishCount--;
      _feedCat();
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
      _audioManager.playBackgroundMusic(isNight: false, isGame: false);
      _saveCatState();
    });
  }

  void _handleScreenTap(TapDownDetails details) {
    _audioManager.playSfx('audio/tap.mp3');

    if (_showFridge) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final localPosition = box.globalToLocal(details.globalPosition);


      const fridgeContentLeft = 240.0;
      const fridgeContentRight = 490.0;
      const fridgeContentTop = 0.0;
      const fridgeContentBottom = 600.0;


      if (localPosition.dx < fridgeContentLeft || localPosition.dx > fridgeContentRight ||localPosition.dy < fridgeContentTop || localPosition.dy > fridgeContentBottom) {
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

    if (_currentBackground == 'assets/images/background2.png') {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final localPosition = box.globalToLocal(details.globalPosition);

      //координаты зоны холодильника
      const fridgeZoneLeft = 0;
      const fridgeZoneRight = 200.0;
      const fridgeZoneTop = 100.0;
      const fridgeZoneBottom = 400.0;

      if (localPosition.dx >= fridgeZoneLeft && localPosition.dx <= fridgeZoneRight && localPosition.dy >= fridgeZoneTop && localPosition.dy <= fridgeZoneBottom) {
        setState(() => _showFridge = true);
        return;
      }
    }

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final localPosition = box.globalToLocal(details.globalPosition);

    // где спит кот
    const sleepZoneLeft = 0;
    const sleepZoneRight = 200.0;
    const sleepZoneTop = 150.0;
    const sleepZoneBottom = 335.0;

    if (localPosition.dx >= sleepZoneLeft && localPosition.dx <= sleepZoneRight && localPosition.dy >= sleepZoneTop && localPosition.dy <= sleepZoneBottom) {
      _startSleeping();
    }
    if (_currentBackground == 'assets/images/background3.png') {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final localPosition = box.globalToLocal(details.globalPosition);

      // Координаты дома
      const houseLeft = 110.0;
      const houseRight = 330.0;
      const houseTop = 100.0;
      const houseBottom = 210.0;

      if (localPosition.dx >= houseLeft &&
          localPosition.dx <= houseRight &&
          localPosition.dy >= houseTop &&
          localPosition.dy <= houseBottom) {
        _openGameSelector();
        return;
      }
    }
  }


  void _increaseGame() {
    setState(() {
      _catState.game = (_catState.game + 25).clamp(0, 100);
      _catState.lastUpdated = DateTime.now();
    });
  }

  void _catchFish() {
    setState(() {
      _catState.fishCount++;
    });

    _audioManager.playSfx('audio/fishing_success.mp3');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы поймали рыбку! Всего рыб: ${_catState.fishCount}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GestureDetector(
        onTapDown: _handleScreenTap,
        onScaleStart: (details) {
          if (details.pointerCount == 3) { //проверяем три пальца
            _handleMultiTouch();
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
                isSleeping: _isCatSleeping,
                onTapDown: (details) {
                  if (_showBackgroundSelection) {
                    _closeBackgroundSelection();
                  }
                },
                onRunCompleted: _increaseGame,
                currentSkin: _currentSkin,
              ),

            if (_isCatSleeping)
              Positioned.fill(
                child: Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.7), 
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

            if (!_showSkinSelection)
              Positioned(
                right: 80,
                top: 90,
                child: GestureDetector(
                  onTap: _openSkinSelection,
                  child: Container(
                    width: 100,
                    height: 180,
                    color: Colors.transparent,
                  ),
                ),
              ),

            if (_showSkinSelection)
              SkinSelector(
                onSkinSelected: _changeSkin,
                onClose: _closeSkinSelection,
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
                onEatFish: _eatFish, 
              ),
            if (_showGameSelector)
              GameSelector(
                onClose: _closeGameSelector,
                onGameSelected: _startGame,
              ),

            if (_showArcanoidGame)
              ArcanoidWidget(
                onFishEarned: _earnFishFromGame,
                onGameOver: _endArcanoidGame,
              ),
              if (_showFlappyGame)
              ArcanoidWidget(
                onFishEarned: _earnFishFromGame,
                onGameOver: _endFlappyGame,
              )
          ],

        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String type, double currentValue) {
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

    //ecли значение изменилось на 25%
    if (_lastDisplayedValues[type] != displayedValue) {
      _lastDisplayedValues[type] = displayedValue;
      return _getStatusImage(type, displayedValue);
    }

    //если уровень не изменился
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