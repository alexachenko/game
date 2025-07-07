import 'package:flutter/material.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';

class GameOverScreen extends StatelessWidget{
  final FlappyGame game;
  static const String id = 'gameOver';

  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context){
   game.pauseGame(); 
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Счёт: ${game.cat.score}',
              style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
              )
            ),
            Image.asset(
              'assets/images/gameover.png',
              width: 400,   
              fit: BoxFit.contain,
              ),
              const SizedBox(height:  20),
              ElevatedButton(
                onPressed: onRestart, 
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white38),
                child: const Text(
                    'Начать заново',
                    style: TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
        ),
    );
  }

  void onRestart() {
     game.restart();
     game.overlays.remove('gameOver');
  }
}