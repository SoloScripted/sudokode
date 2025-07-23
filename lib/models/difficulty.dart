import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart' show BuildContext, IconData;
import 'package:sudokode/l10n/app_localizations.dart';

enum Difficulty {
  easy,
  medium,
  hard,
  expert,
}

@immutable
class DifficultySettings {
  final int emptyCells;
  final int maxHints;
  final IconData icon;

  const DifficultySettings(
      {required this.emptyCells, required this.maxHints, required this.icon});
}

extension DifficultyExtension on Difficulty {
  // Using a map for settings for easier management and localization.
  static final Map<Difficulty, DifficultySettings> _settings = {
    Difficulty.easy: const DifficultySettings(
      emptyCells: 40,
      maxHints: 5,
      icon: Icons.wb_sunny_outlined,
    ),
    Difficulty.medium: const DifficultySettings(
      emptyCells: 50,
      maxHints: 3,
      icon: Icons.thermostat_outlined,
    ),
    Difficulty.hard: const DifficultySettings(
      emptyCells: 55,
      maxHints: 1,
      icon: Icons.whatshot_outlined,
    ),
    Difficulty.expert: const DifficultySettings(
      emptyCells: 60,
      maxHints: 0,
      icon: Icons.local_fire_department_outlined,
    ),
  };

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

  IconData get icon => _settings[this]!.icon;
  int get emptyCells => _settings[this]!.emptyCells;
  int get maxHints => _settings[this]!.maxHints;
}
