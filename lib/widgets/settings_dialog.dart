import 'package:flutter/material.dart';
import 'package:sudokode/l10n/app_localizations.dart';

class SettingsDialog extends StatelessWidget {
  final VoidCallback onNewGameTap;
  final VoidCallback onResetTap;
  final VoidCallback onStatsTap;

  const SettingsDialog({
    super.key,
    required this.onNewGameTap,
    required this.onResetTap,
    required this.onStatsTap,
  });

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.settings),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.autorenew_rounded,
            title: l10n.newGame,
            onTap: onNewGameTap,
          ),
          _buildSettingsItem(
            context,
            icon: Icons.refresh_rounded,
            title: l10n.reset,
            onTap: onResetTap,
          ),
          _buildSettingsItem(
            context,
            icon: Icons.leaderboard_outlined,
            title: l10n.stats,
            onTap: onStatsTap,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
