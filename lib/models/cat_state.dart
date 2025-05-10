class CatState {
  double food;
  double sleep;
  double game;
  DateTime lastUpdated;
  bool isSleeping = false; // Добавляем флаг сна
  double sleepProgress = 0; // Прогресс увеличения сна
  double sleepRecoveryRate = 25.0; // % в минуту

  CatState({
    required this.food,
    required this.sleep,
    required this.game,
    required this.lastUpdated,
  });

  void updateStates(DateTime now) {
    final secondsPassed = now.difference(lastUpdated).inSeconds;
    if (secondsPassed <= 0) return;

    final minutesPassed = secondsPassed / 60; // Дробное количество минут

    // Общее уменьшение показателей
    final decayPerMinute = 100 / 4; // 25% в минуту
    final decayAmount = decayPerMinute * minutesPassed;

    food = (food - decayAmount).clamp(0, 100);
    game = (game - decayAmount).clamp(0, 100);

    // Особенная логика для сна
    if (isSleeping) {
      // Увеличиваем сон, но не более 100%
      sleep = (sleep + sleepRecoveryRate * minutesPassed).clamp(0, 100);
    } else {
      sleep = (sleep - decayAmount).clamp(0, 100);
    }

    lastUpdated = now;
  }
}