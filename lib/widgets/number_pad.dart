import 'package:flutter/material.dart';
import 'package:flutter_shared_components/flutter_shared_components.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberTap;
  final VoidCallback onEraseTap;
  final VoidCallback onHintTap;
  final int remainingHints;
  final int Function(int) getOccurrences;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onEraseTap,
    required this.onHintTap,
    required this.remainingHints,
    required this.getOccurrences,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 11,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: 11,
        itemBuilder: (context, index) {
          if (index == 0) { // Hint button
            return _buildHintButton(context);
          } else if (index == 10) { // Erase button
            return _buildEraseButton(context);
          }
          return _buildNumberButton(context, index); // Number buttons
        },
      ),
    );
  }

  Widget _buildHintButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BadgedActionButton(
      onPressed: onHintTap,
      isVisible: remainingHints > 0,
      badgeText: remainingHints.toString(),
      badgeColor: Colors.blue.shade700,
      child: Icon(
        Icons.lightbulb_outline,
        size: 24,
        color: colorScheme.onSurface,
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
            fontSize: 24,
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
      child: Icon(Icons.clear, size: 24, color: colorScheme.onSurface),
    );
  }
}
