import 'dart:math';

import 'package:sudokode/models/difficulty.dart';

enum NoHintReason {
  noMoreHints,
  boardIsCorrect,
}

class NoHintAvailableException implements Exception {
  final NoHintReason reason;
  NoHintAvailableException(this.reason);
}

class SudokuBoard {
  late List<List<int>> _board;
  late List<List<int>> _solutionBoard;
  late List<List<bool>> _initialValues;
  late List<List<bool>> _conflicts;
  int _hintsUsed = 0;
  late int maxHints;

  SudokuBoard() {
    _board = List.generate(9, (_) => List.generate(9, (_) => 0));
    _solutionBoard = List.generate(9, (_) => List.generate(9, (_) => 0));
    _initialValues = List.generate(9, (_) => List.generate(9, (_) => false));
    _conflicts = List.generate(9, (_) => List.generate(9, (_) => false));
    maxHints = 0; // Default value to prevent late initialization errors.
  }

  int getValue(int row, int col) => _board[row][col];
  bool isInitialValue(int row, int col) => _initialValues[row][col];
  bool isConflict(int row, int col) => _conflicts[row][col];

  int get hintsUsed => _hintsUsed;
  int get remainingHints => maxHints - _hintsUsed;
  bool get canUseHint => _hintsUsed < maxHints;

  int countOccurrences(int value) {
    int count = 0;
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (_board[r][c] == value) {
          count++;
        }
      }
    }
    return count;
  }

  bool isSolved() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (_board[r][c] == 0) {
          return false;
        }
      }
    }

    validateBoard();
    return !_conflicts.any((row) => row.any((isConflict) => isConflict));
  }

  void setValue(int row, int col, int value) {
    if (!isInitialValue(row, col)) {
      _board[row][col] = value;
      validateBoard();
    }
  }

  bool isModified() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (!_initialValues[r][c] && _board[r][c] != 0) {
          return true;
        }
      }
    }
    return false;
  }

  void resetBoard() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (!_initialValues[r][c]) {
          _board[r][c] = 0;
        }
      }
    }
    validateBoard();
  }

  (int, int) useHint() {
    if (!canUseHint) {
      throw NoHintAvailableException(NoHintReason.noMoreHints);
    }

    final availableCells = <(int, int)>[];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (!_initialValues[r][c] && _board[r][c] != _solutionBoard[r][c]) {
          availableCells.add((r, c));
        }
      }
    }

    if (availableCells.isEmpty) {
      throw NoHintAvailableException(NoHintReason.boardIsCorrect);
    }

    availableCells.shuffle();
    final (row, col) = availableCells.first;
    setValue(row, col, _solutionBoard[row][col]);
    _initialValues[row][col] = true;
    _hintsUsed++;
    return (row, col);
  }

  void generatePuzzle(Difficulty difficulty) {
    maxHints = difficulty.maxHints;
    _hintsUsed = 0;

    _fillBoard();

    _solutionBoard = List.generate(9, (r) => List.from(_board[r]));

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (_board[r][c] != 0) {
          _initialValues[r][c] = true;
        }
      }
    }

    _removeNumbers(difficulty.emptyCells);
    validateBoard();
  }

  void validateBoard() {
    _conflicts = List.generate(9, (_) => List.generate(9, (_) => false));

    void markConflicts(List<(int, int)> cells) {
      if (cells.length > 1) {
        for (final cell in cells) {
          _conflicts[cell.$1][cell.$2] = true;
        }
      }
    }

    for (int i = 0; i < 9; i++) {
      final rowSeen = <int, List<(int, int)>>{};
      final colSeen = <int, List<(int, int)>>{};
      for (int j = 0; j < 9; j++) {
        if (_board[i][j] != 0) {
          rowSeen.putIfAbsent(_board[i][j], () => []).add((i, j));
        }
        if (_board[j][i] != 0) {
          colSeen.putIfAbsent(_board[j][i], () => []).add((j, i));
        }
      }
      rowSeen.values.forEach(markConflicts);
      colSeen.values.forEach(markConflicts);
    }

    for (int boxRow = 0; boxRow < 3; boxRow++) {
      for (int boxCol = 0; boxCol < 3; boxCol++) {
        final boxSeen = <int, List<(int, int)>>{};
        for (int r = 0; r < 3; r++) {
          for (int c = 0; c < 3; c++) {
            final row = boxRow * 3 + r;
            final col = boxCol * 3 + c;
            if (_board[row][col] != 0) {
              boxSeen.putIfAbsent(_board[row][col], () => []).add((row, col));
            }
          }
        }
        boxSeen.values.forEach(markConflicts);
      }
    }
  }

  bool _fillBoard() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (_board[r][c] == 0) {
          final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();
          for (int num in numbers) {
            if (_isSafe(r, c, num)) {
              _board[r][c] = num;
              if (_fillBoard()) {
                return true;
              }
              _board[r][c] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  void _removeNumbers(int count) {
    final random = Random();
    while (count > 0) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      if (_board[row][col] != 0) {
        _board[row][col] = 0;
        _initialValues[row][col] = false;
        count--;
      }
    }
  }

  bool _isSafe(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (_board[row][i] == num || _board[i][col] == num) return false;
    }
    int startRow = row - row % 3, startCol = col - col % 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (_board[r + startRow][c + startCol] == num) return false;
      }
    }
    return true;
  }

  void grantExtraHint() {
    maxHints++;
  }

}
