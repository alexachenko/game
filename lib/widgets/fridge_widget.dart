import 'package:flutter/material.dart';


class FridgeWidget extends StatelessWidget {
  final int fishCount;
  final VoidCallback onClose;
  final Function(int) onFishTap;
  final VoidCallback onEatFish; // Добавляем новый callback

  const FridgeWidget({
    super.key,
    required this.fishCount,
    required this.onClose,
    required this.onFishTap,
    required this.onEatFish, // Добавляем в конструктор
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

          // Холодильник
          Center(
            child: Stack(
              children: [
                Image.asset(
                  fishCount > 0
                      ? 'assets/images/fridge_with_fish.png'
                      : 'assets/images/fridge_empty.png',
                  width: 500,
                  height: 600,
                ),

                // Табличка с количеством рыб
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Рыба: $fishCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Кнопка "Съесть рыбу"
                if (fishCount > 0)
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          onEatFish();
                          onClose();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Съесть рыбу',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}