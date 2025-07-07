import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:game/games/flappy_cat/cat_movement.dart';
import 'package:game/games/flappy_cat/configuration.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';  
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:game/services/audio_manager.dart';

class Cat extends SpriteGroupComponent<CatMovement> with HasGameRef<FlappyGame>, CollisionCallbacks { 
  final AudioManager _audioManager = AudioManager();
  int score = 0;

  Cat();

  @override
  Future<void> onLoad() async {
    final catMidFlap = await gameRef.loadSprite('cat_midflap.png');
    final catUpFlap = await gameRef.loadSprite('cat_upflap.png');
    final catDownFlap = await gameRef.loadSprite('cat_downflap.png');
    final catDied = await gameRef.loadSprite('cat_died.png');

    size = Vector2(50,40);
    anchor = Anchor.topLeft;
    position = Vector2(20, (gameRef.size.y - size.y)/2);
    sprites = {
      CatMovement.middle: catMidFlap,
      CatMovement.up: catUpFlap,
      CatMovement.down: catDownFlap,
      CatMovement.died: catDied,
    };
    current = CatMovement.middle;

    add(RectangleHitbox());
  }

void fly() {
  current = CatMovement.up;

  final effect = MoveByEffect(
    Vector2(0, Config.gravity),
    EffectController(duration: 0.25, curve: Curves.decelerate),
  );

  effect.onComplete = () {
    current = CatMovement.down;
      if (position.y < 0) {
    position.y = 0;
  }
  if (position.y > gameRef.size.y - size.y) {
    position.y = gameRef.size.y - size.y;
  }
  };

  add(effect);
}

@override
void onCollisionStart(
  Set<Vector2> intersectionPoints,
  PositionComponent other,
) {
  super.onCollisionStart(intersectionPoints, other);
  debugPrint('Collision Detected');
  gameOver();
}

void reset() {
  position = Vector2(20, (gameRef.size.y - size.y)/2);
  score = 0;
}

void gameOver() {
  size = Vector2(60,50);
  _audioManager.playSfx('audio/die.mp3');
  current = CatMovement.died;
  gameRef.overlays.add('gameOver');
  gameRef.pauseEngine();
  game.isHit = true;
}

  @override 
  void update (double dt) {
    super.update(dt);
    position.y += Config.catVelocity * dt;

      if (position.y < 0) {
    position.y = 0;
  }
  if (position.y > gameRef.size.y - size.y) {
    position.y = gameRef.size.y - size.y;
  }
  }
}