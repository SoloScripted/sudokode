import 'package:flutter/material.dart';
import 'package:sudokode/models/sudoku_board.dart';
import 'package:sudokode/widgets/sudoku_cell.dart';

const _kGridOutlineAlpha = 51; // 0.2 opacity
const _kGridShadowAlpha = 77; // 0.3 opacity

class SudokuGrid extends StatelessWidget {
  final SudokuBoard board;
  final int? selectedRow;
  final int? selectedCol;
  final void Function(int, int) onCellTap;

  const SudokuGrid({
    super.key,
    required this.board,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(
            color: colorScheme.outline.withAlpha(_kGridOutlineAlpha)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(_kGridShadowAlpha),
            blurRadius: 10,
            offset: const Offset(4, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, boxIndex) {
              final boxRow = boxIndex ~/ 3;
              final boxCol = boxIndex % 3;

              return GridView.builder(
                padding: const EdgeInsets.all(2.0),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                ),
                itemCount: 9,
                itemBuilder: (context, cellInBoxIndex) {
                  final cellRow = cellInBoxIndex ~/ 3;
                  final cellCol = cellInBoxIndex % 3;
                  final row = boxRow * 3 + cellRow;
                  final col = boxCol * 3 + cellCol;
                  final isInitial = board.isInitialValue(row, col);

                  return SudokuCell(
                    value: board.getValue(row, col),
                    isInitial: isInitial,
                    isSelected: row == selectedRow && col == selectedCol,
                    isConflict: board.isConflict(row, col),
                    onTap: isInitial ? null : () => onCellTap(row, col),
                    cellBackgroundColor: (boxIndex % 2 == 0)
                        ? colorScheme.surface
                        : colorScheme.surfaceContainer,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
