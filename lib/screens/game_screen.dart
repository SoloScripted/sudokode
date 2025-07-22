import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sudokode/models/sudoku_board.dart';
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

  bool get _isCellSelected => _selectedRow != null && _selectedCol != null;

  @override
  void initState() {
    super.initState();
    _sudokuBoard = SudokuBoard();
    _sudokuBoard.generatePuzzle();
  }

  void _onCellTap(int row, int col) {
    setState(() {
      _selectedRow = row;
      _selectedCol = col;
    });
  }

  void _onNumberTap(int number) {
    if (_isCellSelected) {
      if (!_sudokuBoard.isInitialValue(_selectedRow!, _selectedCol!)) {
        setState(() {
          _sudokuBoard.setValue(_selectedRow!, _selectedCol!, number);
          if (_sudokuBoard.isSolved()) {
            _showSolvedDialog();
          }
        });
      }
    }
  }

  void _onEraseTap() {
    if (_isCellSelected) {
      if (!_sudokuBoard.isInitialValue(_selectedRow!, _selectedCol!)) {
        setState(() {
          _sudokuBoard.setValue(_selectedRow!, _selectedCol!, 0);
        });
      }
    }
  }

  void _onHintTap() {
    final hintCell = _sudokuBoard.useHint();
    if (hintCell != null) {
      setState(() {
        _selectedRow = hintCell.$1;
        _selectedCol = hintCell.$2;
        if (_sudokuBoard.isSolved()) {
          _showSolvedDialog();
        }
      });
    }
  }

  void _newGame() {
    setState(() {
      _sudokuBoard = SudokuBoard();
      _sudokuBoard.generatePuzzle();
      _selectedRow = null;
      _selectedCol = null;
    });
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
    final l10n = AppLocalizations.of(dialogContext)!;
    _handleConfirmationAction(
      context: dialogContext,
      title: l10n.newGameDialogTitle,
      content: l10n.newGameDialogContent,
      onConfirm: _newGame,
    );
  }

  void _resetBoard() {
    setState(() {
      _sudokuBoard.resetBoard();
      _selectedRow = null;
      _selectedCol = null;
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
                        isBoardModified: _sudokuBoard.isModified(),
                        onResetTap: () => _onResetTap(context),
                        onNewGameTap: () => _onNewGameTap(context),
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
                        ),
                      ),
                    ),
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
          );
        }),
      ),
    );
  }
}
