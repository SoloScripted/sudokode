import 'package:flutter/material.dart';
import 'package:flutter_shared_components/flutter_shared_components.dart';
import 'package:sudokode/screens/game_screen.dart';
import 'package:sudokode/services/game_stats.dart';
import 'package:sudokode/l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GameStats().loadStats();

  runApp(const SoloScriptedApp(
    title: 'SudoKode',
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    mainScreen: GameScreen(),
  ));
}
