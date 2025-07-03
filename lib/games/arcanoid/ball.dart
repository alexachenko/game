import 'package:flutter/material.dart';
import 'package:game/games/arcanoid/block.dart';
import 'package:game/games/arcanoid/paddle.dart';

class Ball {
  static const double radius = 10.0;
  static const double initialSpeed = 5.0;

  late Offset position;
  late Offset velocity;

  void initialize(Paddle paddle) {
    position = Offset(
      paddle.positionX + Paddle.width / 2,
      paddle.positionY - radius * 2,
    );
    velocity = Offset(5.0, -5.0); //cкорость
  }

  void update(Paddle paddle, Size gameArea) {
    position += velocity;
  }

  bool isCollidingWith(dynamic object) {
    final ballRect = Rect.fromCircle(center: position, radius: radius);
    return ballRect.overlaps(object.rect);
  }

  void bounceOffPaddle(Paddle paddle) {
    final paddleCenter = paddle.positionX + Paddle.width / 2;
    final hitPosition = (position.dx - paddleCenter) / (Paddle.width / 2);

    velocity = Offset(
      hitPosition * 5, //горизонтальная скорость зависит от места удара
      -velocity.dy.abs(), //всегда отскакивает вверх
    );
  }

  void bounceOffBlock(Block block) {
    final ballRect = Rect.fromCircle(center: position, radius: radius);
    final blockRect = block.rect;

    //определяем сторону столкновения
    final overlapX = ballRect.right > blockRect.left && ballRect.left < blockRect.right;
    final overlapY = ballRect.bottom > blockRect.top && ballRect.top < blockRect.bottom;

    if (overlapX && (position.dy <= blockRect.top || position.dy >= blockRect.bottom)) {
      velocity = Offset(velocity.dx, -velocity.dy);
    } else if (overlapY && (position.dx <= blockRect.left || position.dx >= blockRect.right)) {
      velocity = Offset(-velocity.dx, velocity.dy);
    } else {
      //угловое столкновение
      velocity = Offset(-velocity.dx, -velocity.dy);
    }
  }

  Widget build() {
    return Positioned(
      left: position.dx - radius,
      top: position.dy - radius,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}