// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get congratulations => 'Herzlichen Glückwunsch!';

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
      'Das Sudoku-Erlebnis, bei dem sich Geist, Zahlen und KI treffen.';

  @override
  String get newGame => 'Neues Spiel';

  @override
  String get newGameDialogContent =>
      'Sind Sie sicher, dass Sie ein neues Spiel starten möchten? Ihr aktueller Fortschritt geht verloren.';

  @override
  String get newGameDialogTitle => 'Neues Spiel starten?';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get puzzleSolved => 'Du hast das Rätsel gelöst.';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get resetDialogContent =>
      'Sind Sie sicher, dass Sie das Spielfeld leeren und von vorne beginnen möchten?';

  @override
  String get resetDialogNo => 'Nein';

  @override
  String get resetDialogTitle => 'Spielfeld zurücksetzen?';

  @override
  String get resetDialogYes => 'Ja';

  @override
  String get solvedDialogTimeLabel => 'Zeit';

  @override
  String get newShort => 'Neu';

  @override
  String get resetShort => 'Zurücksetzen';

  @override
  String get selectDifficulty => 'Schwierigkeit wählen';

  @override
  String get difficultyEasy => 'Einfach';

  @override
  String get difficultyMedium => 'Mittel';

  @override
  String get difficultyHard => 'Schwer';

  @override
  String get difficultyExpert => 'Experte';

  @override
  String get stats => 'Statistiken';

  @override
  String get statsDialogTitle => 'Spielstatistiken';

  @override
  String get statsTotalGames => 'Spiele gesamt';

  @override
  String get statsCompletedGames => 'Abgeschlossene Spiele';

  @override
  String get statsAverageDuration => 'Ø Dauer';

  @override
  String get statsFastestDuration => 'Schnellste Zeit';

  @override
  String get close => 'Schließen';

  @override
  String get settings => 'Menü';

  @override
  String get hint => 'Hinweis';

  @override
  String get noHintAvailableTitle => 'Kein Hinweis verfügbar';

  @override
  String get noMoreHintsMessage =>
      'Auf diesem Level sind keine weiteren Hinweise erlaubt.';

  @override
  String get boardIsCorrectMessage =>
      'Das Spielfeld ist bereits korrekt. Keine Hinweise zu geben!';

  @override
  String get ok => 'OK';
}
