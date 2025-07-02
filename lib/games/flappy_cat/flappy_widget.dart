import 'package:flutter/material.dart';
import 'flappy_game.dart';
import 'package:flame/game.dart';

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
  game = FlappyGame(onFishEarned: widget.onFishEarned, onGameOver: widget.onGameOver);
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        GameWidget(game: game),   
      ]
    )
  );
}
  }