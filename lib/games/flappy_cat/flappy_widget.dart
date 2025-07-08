import 'package:flutter/material.dart';
import 'package:game/games/flappy_cat/screens/game_over_screen.dart';
import 'package:game/games/flappy_cat/screens/main_menu_screen.dart';
import 'flappy_game.dart';
import 'package:flame/game.dart';
import 'package:game/services/audio_manager.dart';

class FlappyGameWidget extends StatefulWidget  {
  final Function(int) onFishEarned;
  final VoidCallback onGameOver;

  const FlappyGameWidget({
    super.key,
    required this.onFishEarned,
    required this.onGameOver,
  });

  @override
  State<FlappyGameWidget> createState() => _FlappyGameWidgetState();
}

class _FlappyGameWidgetState extends State<FlappyGameWidget> {
  late FlappyGame game; 
  bool _isGameInitialized = false;

  @override
  void initState() {
    super.initState();

    if (!_isGameInitialized) {
      game = FlappyGame(
        onFishEarned: widget.onFishEarned,
        onGameOver: widget.onGameOver,
      );
      _isGameInitialized = true;
    }
  }
@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      AudioManager().stopBackgroundMusic();
      AudioManager().playBackgroundMusic();
      return true;
    },
    child: Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
            initialActiveOverlays: const [MainMenuScreen.id],
            overlayBuilderMap: {
              'mainMenu': (context, _) => MainMenuScreen(game: game),
              'gameOver': (context, _) => GameOverScreen(game: game),
            },
          ),   
        ]
      ),
    ),
  );
}

  }