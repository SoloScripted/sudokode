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
  String get newGame => 'Nuevo juego';

  @override
  String get newGameDialogContent =>
      '¿Estás seguro de que quieres empezar un nuevo juego? Tu progreso actual se perderá.';

  @override
  String get newGameDialogTitle => '¿Empezar un juego nuevo?';

  @override
  String get playAgain => 'Jugar de nuevo';

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
  String get resetDialogTitle => '¿Reiniciar tablero?';

  @override
  String get resetDialogYes => 'Sí';

  @override
  String get solvedDialogTimeLabel => 'Tiempo';

  @override
  String get newShort => 'Nuevo';

  @override
  String get resetShort => 'Reiniciar';

  @override
  String get selectDifficulty => 'Seleccionar dificultad';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Medio';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyExpert => 'Experto';

  @override
  String get stats => 'Estadísticas';

  @override
  String get statsDialogTitle => 'Estadísticas del juego';

  @override
  String get statsTotalGames => 'Juegos totales';

  @override
  String get statsCompletedGames => 'Juegos completados';

  @override
  String get statsAverageDuration => 'Duración promedio';

  @override
  String get statsFastestDuration => 'Duración más rápida';

  @override
  String get close => 'Cerrar';

  @override
  String get settings => 'Menú';

  @override
  String get hint => 'Pista';

  @override
  String get noHintAvailableTitle => 'No hay pistas disponibles';

  @override
  String get noMoreHintsMessage => 'No se permiten más pistas en este nivel.';

  @override
  String get boardIsCorrectMessage =>
      'El tablero ya está correcto. ¡No hay pistas que dar!';

  @override
  String get ok => 'Aceptar';
}
