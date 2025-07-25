// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get congratulations => 'Congratulations!';

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
      'The Sudoku experience where mind, numbers, and AI meet.';

  @override
  String get newGame => 'New Game';

  @override
  String get newGameDialogContent =>
      'Are you sure you want to start a new game? Your current progress will be lost.';

  @override
  String get newGameDialogTitle => 'Start New Game?';

  @override
  String get playAgain => 'Play Again';

  @override
  String get puzzleSolved => 'You\'ve solved the puzzle.';

  @override
  String get reset => 'Reset';

  @override
  String get resetDialogContent =>
      'Are you sure you want to clear the board and start over?';

  @override
  String get resetDialogNo => 'No';

  @override
  String get resetDialogTitle => 'Reset Board?';

  @override
  String get resetDialogYes => 'Yes';

  @override
  String get solvedDialogTimeLabel => 'Time';

  @override
  String get newShort => 'New';

  @override
  String get resetShort => 'Reset';

  @override
  String get selectDifficulty => 'Select Difficulty';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get stats => 'Stats';

  @override
  String get statsDialogTitle => 'Game Statistics';

  @override
  String get statsTotalGames => 'Total Games';

  @override
  String get statsCompletedGames => 'Completed Games';

  @override
  String get statsAverageDuration => 'Average Duration';

  @override
  String get statsFastestDuration => 'Fastest Duration';

  @override
  String get close => 'Close';
}
