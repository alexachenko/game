import 'package:flutter/material.dart';

class Paddle {
  static const double width = 80.0;
  static const double height = 20.0;

  late double positionX;
  late double positionY;
  late double gameWidth;

  void initialize(Size size) {
    gameWidth = size.width;
    positionX = size.width / 2 - width / 2;
    positionY = size.height - height - 20;
  }

  void updatePosition(double newX) {
    positionX = (newX - width / 2).clamp(0.0, gameWidth - width);
  }

  Rect get rect => Rect.fromLTWH(positionX, positionY, width, height);

  Widget build() {
    return Positioned(
      left: positionX,
      top: positionY,
      child: Image.asset(
        'assets/images/racket.png',
        width: width,
        height: height,
      ),
    );
  }
}