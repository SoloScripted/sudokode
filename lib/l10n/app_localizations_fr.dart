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
      'L\'expérience Sudoku où l\'esprit, les chiffres et l\'IA se rencontrent.';

  @override
  String get newGame => 'Nouvelle Partie';

  @override
  String get newGameDialogContent =>
      'Êtes-vous sûr de vouloir commencer une nouvelle partie ? Votre progression actuelle sera perdue.';

  @override
  String get newGameDialogTitle => 'Commencer une Nouvelle Partie ?';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get puzzleSolved => 'Vous avez résolu le puzzle.';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resetDialogContent =>
      'Êtes-vous sûr de vouloir effacer le plateau et recommencer ?';

  @override
  String get resetDialogNo => 'Non';

  @override
  String get resetDialogTitle => 'Réinitialiser le Plateau ?';

  @override
  String get resetDialogYes => 'Oui';

  @override
  String get solvedDialogTimeLabel => 'Temps';

  @override
  String get newShort => 'Nouveau';

  @override
  String get resetShort => 'Réinit.';

  @override
  String get selectDifficulty => 'Sélectionner la Difficulté';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get stats => 'Statistiques';

  @override
  String get statsDialogTitle => 'Statistiques de Jeu';

  @override
  String get statsTotalGames => 'Parties Totales';

  @override
  String get statsCompletedGames => 'Parties Terminées';

  @override
  String get statsAverageDuration => 'Durée Moyenne';

  @override
  String get statsFastestDuration => 'Durée la Plus Rapide';

  @override
  String get close => 'Fermer';

  @override
  String get settings => 'Paramètres';
}
