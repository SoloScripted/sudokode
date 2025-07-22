// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get congratulations => 'Félicitations !';

  @override
  String get copyright => '© 2025 SoloScripted';

  @override
  String get gameScreenTitle => 'Sudokode';

  @override
  String get gameScreenTitlePart1 => 'Sudo ';

  @override
  String get gameScreenTitlePart2 => 'Kode';

  @override
  String get homeScreenSubtitle =>
      'L\'expérience Sudoku où l\'esprit, les nombres et l\'IA se rencontrent.';

  @override
  String get newGame => 'Nouveau Jeu';

  @override
  String get newGameDialogContent =>
      'Êtes-vous sûr de vouloir commencer une nouvelle partie ? Votre progression actuelle sera perdue.';

  @override
  String get newGameDialogTitle => 'Commencer une nouvelle partie ?';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get puzzleSolved => 'Vous avez résolu le puzzle.';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resetDialogContent =>
      'Êtes-vous sûr de vouloir effacer la grille et recommencer ?';

  @override
  String get resetDialogNo => 'Non';

  @override
  String get resetDialogTitle => 'Réinitialiser la grille ?';

  @override
  String get resetDialogYes => 'Oui';
}
