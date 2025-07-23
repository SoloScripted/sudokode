// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get congratulations => 'Tebrikler!';

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
      'Zihin, sayılar ve yapay zekanın buluştuğu Sudoku deneyimi.';

  @override
  String get newGame => 'Yeni Oyun';

  @override
  String get newGameDialogContent =>
      'Yeni bir oyun başlatmak istediğinizden emin misiniz? Mevcut ilerlemeniz kaybolacak.';

  @override
  String get newGameDialogTitle => 'Yeni Oyun Başlatılsın mı?';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get puzzleSolved => 'Bulmacayı çözdünüz.';

  @override
  String get reset => 'Sıfırla';

  @override
  String get resetDialogContent =>
      'Tahtayı temizleyip yeniden başlamak istediğinizden emin misiniz?';

  @override
  String get resetDialogNo => 'Hayır';

  @override
  String get resetDialogTitle => 'Tahtayı Sıfırla?';

  @override
  String get resetDialogYes => 'Evet';

  @override
  String get solvedDialogTimeLabel => 'Süre';

  @override
  String get newShort => 'Yeni';

  @override
  String get resetShort => 'Sıfırla';

  @override
  String get selectDifficulty => 'Zorluk Seçin';

  @override
  String get difficultyEasy => 'Kolay';

  @override
  String get difficultyMedium => 'Orta';

  @override
  String get difficultyHard => 'Zor';

  @override
  String get difficultyExpert => 'Uzman';
}
