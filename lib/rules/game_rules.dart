class GameRules {
  final bool isUnlimitedTime;
  final int gameDuration;
  final int turnTime;
  final bool doubleTimeEnabled;
  final int doubleTimeDuration;
  final bool pushOutEnabled;
  final int pushOutDuration;
  final int sets;
  final int warnings;
  final String player1;
  final String player2;

  GameRules({
    required this.isUnlimitedTime,
    required this.gameDuration,
    required this.turnTime,
    required this.doubleTimeEnabled,
    required this.doubleTimeDuration,
    required this.pushOutEnabled,
    required this.pushOutDuration,
    required this.sets,
    required this.warnings,
    required this.player1,
    required this.player2,
  });
}
