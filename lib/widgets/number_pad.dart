import 'package:flutter/material.dart';
import 'package:flutter_shared_components/flutter_shared_components.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberTap;
  final VoidCallback onEraseTap;
  final int Function(int) getOccurrences;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onEraseTap,
    required this.getOccurrences,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(10, (index) {
          final Widget button;
          const double spacing = 8.0;
          if (index == 9) {
            button = _buildEraseButton(context);
          } else {
            button = _buildNumberButton(context, index + 1);
          }

          return Expanded(
            child: Padding(
              // Add spacing between buttons, but not at the outer edges of the row.
              padding: EdgeInsets.only(
                  left: index == 0 ? 0 : spacing / 2,
                  right: index == 9 ? 0 : spacing / 2),
              child: button,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNumberButton(BuildContext context, int number) {
    final colorScheme = Theme.of(context).colorScheme;
    final count = getOccurrences(number);
    final isCompleted = count >= 9;

    return BadgedActionButton(
      onPressed: () => onNumberTap(number),
      isVisible: !isCompleted,
      badgeText: (9 - count).toString(),
      badgeColor: Colors.green.shade700,
      child: FittedBox(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildEraseButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return StyledActionButton(
      onPressed: onEraseTap,
      padding: EdgeInsets.zero,
      child: Icon(Icons.clear, size: 20, color: colorScheme.onSurface),
    );
  }
}
