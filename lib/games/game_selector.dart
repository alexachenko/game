import 'package:flutter/material.dart';
import 'package:game/services/audio_manager.dart';

class GameSelector extends StatelessWidget {
  final VoidCallback onClose; //вызывается при закрытии окна
  final Function(String) onGameSelected; //принимает название игры

  const GameSelector({
    super.key,
    required this.onClose,
    required this.onGameSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned.fill( //затемнённый фон
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/games.png',
              width: 500,
              height: 550,
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 251,
            top: MediaQuery.of(context).size.height / 2 - 200,
            child: SizedBox(
              width: 500,
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //кнопка игры Arcanoid
                  GestureDetector(
                    onTap: () => onGameSelected('arcanoid'),
                    child: Container(
                      width: 200,
                      height: 220,
                      color: Colors.transparent,
                    ),
                  ),
                  // кнопка игры Flappy Bird
                  GestureDetector(
                    onTap: () => onGameSelected('flappy'),
                    child: Container(
                      width: 200,
                      height: 220,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}