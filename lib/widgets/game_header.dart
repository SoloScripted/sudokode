import 'package:flutter/material.dart';
import 'package:flutter_shared_components/flutter_shared_components.dart';
import 'package:sudokode/l10n/app_localizations.dart';

class GameHeader extends StatelessWidget {
  final bool isBoardModified;
  final VoidCallback onResetTap;
  final VoidCallback onNewGameTap;

  const GameHeader({
    super.key,
    required this.isBoardModified,
    required this.onResetTap,
    required this.onNewGameTap,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: onSurfaceColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: onSurfaceColor,
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
        Visibility(
          visible: isBoardModified,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: _buildHeaderButton(
            context: context,
            onPressed: onResetTap,
            icon: Icons.refresh,
            text: l10n.reset,
            onSurfaceColor: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        _buildHeaderButton(
          context: context,
          onPressed: onNewGameTap,
          icon: Icons.autorenew,
          text: l10n.newGame,
          onSurfaceColor: colorScheme.onSurface,
        ),
      ],
    );
  }
}
