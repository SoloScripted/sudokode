import 'package:shared_preferences/shared_preferences.dart';

class GameStats {
  int totalGames = 0;
  int completedGames = 0;
  Duration averageDuration = Duration.zero;
  Duration fastestDuration = Duration.zero;

  int _totalDurationMillis = 0;

  static const String _totalGamesKey = 'stats_totalGames';
  static const String _completedGamesKey = 'stats_completedGames';
  static const String _totalDurationMillisKey = 'stats_totalDurationMillis';
  static const String _fastestDurationMillisKey = 'stats_fastestDurationMillis';

  GameStats._privateConstructor();

  static final GameStats _instance = GameStats._privateConstructor();

  factory GameStats() {
    return _instance;
  }

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    totalGames = prefs.getInt(_totalGamesKey) ?? 0;
    completedGames = prefs.getInt(_completedGamesKey) ?? 0;
    _totalDurationMillis = prefs.getInt(_totalDurationMillisKey) ?? 0;

    final int fastestMillis = prefs.getInt(_fastestDurationMillisKey) ?? 0;
    fastestDuration = Duration(milliseconds: fastestMillis);

    if (completedGames > 0) {
      averageDuration =
          Duration(milliseconds: _totalDurationMillis ~/ completedGames);
    }
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalGamesKey, totalGames);
    await prefs.setInt(_completedGamesKey, completedGames);
    await prefs.setInt(_totalDurationMillisKey, _totalDurationMillis);
    await prefs.setInt(
        _fastestDurationMillisKey, fastestDuration.inMilliseconds);
  }

  Future<void> recordGameStarted() async {
    totalGames++;
    await _saveStats();
  }

  Future<void> recordGameCompleted(Duration duration) async {
    completedGames++;
    _totalDurationMillis += duration.inMilliseconds;

    if (fastestDuration == Duration.zero || duration < fastestDuration) {
      fastestDuration = duration;
    }

    if (completedGames > 0) {
      averageDuration =
          Duration(milliseconds: _totalDurationMillis ~/ completedGames);
    }

    await _saveStats();
  }

  void resetStats() {
    totalGames = 0;
    completedGames = 0;
    averageDuration = Duration.zero;
    fastestDuration = Duration.zero;
    _totalDurationMillis = 0;
    _saveStats();
  }
}
