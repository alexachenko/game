import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';

class MainMenuScreen extends StatelessWidget {
  final FlappyGame game;
  static const String id = 'mainMenu';

  const MainMenuScreen({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context){
    game.pauseEngine();
      return Scaffold(
        body: GestureDetector(
          onTap: (){
            game.overlays.remove('mainMenu');
            game.resumeEngine();
          },
          child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/flappy_background.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Center(
            child: Image.asset(
            'assets/images/startgame.png',
              width: 400,   
              fit: BoxFit.contain,
          ), 
          ),
        ),
        )     
      );
  }
}