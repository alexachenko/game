import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:game/games/flappy_cat/components/background.dart';
import 'package:game/games/flappy_cat/components/cat.dart';
import 'package:game/games/flappy_cat/components/pipe_group.dart';
import 'dart:async';
import 'package:game/games/flappy_cat/configuration.dart';

class FlappyGame extends FlameGame with TapDetector{
  late Cat cat;
  late Timer interval; 
  final VoidCallback onGameOver;
  final Function(int fish) onFishEarned; 

    FlappyGame({
    required this.onFishEarned,
    required this.onGameOver,
  });

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      cat = Cat(),
      ]);

      interval = Timer.periodic(Duration(milliseconds: (Config.pipeInterval*1000).toInt()),
      (timer) { 
        add(PipeGroup()); 
        },
      );

  }

  @override
  void onTap() {
    super.onTap();
    cat.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  
  @override
  void onRemove() {
    super.onRemove();
    interval.cancel(); 
  }
}