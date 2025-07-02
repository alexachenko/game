import 'package:flame/components.dart'; 
import 'package:flame/flame.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';  
class Background extends SpriteComponent with HasGameRef<FlappyGame>{
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load('flappy_background.png');
      size = gameRef.size;
      sprite = Sprite(background);
  }
}