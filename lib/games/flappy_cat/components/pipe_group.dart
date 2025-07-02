import 'package:flame/components.dart';
import 'package:game/games/flappy_cat/pipe_position.dart';
import 'package:game/games/flappy_cat/components/pipe.dart';
import 'package:game/games/flappy_cat/configuration.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';  
import 'dart:math';
import 'package:flutter/material.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyGame> {
  PipeGroup();

  final _random = Random();

  // Можно заранее не создавать список, а брать диапазон полностью случайно

  @override
  Future<void> onLoad() async {
    size = Vector2(gameRef.size.x, gameRef.size.y);
    position.x = gameRef.size.x;

    final gap = 225 + _random.nextDouble() * (270 - 225);

    // Допустимый диапазон центра зазора — расширяем за края экрана на ±50 пикселей,
    // чтобы трубы могли «выходить» за экран
    final minCenterY = gap / 2 - 50;
    final maxCenterY = gameRef.size.y - gap / 2 + 50;

    // Выбираем случайный центр зазора в расширенном диапазоне
    final centerY = minCenterY + _random.nextDouble() * (maxCenterY - minCenterY);

    final topPipeHeight = centerY - gap / 2;
    final bottomPipeHeight = gameRef.size.y - (centerY + gap / 2);

    addAll([
      Pipe(pipePosition: PipePosition.top, height: topPipeHeight)
        ..position = Vector2(0, 0),
      Pipe(pipePosition: PipePosition.bottom, height: bottomPipeHeight)
        ..position = Vector2(0, centerY + gap / 2),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;
    
    if (position.x < -25) {
      removeFromParent();
      debugPrint('Removed');
    }
  }
}
