import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shared_components/flutter_shared_components.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudokode/screens/game_screen.dart';
import 'package:sudokode/services/game_stats.dart';
import 'package:sudokode/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GameStats().loadStats();
  // Initialize AdMob only on mobile platforms, not on web.
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await MobileAds.instance.initialize();
  }

  runApp(const SoloScriptedApp(
    title: 'SudoKode',
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    mainScreen: GameScreen(),
  ));
}
