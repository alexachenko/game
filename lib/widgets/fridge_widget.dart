import 'package:flutter/material.dart';


class FridgeWidget extends StatelessWidget {
  final int fishCount;
  final VoidCallback onClose;
  final Function(int) onFishTap;
  final VoidCallback onEatFish;

  const FridgeWidget({
    super.key,
    required this.fishCount,
    required this.onClose,
    required this.onFishTap,
    required this.onEatFish,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Stack(
        children: [
          //затемнение фона
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
                  'assets/images/fridge_with_fish.png',
                  width: 500,
                  height: 600,
                ),

                //табличка с количеством рыб
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(116, 77, 67, 0.5),
                        borderRadius: BorderRadius.circular(8),

                      ),
                      child: Text(
                        'Рыба: $fishCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                //кнопка "Съесть рыбу"
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
                          backgroundColor: Color.fromRGBO(116, 77, 67, 0.5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                            side: BorderSide(color: Color.fromRGBO(131, 60, 78, 1))
                        ),
                        child: const Text(
                          'Съесть рыбу',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
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