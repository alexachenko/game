import 'package:flutter/material.dart';

enum BlockType { red, orange, blue }

class Block {
  final Offset position;
  final double width;
  final double height;
  final BlockType type;
  final bool isComplex;
  int hitsRequired;
  int hitsTaken = 0;

  Block({
    required this.position,
    required this.width,
    required this.height,
    required this.type,
    required this.isComplex,
    required this.hitsRequired,
  });

  bool get isDestroyed => hitsTaken >= hitsRequired;

  void hit() {
    hitsTaken++;
  }

  Rect get rect => Rect.fromLTWH(position.dx, position.dy, width, height);

  Widget build() {
    if (isDestroyed) return const SizedBox();

    String imagePath;
    if (isComplex) {
      final hitsLeft = hitsRequired - hitsTaken;
      imagePath = 'assets/images/blocks/complex - $hitsLeft - ${_typeToString(type)}.png';
    } else {
      imagePath = 'assets/images/blocks/simple-${_typeToString(type)}.png';
    }

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          // Запасной вариант, если изображение не загружено
          return Container(
            width: width,
            height: height,
            color: _getBlockColor(),
            child: Center(
              child: Text(
                isComplex ? (hitsRequired - hitsTaken).toString() : '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBlockColor() {
    switch (type) {
      case BlockType.red:
        return Colors.red;
      case BlockType.orange:
        return Colors.orange;
      case BlockType.blue:
        return Colors.blue;
    }
  }

  String _typeToString(BlockType type) {
    switch (type) {
      case BlockType.red:
        return 'red';
      case BlockType.orange:
        return 'orange';
      case BlockType.blue:
        return 'blue';
    }
  }
}