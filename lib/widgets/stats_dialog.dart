import 'package:flutter/material.dart';
import 'package:sudokode/l10n/app_localizations.dart';
import 'package:sudokode/services/game_stats.dart';

class StatsDialog extends StatefulWidget {
  const StatsDialog({super.key});

  @override
  State<StatsDialog> createState() => _StatsDialogState();
}

class _StatsDialogState extends State<StatsDialog> {
  final GameStats _gameStats = GameStats();

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return 'N/A';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _resetStats() {
    setState(() {
      _gameStats.resetStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.leaderboard_outlined),
          const SizedBox(width: 10),
          Text(l10n.statsDialogTitle),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.statsTotalGames}: ${_gameStats.totalGames}'),
          const SizedBox(height: 8),
          Text('${l10n.statsCompletedGames}: ${_gameStats.completedGames}'),
          const SizedBox(height: 8),
          Text(
              '${l10n.statsAverageDuration}: ${_formatDuration(_gameStats.averageDuration)}'),
          const SizedBox(height: 8),
          Text(
              '${l10n.statsFastestDuration}: ${_formatDuration(_gameStats.fastestDuration)}'),
        ],
      ),
      actions: [
        TextButton(onPressed: _resetStats, child: Text(l10n.reset)),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close)),
      ],
    );
  }
}
