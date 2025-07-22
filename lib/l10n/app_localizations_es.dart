// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get congratulations => '¡Felicidades!';

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
      'La experiencia de Sudoku donde la mente, los números y la IA se encuentran.';

  @override
  String get newGame => 'Nuevo Juego';

  @override
  String get newGameDialogContent =>
      '¿Estás seguro de que quieres empezar un juego nuevo? Tu progreso actual se perderá.';

  @override
  String get newGameDialogTitle => '¿Empezar Nuevo Juego?';

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get puzzleSolved => 'Has resuelto el puzle.';

  @override
  String get reset => 'Reiniciar';

  @override
  String get resetDialogContent =>
      '¿Estás seguro de que quieres limpiar el tablero y empezar de nuevo?';

  @override
  String get resetDialogNo => 'No';

  @override
  String get resetDialogTitle => '¿Reiniciar Tablero?';

  @override
  String get resetDialogYes => 'Sí';
}
