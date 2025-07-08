import 'package:flame/components.dart';
import 'package:game/games/flappy_cat/pipe_position.dart';
import 'package:game/games/flappy_cat/components/pipe.dart';
import 'package:game/games/flappy_cat/configuration.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';  
import 'dart:math';
import 'package:game/services/audio_manager.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyGame> {
  final AudioManager _audioManager = AudioManager();
  PipeGroup();

  final _random = Random();

@override
Future<void> onLoad() async {

    while (gameRef.size.y == 0) {
      await Future.delayed(const Duration(milliseconds: 16));
    }

    size = gameRef.size.clone();
    
  size = Vector2(gameRef.size.x, gameRef.size.y);
  position.x = gameRef.size.x;

  final gap = 250.0 + _random.nextDouble() * 50; 

  final centerY = gap / 2 + _random.nextDouble() * (gameRef.size.y - gap);

  final topPipeHeight = centerY - gap / 2;
  final bottomPipeHeight = gameRef.size.y - (centerY + gap / 2);

  addAll([
    Pipe(pipePosition: PipePosition.top, height: topPipeHeight)
      ..position = Vector2(0, 0),
    Pipe(pipePosition: PipePosition.bottom, height: bottomPipeHeight)
      ..position = Vector2(0, centerY + gap / 2),
  ]);
}

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;
    
    if (position.x < -30) {
      removeFromParent();
      updateScore();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }

  void updateScore() {
    gameRef.cat.score += 1;
    gameRef.onFishEarned(1);
    _audioManager.playSfx('audio/point.mp3');
  }
}
