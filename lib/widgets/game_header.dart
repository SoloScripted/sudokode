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

  Widget _buildHeaderButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color onSurfaceColor,
  }) {
    return StyledActionButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: onSurfaceColor,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: onSurfaceColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerButton({
    required BuildContext context,
    required String text,
    required Color onSurfaceColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final timerColor = isPaused ? colorScheme.secondary : onSurfaceColor;
    final icon = isPaused ? Icons.pause_circle_outline : Icons.timer_outlined;

    return StyledActionButton(
      onPressed: onTimerTap,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: timerColor,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: timerColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withAlpha(102),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Image.asset(
            'assets/sudokode.png',
            height: 64,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.code_sharp,
                size: 64,
                color: Colors.white,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: const Offset(1.5, 1.5),
                  blurRadius: 2.0,
                  color: Theme.of(context).colorScheme.shadow.withAlpha(102),
                ),
              ],
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Sudo ',
                style: TextStyle(color: Colors.blue),
              ),
              TextSpan(
                text: 'Kode',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: isPaused ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: isPaused,
                child: Row(
                  children: [
                    Visibility(
                      visible: isBoardModified,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: _buildHeaderButton(
                        context: context,
                        onPressed: onResetTap,
                        icon: Icons.refresh_rounded,
                        text: l10n.resetShort,
                        onSurfaceColor: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildHeaderButton(
                      context: context,
                      onPressed: onNewGameTap,
                      icon: Icons.autorenew_rounded,
                      text: l10n.newShort,
                      onSurfaceColor: colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            _buildTimerButton(
              context: context,
              text: elapsedTime,
              onSurfaceColor: colorScheme.onSurface.withOpacity(0.85),
            ),
          ],
        ),
      ],
    );
  }
}
