import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart' show BuildContext, IconData;
import 'package:sudokode/l10n/app_localizations.dart';

enum Difficulty {
  easy(
    DifficultySettings(
      emptyCells: 40,
      maxHints: 5,
      icon: Icons.wb_sunny_outlined,
    ),
  ),
  medium(
    DifficultySettings(
      emptyCells: 50,
      maxHints: 3,
      icon: Icons.thermostat_outlined,
    ),
  ),
  hard(
    DifficultySettings(
      emptyCells: 55,
      maxHints: 1,
      icon: Icons.whatshot_outlined,
    ),
  ),
  expert(
    DifficultySettings(
      emptyCells: 60,
      maxHints: 0,
      icon: Icons.local_fire_department_outlined,
    ),
  );

  const Difficulty(this.settings);

  final DifficultySettings settings;

  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case Difficulty.easy:
        return l10n.difficultyEasy;
      case Difficulty.medium:
        return l10n.difficultyMedium;
      case Difficulty.hard:
        return l10n.difficultyHard;
      case Difficulty.expert:
        return l10n.difficultyExpert;
    }
  }

  IconData get icon => settings.icon;
  int get emptyCells => settings.emptyCells;
  int get maxHints => settings.maxHints;
}

@immutable
class DifficultySettings {
  final int emptyCells;
  final int maxHints;
  final IconData icon;

  const DifficultySettings(
      {required this.emptyCells, required this.maxHints, required this.icon});
}
