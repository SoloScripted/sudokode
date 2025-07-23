import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sudokode/models/sudoku_board.dart';
import 'package:sudokode/models/difficulty.dart';
import 'package:sudokode/widgets/sudoku_grid.dart';
import 'package:sudokode/widgets/game_header.dart';
import 'package:sudokode/widgets/number_pad.dart';
import 'package:sudokode/widgets/solved_dialog.dart';
import 'package:sudokode/l10n/app_localizations.dart';

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
    // Initialize with an empty board. The difficulty selection dialog will
    // be shown after the first frame, which will then generate the puzzle.
    _sudokuBoard = SudokuBoard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectInitialDifficulty();
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
    // Update the UI every second.
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

  void _onNumberTap(int number) {
    if (_isPaused) {
      return;
    }
    if (_isCellSelected) {
      if (!_sudokuBoard.isInitialValue(_selectedRow!, _selectedCol!)) {
        setState(() {
          _sudokuBoard.setValue(_selectedRow!, _selectedCol!, number);
          if (_sudokuBoard.isSolved()) {
            _stopTimer();
            _showSolvedDialog();
          }
        });
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

  void _onHintTap() {
    if (_isPaused) {
      return;
    }
    final hintCell = _sudokuBoard.useHint();
    if (hintCell != null) {
      setState(() {
        _selectedRow = hintCell.$1;
        _selectedCol = hintCell.$2;
        if (_sudokuBoard.isSolved()) {
          _stopTimer();
          _showSolvedDialog();
        }
      });
    }
  }

  void _initializeNewGame() {
    _sudokuBoard = SudokuBoard();
    _sudokuBoard.generatePuzzle(_currentDifficulty);
    _selectedRow = null;
    _selectedCol = null;
    _isPaused = false;
    _resetTimer();
    _startTimer();
  }

  void _newGame() {
    setState(_initializeNewGame);
  }

  Future<Difficulty?> _showDifficultySelectionDialog(
      {bool isDismissible = true}) async {
    final l10n = AppLocalizations.of(context)!;
    final double dialogWidth =
        min(MediaQuery.of(context).size.shortestSide * 0.7, 300.0);
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
            width: dialogWidth,
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

  Future<void> _selectInitialDifficulty() async {
    // This is called once when the app starts. It's not dismissible.
    final Difficulty? selectedDifficulty =
        await _showDifficultySelectionDialog(isDismissible: false);

    // selectedDifficulty should not be null, but as a fallback,
    // default to easy.
    if (mounted) {
      setState(() {
        _currentDifficulty = selectedDifficulty ?? Difficulty.easy;
        _initializeNewGame();
      });
    }
  }

  Future<void> _showDifficultyDialog() async {
    // This is called from the "New Game" button.
    final Difficulty? selectedDifficulty = await _showDifficultySelectionDialog();

    if (selectedDifficulty != null && mounted) {
      setState(() {
        _currentDifficulty = selectedDifficulty;
        _initializeNewGame();
      });
    }
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
        onConfirm: _showDifficultyDialog,
      );
    } else {
      _showDifficultyDialog();
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
            _newGame();
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
