import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sudokode/l10n/app_localizations.dart';
import 'package:sudokode/models/difficulty.dart';
import 'package:sudokode/models/sudoku_board.dart';
import 'package:sudokode/services/game_stats.dart';
import 'package:sudokode/widgets/game_header.dart';
import 'package:sudokode/widgets/number_pad.dart';
import 'package:sudokode/widgets/solved_dialog.dart';
import 'package:sudokode/widgets/stats_dialog.dart';
import 'package:sudokode/widgets/sudoku_grid.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

final ThemeData _lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blue,
);

class _GameScreenState extends State<GameScreen> {
  late SudokuBoard _sudokuBoard;
  int? _selectedRow;
  int? _selectedCol;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsedTime = '00:00';
  bool _isPaused = false;
  Difficulty _currentDifficulty = Difficulty.medium;

  bool get _isCellSelected => _selectedRow != null && _selectedCol != null;

  @override
  void initState() {
    super.initState();
    _sudokuBoard = SudokuBoard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectDifficultyAndStartGame(isCancellable: false);
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _elapsedTime = _formatElapsedTime(_stopwatch.elapsed);
        });
      }
    });
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetTimer() {
    _stopwatch.stop();
    _timer?.cancel();
    _stopwatch.reset();
    _elapsedTime = '00:00';
  }

  void _togglePause() {
    if (_sudokuBoard.isSolved()) {
      return;
    }
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
    });
  }

  void _onCellTap(int row, int col) {
    if (_isPaused) {
      return;
    }
    setState(() {
      _selectedRow = row;
      _selectedCol = col;
    });
  }

  void _onNumberTap(int number) async {
    if (_isPaused) {
      return;
    }
    if (_isCellSelected) {
      if (!_sudokuBoard.isInitialValue(_selectedRow!, _selectedCol!)) {
        setState(
            () => _sudokuBoard.setValue(_selectedRow!, _selectedCol!, number));
        if (_sudokuBoard.isSolved()) {
          _stopTimer();
          await GameStats().recordGameCompleted(_stopwatch.elapsed);
          _showSolvedDialog();
        }
      }
    }
  }

  void _onEraseTap() {
    if (_isPaused) {
      return;
    }
    if (_isCellSelected) {
      if (!_sudokuBoard.isInitialValue(_selectedRow!, _selectedCol!)) {
        setState(() {
          _sudokuBoard.setValue(_selectedRow!, _selectedCol!, 0);
        });
      }
    }
  }

  void _onHintTap() async {
    if (_isPaused) {
      return;
    }
    final hintCell = _sudokuBoard.useHint();
    if (hintCell != null) {
      setState(() {
        _selectedRow = hintCell.$1;
        _selectedCol = hintCell.$2;
      });
      if (_sudokuBoard.isSolved()) {
        _stopTimer();
        await GameStats().recordGameCompleted(_stopwatch.elapsed);
        _showSolvedDialog();
      }
    }
  }

  Future<void> _initializeNewGame() async {
    _sudokuBoard = SudokuBoard();
    _sudokuBoard.generatePuzzle(_currentDifficulty);
    _selectedRow = null;
    _selectedCol = null;
    _isPaused = false;
    _resetTimer();
    await GameStats().recordGameStarted();
    _startTimer();
  }

  Future<void> _selectDifficultyAndStartGame(
      {bool isCancellable = true}) async {
    final selectedDifficulty = await _showDifficultySelectionDialog(
      isDismissible: isCancellable,
    );

    if (!mounted) return;

    Difficulty? difficultyToStart;
    if (selectedDifficulty != null) {
      difficultyToStart = selectedDifficulty;
    } else if (!isCancellable) {
      difficultyToStart = Difficulty.easy;
    }

    if (difficultyToStart != null) {
      _currentDifficulty = difficultyToStart;
      await _initializeNewGame();
      if (mounted) setState(() {});
    }
  }

  Future<Difficulty?> _showDifficultySelectionDialog(
      {bool isDismissible = true}) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<Difficulty>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.bar_chart_rounded),
              const SizedBox(width: 10),
              Text(l10n.selectDifficulty),
            ],
          ),
          content: SizedBox(
            width: min(MediaQuery.of(context).size.shortestSide * 0.7, 300.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildDifficultyButtons(context),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDifficultyButtons(BuildContext context) {
    return Difficulty.values.map((difficulty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(difficulty.icon),
                const SizedBox(width: 8),
                Text(
                  difficulty.localizedName(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onPressed: () => Navigator.of(context).pop(difficulty),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _handleConfirmationAction({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) async {
    final bool? confirmed = await _showConfirmationDialog(
      context,
      title,
      content,
    );
    if (!mounted) return;
    if (confirmed == true) {
      onConfirm();
    }
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext dialogContext, String title, String content) async {
    if (!mounted) return null;
    final l10n = AppLocalizations.of(dialogContext)!;
    return await showDialog<bool>(
      context: dialogContext,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.resetDialogNo)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.resetDialogYes)),
        ],
      ),
    );
  }

  void _onNewGameTap(BuildContext dialogContext) {
    if (_sudokuBoard.isModified()) {
      final l10n = AppLocalizations.of(dialogContext)!;
      _handleConfirmationAction(
        context: dialogContext,
        title: l10n.newGameDialogTitle,
        content: l10n.newGameDialogContent,
        onConfirm: () => _selectDifficultyAndStartGame(isCancellable: true),
      );
    } else {
      _selectDifficultyAndStartGame(isCancellable: true);
    }
  }

  void _resetBoard() {
    setState(() {
      _sudokuBoard.resetBoard();
      _selectedRow = null;
      _selectedCol = null;
      _resetTimer();
      _startTimer();
      _isPaused = false;
    });
  }

  void _onResetTap(BuildContext dialogContext) {
    final l10n = AppLocalizations.of(dialogContext)!;
    _handleConfirmationAction(
      context: dialogContext,
      title: l10n.resetDialogTitle,
      content: l10n.resetDialogContent,
      onConfirm: _resetBoard,
    );
  }

  String _formatElapsedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _showSolvedDialog() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SolvedDialog(
          elapsedTime: _elapsedTime,
          onPlayAgain: () {
            Navigator.of(context).pop();
            _selectDifficultyAndStartGame();
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
      },
    );
  }

  Future<void> _showStatsDialog() async {
    // The timer should be paused when viewing stats.
    final bool wasPaused = _isPaused;
    if (!wasPaused) {
      _togglePause();
    }

    await showDialog(
      context: context,
      builder: (context) {
        return const StatsDialog();
      },
    );

    // Resume timer if it was running before.
    if (!wasPaused) {
      _togglePause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenShortestSide = MediaQuery.of(context).size.shortestSide;
    const double maxGridSize = 600.0;
    final double componentWidth = min(screenShortestSide * 0.9, maxGridSize);

    return Theme(
      data: _lightTheme,
      child: Scaffold(
        body: Builder(builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: componentWidth,
                      child: GameHeader(
                        elapsedTime: _elapsedTime,
                        isBoardModified: _sudokuBoard.isModified(),
                        onResetTap: () => _onResetTap(context),
                        onNewGameTap: () => _onNewGameTap(context),
                        onTimerTap: _togglePause,
                        onStatsTap: _showStatsDialog,
                        isPaused: _isPaused,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: componentWidth,
                      height: componentWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SudokuGrid(
                          board: _sudokuBoard,
                          selectedRow: _selectedRow,
                          selectedCol: _selectedCol,
                          onCellTap: _onCellTap,
                          isPaused: _isPaused,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _isPaused ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: _isPaused,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              width: componentWidth,
                              child: NumberPad(
                                onNumberTap: _onNumberTap,
                                onEraseTap: _onEraseTap,
                                onHintTap: _onHintTap,
                                remainingHints: _sudokuBoard.remainingHints,
                                getOccurrences: _sudokuBoard.countOccurrences,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
