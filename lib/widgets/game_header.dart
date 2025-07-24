import 'package:flutter/material.dart';
import 'package:flutter_shared_components/flutter_shared_components.dart';
import 'package:sudokode/l10n/app_localizations.dart';

class GameHeader extends StatelessWidget {
  final String elapsedTime;
  final bool isBoardModified;
  final VoidCallback onResetTap;
  final VoidCallback onNewGameTap;
  final VoidCallback onTimerTap;
  final bool isPaused;

  const GameHeader({
    super.key,
    required this.elapsedTime,
    required this.isBoardModified,
    required this.onResetTap,
    required this.onNewGameTap,
    required this.onTimerTap,
    required this.isPaused,
  });

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color color,
    String? fontFamily,
    bool? dynamicalVisible,
  }) {
    final button = StyledActionButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
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
        ],
      ),
    );

    if (dynamicalVisible != null) {
      return Visibility(
        visible: isBoardModified,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: button,
      );
    }

    return button;
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
        AnimatedOpacity(
          opacity: isPaused ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: isPaused,
            child: Row(
              children: [
                _buildActionButton(
                  onPressed: onResetTap,
                  icon: Icons.refresh_rounded,
                  text: l10n.resetShort,
                  color: colorScheme.onSurface,
                  dynamicalVisible: true,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  onPressed: onNewGameTap,
                  icon: Icons.autorenew_rounded,
                  text: l10n.newShort,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        _buildActionButton(
          onPressed: onTimerTap,
          icon: timerIcon,
          text: elapsedTime,
          color: timerColor,
          fontFamily: 'monospace',
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
