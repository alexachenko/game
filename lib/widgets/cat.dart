import 'package:flutter/material.dart';
import 'package:game/services/audio_manager.dart';


class CatWidget extends StatefulWidget {
  final Function(TapDownDetails)? onTapDown;
  final bool isSleeping;
  final VoidCallback? onRunCompleted; // Добавляем новый callback

  const CatWidget({
    super.key,
    this.onTapDown,
    required this.isSleeping,
    this.onRunCompleted, // Добавляем в конструктор
  });

  @override
  State<CatWidget> createState() => _CatWidgetState();
}

class _CatWidgetState extends State<CatWidget> with SingleTickerProviderStateMixin {
  late final AudioManager _audioManager;
  double _catPosition = 0.0;
  bool _isWalking = false;
  bool _isFacingRight = true;
  int _stepCounter = 0;
  AnimationController? _walkController;
  Animation<double>? _walkAnimation;
  double? _targetPosition;

  double _walkZoneLeft = 0.0;
  double _walkZoneRight = 0.0;
  double _walkZoneHeight = 0.0;
  double _catBasePositionY = 0.0;


  @override
  void initState() {
    super.initState();
    _audioManager = AudioManager();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initCatPosition());
  }

  void _initCatPosition() {
    final screenSize = MediaQuery.of(context).size;
    
    _walkZoneLeft = screenSize.width * 0.29;
    _walkZoneRight = screenSize.width * 0.7;
    _walkZoneHeight = screenSize.height * 0.25;
    _catBasePositionY = screenSize.height / 2 + 80;
    _catPosition = (_walkZoneLeft + _walkZoneRight) / 2;

    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    setState(() {});
  }

  void _startWalking(double targetX) {
    _audioManager.playSfx('audio/tap.mp3');
    _audioManager.playSfx('audio/meow.mp3');
    if (_walkController == null) return;

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
          // Вызываем callback при завершении пробежки
          if (widget.onRunCompleted != null) {
            widget.onRunCompleted!();
          }
        }
      });

    setState(() => _isWalking = true);
    _walkController?.forward(from: 0);
  }

  void _handleTapDown(TapDownDetails details) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(details.globalPosition);

    // Проверяем вертикальную зону
    final isInVerticalZone = localPosition.dy >= _catBasePositionY - _walkZoneHeight / 2 &&
        localPosition.dy <= _catBasePositionY + _walkZoneHeight / 2;

    if (!isInVerticalZone) return;

    // Явная обработка границ
    if (localPosition.dx < _walkZoneLeft) {
      _startWalking(_walkZoneLeft); // Идём к левой границе
    } else if (localPosition.dx > _walkZoneRight) {
      _startWalking(_walkZoneRight); // Идём к правой границе
    } else {
      _startWalking(localPosition.dx); // Идём к точке внутри зоны
    }
  }

  @override
  void dispose() {
    _walkController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      child: Stack(
        children: [
          Positioned(
            left: _catPosition - 50,
            top: _catBasePositionY - 50,
            child: Image.asset(
              _getCatImage(),
              width: 100,
              height: 100,
            ),
          ),
          // Отладочная зона хождения 
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
        ],
      ),
    );
  }

  String _getCatImage() {
    if (widget.isSleeping) return 'assets/images/CatSleep.png';
    if (!_isWalking) return 'assets/images/catIsSitting.png';

    return _isFacingRight
        ? (_stepCounter == 0
        ? 'assets/images/step1Right.png'
        : 'assets/images/step2Right.png')
        : (_stepCounter == 0
        ? 'assets/images/step1Left.png'
        : 'assets/images/step2Left.png');
  }
}