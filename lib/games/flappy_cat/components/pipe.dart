import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';
import 'package:game/games/flappy_cat/pipe_position.dart';  

class Pipe extends SpriteComponent  with HasGameRef<FlappyGame>{
  Pipe({
    required this.pipePosition,
    required this.height,
  });

  @override 
  final double height;
  final PipePosition pipePosition;

@override
   Future<void> onLoad() async {
    final pipe = await Flame.images.load('pipe.png');
    final pipeRotated = await Flame.images.load('pipe_rotated.png');
    anchor = Anchor.topLeft;
    size = Vector2(50, height + 65);

    switch (pipePosition){
      case PipePosition.top: 
        position.y = 0;
        sprite = Sprite(pipeRotated);
        break;
      case PipePosition.bottom:
        position.y = gameRef.size.y - size.y;
        sprite = Sprite(pipe);
        break;
    }
      add(RectangleHitbox());
  }
}