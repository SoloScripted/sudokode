import 'package:flutter/material.dart';
import 'package:flutter_shared_components/flutter_shared_components.dart';
import 'package:sudokode/l10n/app_localizations.dart';
import 'package:sudokode/widgets/settings_dialog.dart';

class GameHeader extends StatelessWidget {
  final String elapsedTime;
  final bool isBoardModified;
  final VoidCallback onResetTap;
  final VoidCallback onNewGameTap;
  final VoidCallback onTimerTap;
  final VoidCallback onStatsTap;
  final VoidCallback onHintTap;
  final bool isPaused;

  const GameHeader({
    super.key,
    required this.elapsedTime,
    required this.isBoardModified,
    required this.onResetTap,
    required this.onNewGameTap,
    required this.onTimerTap,
    required this.onStatsTap,
    required this.onHintTap,
    required this.isPaused,
  });

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SettingsDialog(
          onNewGameTap: onNewGameTap,
          onResetTap: onResetTap,
          onStatsTap: onStatsTap,
        );
      },
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color color,
    String? fontFamily,
  }) {
    final children = <Widget>[
      Icon(icon, color: color, size: 20),
    ];
    children.addAll([
      const SizedBox(height: 4),
      Text(
        text,
        style: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 12,
        ),
      ),
    ]);
    return StyledActionButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final timerColor = isPaused
        ? colorScheme.secondary
        : colorScheme.onSurface.withOpacity(0.85);
    final timerIcon =
        isPaused ? Icons.pause_circle_outline : Icons.timer_outlined;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildActionButton(
          onPressed: onHintTap,
          icon: Icons.lightbulb_outline,
          text: l10n.hint,
          color: timerColor,
          fontFamily: 'monospace',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          onPressed: onTimerTap,
          icon: timerIcon,
          text: elapsedTime,
          color: timerColor,
          fontFamily: 'monospace',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          onPressed: () => _showSettingsDialog(context),
          icon: Icons.more_vert,
          color: colorScheme.onSurface,
          text: l10n.settings,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const GameTitle(
          logoAsset: 'assets/sudokode.png',
          titlePart1: 'Sudo ',
          titlePart2: 'Kode',
        ),
        const Spacer(),
        _buildActionButtons(context),
      ],
    );
  }
}
