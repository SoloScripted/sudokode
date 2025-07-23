import 'dart:ui';
import 'package:flutter/material.dart';

const _initialValueColor = Color(0xFF1565C0);

class SudokuCell extends StatelessWidget {
  final int value;
  final bool isInitial;
  final bool isSelected;
  final bool isConflict;
  final VoidCallback? onTap;
  final Color cellBackgroundColor;
    final bool isPaused;


  const SudokuCell({
    super.key,
    required this.value,
    required this.isInitial,
    required this.isSelected,
    required this.isConflict,
    required this.onTap,
    required this.cellBackgroundColor,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color:
                isConflict ? colorScheme.errorContainer : cellBackgroundColor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
                width: 2.0,
                color: isSelected ? _initialValueColor : Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha(38),
                blurRadius: 2,
                offset: const Offset(1, 1),
              )
            ],
          ),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: isPaused ? 4.0 : 0.0,
              sigmaY: isPaused ? 4.0 : 0.0,
              tileMode: TileMode.decal,
            ),
            child: Center(
              child: Text(
                value == 0 ? '' : value.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isInitial ? _initialValueColor : colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
