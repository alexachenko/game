import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:game/games/flappy_cat/components/background.dart';
import 'package:game/games/flappy_cat/components/cat.dart';
import 'package:game/games/flappy_cat/components/pipe_group.dart';
import 'dart:async';
import 'dart:async' as async;
import 'package:game/games/flappy_cat/configuration.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Cat cat;
  late async.Timer _spawner;
  DateTime _lastRestarted = DateTime.now();
  late TextComponent score;

  bool isHit = false;
  final VoidCallback onGameOver;
  final Function(int fish) onFishEarned;

  FlappyGame({
    required this.onFishEarned,
    required this.onGameOver,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    score = buildScore();
    addAll([
      Background(),
      cat = Cat(),
      score,
    ]);

    // Ждём, пока размеры игры не будут известны
    while (size.x == 0 || size.y == 0) {
      await Future.delayed(const Duration(milliseconds: 16));
    }

    // Стартуем генератор колонн (через tryAddPipeGroup)
    _lastRestarted = DateTime.now();
    _spawner = async.Timer.periodic(
      Duration(milliseconds: (Config.pipeInterval * 1000).toInt()),
      (_) => tryAddPipeGroup(),
    );
  }

  void tryAddPipeGroup() {
    final elapsed = DateTime.now().difference(_lastRestarted).inMilliseconds;

    if (elapsed < 300) {
      return; // защита от раннего тика
    }

    add(PipeGroup());
  }

  TextComponent buildScore() {
    return TextComponent(
      text: 'Счёт: 0',
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  void onTap() {
    super.onTap();
    cat.fly();
  }

  void restart() {
    _lastRestarted = DateTime.now();

    children.whereType<PipeGroup>().forEach((p) => p.removeFromParent());

    cat.reset();
    isHit = false;

    _spawner.cancel();    
    resumeEngine();         

    _spawner = async.Timer.periodic(
      Duration(milliseconds: (Config.pipeInterval * 1000).toInt()),
      (_) => tryAddPipeGroup(),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    score.text = 'Счёт: ${cat.score}';
  }

  @override
  void onRemove() {
    super.onRemove();
    _spawner.cancel();
  }

  void pauseGame() {
  pauseEngine();
  _spawner.cancel(); 
}

}
