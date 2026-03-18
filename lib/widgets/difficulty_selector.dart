import 'package:flutter/material.dart';

import '../games/multiplication_game.dart';

/// Reusable widget για επιλογή δυσκολίας στην προπαίδεια.
class DifficultySelector extends StatelessWidget {
  const DifficultySelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Difficulty selected;
  final ValueChanged<Difficulty?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Εύκολο (1-5)'),
              selected: selected == Difficulty.easy,
              onSelected: (_) => onChanged(Difficulty.easy),
            ),
            ChoiceChip(
              label: const Text('Μεσαίο (1-10)'),
              selected: selected == Difficulty.medium,
              onSelected: (_) => onChanged(Difficulty.medium),
            ),
            ChoiceChip(
              // Δύσκολο επίπεδο με απαιτητικά ζευγάρια 6..9 x 6..9.
              label: const Text('Δύσκολο (6-9)'),
              selected: selected == Difficulty.hard,
              onSelected: (_) => onChanged(Difficulty.hard),
            ),
          ],
        ),
      ),
    );
  }
}
