import 'package:hive/hive.dart';

part 'cat_state.g.dart';

@HiveType(typeId: 0)
class CatState {
  @HiveField(0)
  double food;

  @HiveField(1)
  double sleep;

  @HiveField(2)
  double game;

  @HiveField(3)
  DateTime lastUpdated;

  @HiveField(4)
  bool isSleeping;

  @HiveField(5)
  double sleepProgress;

  @HiveField(6)
  double sleepRecoveryRate;

  @HiveField(7)
  DateTime? lastClosedTime;


  @HiveField(8)
  int fishCount;

  CatState({
    required this.food,
    required this.sleep,
    required this.game,
    required this.lastUpdated,
    this.isSleeping = false,
    this.sleepProgress = 0,
    this.sleepRecoveryRate = 25.0,
    this.lastClosedTime,
    this.fishCount = 0,
  });

  void updateStates(DateTime now) {
    final secondsPassed = now.difference(lastUpdated).inSeconds;
    if (secondsPassed <= 0) return;

    final minutesPassed = secondsPassed / 60;

    final decayPerMinute = 100 / 4;
    final decayAmount = decayPerMinute * minutesPassed;

    food = (food - decayAmount).clamp(0, 100);
    game = (game - decayAmount).clamp(0, 100);

    if (isSleeping) {
      sleep = (sleep + sleepRecoveryRate * minutesPassed).clamp(0, 100);
    } else {
      sleep = (sleep - decayAmount).clamp(0, 100);
    }

    lastUpdated = now;
  }


  void calculateOfflineChanges(DateTime now) {
    if (lastClosedTime == null) return;

    final duration = now.difference(lastClosedTime!);
    final minutesPassed = duration.inMinutes;

    if (minutesPassed > 0) {
      final decayRate = 5.0;
      final decayAmount = decayRate * minutesPassed;

      food = (food - decayAmount).clamp(0, 100);
      game = (game - decayAmount).clamp(0, 100);
      sleep = (sleep - decayAmount).clamp(0, 100);

      lastUpdated = now;
      lastClosedTime = null;
    }
  }

}