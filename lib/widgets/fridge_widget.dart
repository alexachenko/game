import 'package:flutter/material.dart';

class FridgeWidget extends StatelessWidget {
  final int fishCount;
  final VoidCallback onClose;
  final Function(int) onFishTap;

  const FridgeWidget({
    super.key,
    required this.fishCount,
    required this.onClose,
    required this.onFishTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Stack(
        children: [
          // Затемнение фона
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),

          // Полки холодильника
          Center(
            child: Image.asset(
              fishCount > 0
                  ? 'assets/images/fridge_with_fish.png'
                  : 'assets/images/fridge_empty.png',
              width: 500,
              height: 600,
            ),
          ),

          // Области для нажатия на рыбок
          if (fishCount > 0) ...[
            Positioned(
              left: screenSize.width / 2 - 100,
              top: screenSize.height / 2 - 150,
              child: GestureDetector(
                onTap: () => onFishTap(1),
                child: Container(
                  width: 80,
                  height: 50,
                  color: Colors.transparent,
                ),
              ),
            ),
            // Добавьте другие позиции для рыбок по аналогии
          ],
        ],
      ),
    );
  }
}