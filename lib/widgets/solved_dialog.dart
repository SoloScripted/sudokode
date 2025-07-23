import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sudokode/l10n/app_localizations.dart';

class SolvedDialog extends StatelessWidget {
  final String elapsedTime;
  final VoidCallback onPlayAgain;

  const SolvedDialog({
    super.key,
    required this.elapsedTime,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenShortestSide = MediaQuery.of(context).size.shortestSide;
    final dialogMaxWidth = min(screenShortestSide * 0.8, 400.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogMaxWidth),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration, color: Colors.amber, size: 80),
                const SizedBox(height: 16),
                Text(
                  l10n.congratulations,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.puzzleSolved,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  '${l10n.solvedDialogTimeLabel}: $elapsedTime',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onPlayAgain,
                    child: Text(l10n.playAgain),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
