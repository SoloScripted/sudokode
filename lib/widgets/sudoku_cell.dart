import 'dart:ui';
import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  final int value;
  final bool isInitial;
  final bool isSelected;
  final bool isConflict;
  final VoidCallback? onTap;
  final Color cellBackgroundColor;
  final bool isPaused;

  static const _initialValueColor = Color(0xFF1565C0);
  static const _animationDuration = Duration(milliseconds: 150);

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

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: isInitial ? _initialValueColor : colorScheme.onSurface,
    );

    final imageFilter = ImageFilter.blur(
      sigmaX: isPaused ? 4.0 : 0.0,
      sigmaY: isPaused ? 4.0 : 0.0,
      tileMode: TileMode.decal,
    );

    return ImageFiltered(
      imageFilter: imageFilter,
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: textStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor =
        isConflict ? colorScheme.errorContainer : cellBackgroundColor;
    final borderColor = isSelected ? _initialValueColor : Colors.transparent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: _animationDuration,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(width: 2.0, color: borderColor),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha(38),
                blurRadius: 2,
                offset: const Offset(1, 1),
              )
            ],
          ),
          child: _buildContent(context),
        ),
      ),
    );
  }
}
