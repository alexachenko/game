import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:game/games/flappy_cat/cat_movement.dart';
import 'package:game/games/flappy_cat/configuration.dart';
import 'package:game/games/flappy_cat/flappy_game.dart';  
import 'package:flutter/animation.dart';

class Cat extends SpriteGroupComponent<CatMovement> with HasGameRef<FlappyGame>{
  Cat();

  @override
  Future<void> onLoad() async {
    final catMidFlap = await gameRef.loadSprite('cat_midflap.png');
    final catUpFlap = await gameRef.loadSprite('cat_upflap.png');
    final catDownFlap = await gameRef.loadSprite('cat_downflap.png');
    final catDied = await gameRef.loadSprite('cat_died.png');

    size = Vector2(55,45);
    anchor = Anchor.topLeft;
    position = Vector2(20, (gameRef.size.y - size.y)/2);
    sprites = {
      CatMovement.middle: catMidFlap,
      CatMovement.up: catUpFlap,
      CatMovement.down: catDownFlap,
      CatMovement.died: catDied,
    };
    current = CatMovement.middle;
  }

void fly() {
  current = CatMovement.up;

  final effect = MoveByEffect(
    Vector2(0, Config.gravity),
    EffectController(duration: 0.2, curve: Curves.decelerate),
  );

  effect.onComplete = () {
    current = CatMovement.down;
  };

  add(effect);
}

  @override 
  void update (double dt) {
    super.update(dt);
    position.y += Config.catVelocity * dt;
  }
}