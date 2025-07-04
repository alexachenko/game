import 'package:flutter/material.dart';
import 'package:game/games/arcanoid/block.dart';
import 'package:game/games/arcanoid/paddle.dart';
import 'package:game/games/arcanoid/ball.dart';
import 'package:game/services/audio_manager.dart';

class ArcanoidGame {
  final AudioManager _audioManager = AudioManager();
  final Function(int) onFishEarned;
  final VoidCallback onGameOver;

  List<Block> blocks = [];
  Paddle paddle = Paddle();
  Ball ball = Ball();
  Size gameArea = Size.zero;
  int score = 0;
  int FishBlockCountt=0;


  ArcanoidGame({
    required this.onFishEarned,
    required this.onGameOver,
  });

  bool _isGameEnded = false; //добавляем флаг завершения игры

  void update() {
    if (_isGameEnded) return; //не обновляем, если игра завершена

    ball.update(paddle, gameArea);
    _checkCollisions();

    if ((ball.position.dy > gameArea.height) || (score == Block.fishBlocksCount)) {
      _isGameEnded = true;
      onGameOver(); //уведомляем виджет о завершении
    }
  }

  void reset() {
    _isGameEnded = false;
    score = 0;
    Block.fishBlocksCount = 0;
  }

  void initialize(Size size) {
    gameArea = size;
    _createBlocks();
    paddle.initialize(size);
    ball.initialize(paddle);
  }

  void _createBlocks() {
    const rows = 6;
    const cols = 6;
    const blockWidth = 100.0;
    const blockHeight = 20.0;
    const horizontalPadding = 5.0;
    const verticalPadding = 5.0;

    //рассчитываем общую ширину и высоту сетки блоков
    final totalWidth = cols * (blockWidth + horizontalPadding) - horizontalPadding;

    //начальная позиция для центрирования
    final startX = (gameArea.width - totalWidth) / 2;
    final startY = 10.0; //отступ сверху

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        BlockType type;
        if (row % 3 == 0) {
          type = BlockType.red;
        } else if (row % 3 == 1) {
          type = BlockType.orange;
        } else {
          type = BlockType.blue;
        }

        bool isComplex = row % 2 == 0;

        blocks.add(Block(
          position: Offset(
            startX + col * (blockWidth + horizontalPadding),
            startY + row * (blockHeight + verticalPadding),
          ),
          width: blockWidth,
          height: blockHeight,
          type: type,
          isComplex: isComplex,
          hitsRequired: isComplex ? 3 : 1,
        ));
      }
    }
  }


  void _checkCollisions() {
    //проверка столкновений с блоками
    for (var block in blocks.toList()) {
      if (ball.isCollidingWith(block)) {
        ball.bounceOffBlock(block);
        block.hit();

        if (block.isDestroyed) {
          blocks.remove(block);

          if (block.isComplex) {
            onFishEarned(1);
            score += 1;
            _audioManager.playSfx('audio/getting_fish.mp3');
          }
          else{
            _audioManager.playSfx('audio/breaking_ice.mp3');
          }
        }
        else{
          _audioManager.playSfx('audio/breaking_ice.mp3');
        }
      }
    }

    //проверка столкновения с ракеткой
    if (ball.isCollidingWith(paddle)) {
      ball.bounceOffPaddle(paddle);
      _audioManager.playSfx('audio/breaking_ice.mp3');
    }

    //левый край
    if (ball.position.dx - Ball.radius <= 0) {
      ball.velocity = Offset(-ball.velocity.dx, ball.velocity.dy);
      ball.position = Offset(Ball.radius, ball.position.dy);
    }

    //правый край
    if (ball.position.dx + Ball.radius >= gameArea.width) {
      ball.velocity = Offset(-ball.velocity.dx, ball.velocity.dy);
      ball.position = Offset(gameArea.width - Ball.radius, ball.position.dy);
    }

    //верхний край
    if (ball.position.dy - Ball.radius <= 0) {
      ball.velocity = Offset(ball.velocity.dx, -ball.velocity.dy);
      ball.position = Offset(ball.position.dx, Ball.radius);
    }
  }
}