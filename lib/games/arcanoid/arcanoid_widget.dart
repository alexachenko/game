import 'package:flutter/material.dart';
import 'arcanoid_game.dart';
import 'block.dart';
import 'package:game/services/audio_manager.dart';

class ArcanoidWidget extends StatefulWidget {
  final Function(int) onFishEarned;
  final VoidCallback onGameOver;

  const ArcanoidWidget({
    super.key,
    required this.onFishEarned,
    required this.onGameOver,
  });

  @override
  State<ArcanoidWidget> createState() => _ArcanoidWidgetState();
}

class _ArcanoidWidgetState extends State<ArcanoidWidget> with SingleTickerProviderStateMixin {
  late ArcanoidGame game;
  late AnimationController _animationController;
  int _countdown = 3;
  bool _gameStarted = false;
  bool _gameEnded = false;
  int _finalScore = 0;
  bool _showGameOverButtons = false;
  bool _showEndPanel = false;
  final AudioManager _audioManager = AudioManager();

  void _handleGameOver() {
    if (_gameEnded) return;
    setState(() {
      _gameEnded = true;
      _gameStarted = false;
      _finalScore = game.score;
      _animationController.stop();
      _showGameOverButtons = false;
      _showEndPanel = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showGameOverButtons = true;
        });
      }
    });
    // widget.onGameOver();

  }

  @override
  void initState() {
    super.initState();
    game = ArcanoidGame(
      onFishEarned: widget.onFishEarned,
      onGameOver: _handleGameOver,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
      if (_gameStarted) {
        setState(() {
          game.update();
        });
      }
    });

    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_countdown > 1) {
        setState(() => _countdown--);
        _startCountdown();
      } else {
        setState(() {
          _countdown = 0;
          _gameStarted = true;
        });
        _animationController.repeat();
      }
    });
  }

  void _restartGame() {
    setState(() {
      // Полный сброс состояния игры
      game.reset();
      game.blocks.clear();

      // Сброс флагов состояния виджета
      _gameEnded = false;
      _gameStarted = false;
      _showEndPanel = false;
      _showGameOverButtons = false;

      // Переинициализация игры
      game = ArcanoidGame(
        onFishEarned: widget.onFishEarned,
        onGameOver: _handleGameOver,
      );

      // Сброс анимации
      _animationController.reset();

      _audioManager.playBackgroundMusic(isGame: true);
      // Запуск обратного отсчета
      _countdown = 3;
      _startCountdown();
    });
  }

  @override
  @override
  void dispose() {
    _animationController.dispose();
    game.blocks.clear();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Запрещаем навигацию назад
      },
      child: Stack(
        children: [
          // Фон игры
          Positioned.fill(
            child: Image.asset(
              'assets/images/arcanoid_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Игровое поле
          if (_gameStarted)
            LayoutBuilder(
              builder: (context, constraints) {
                if (game.gameArea == Size.zero) {
                  game.initialize(constraints.biggest);
                }

                return GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      game.paddle.updatePosition(details.localPosition.dx);
                    });
                  },
                  child: Stack(
                    children: [
                      ...game.blocks.map((block) => block.build()),
                      game.paddle.build(),
                      game.ball.build(),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Text(
                          'Счет: ${game.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Таймер
          if (!_gameStarted && !_gameEnded)
            Center(
              child: Text(
                '$_countdown',
                style: const TextStyle(
                  fontSize: 100,
                  color: Colors.white,
                ),
              ),
            ),

          // Завершение игры
          if (_gameEnded)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showEndPanel ? 1.0 : 0.0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (game.score >= Block.fishBlocksCount) ? 'Победа!' : 'Игра завершена :(',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Счёт: $_finalScore',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            'Начать заново',
                            Colors.purple,
                            _restartGame,
                          ),
                          const SizedBox(width: 20),
                          _buildActionButton(
                            'Выйти',
                            Colors.blueAccent,
                                () {
                              widget.onGameOver();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}