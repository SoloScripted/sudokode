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

  Widget _buildIcon() {
    return const Icon(Icons.celebration, color: Colors.amber, size: 80);
  }

  Widget _buildTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.congratulations,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.puzzleSolved,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildElapsedTime(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      '${l10n.solvedDialogTimeLabel}: $elapsedTime',
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  Widget _buildPlayAgainButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPlayAgain,
        child: Text(l10n.playAgain),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
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
          _buildIcon(),
          const SizedBox(height: 16),
          _buildTitle(context),
          const SizedBox(height: 8),
          _buildMessage(context),
          const SizedBox(height: 16),
          _buildElapsedTime(context),
          const SizedBox(height: 24),
          _buildPlayAgainButton(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenShortestSide = MediaQuery.of(context).size.shortestSide;
    final dialogMaxWidth = min(screenShortestSide * 0.8, 400.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogMaxWidth),
        child: Material(
          type: MaterialType.transparency,
          child: _buildDialogContent(context),
        ),
      ),
    );
  }
}
