import 'package:flutter/material.dart';
import '../../models/puzzle.dart';
import '../../theme/app_theme.dart';

class SetTheoryPuzzleWidget extends StatelessWidget {
  final Puzzle puzzle;

  const SetTheoryPuzzleWidget({
    super.key,
    required this.puzzle,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleData = puzzle.puzzleData;
    final setA = (puzzleData['setA'] as List<dynamic>?)?.cast<String>() ?? [];
    final setB = (puzzleData['setB'] as List<dynamic>?)?.cast<String>() ?? [];
    final question = puzzleData['question'] as String? ?? 'Find the intersection';

    return Card(
      elevation: 2,
      color: AppTheme.navy,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              question,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.brass,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSet(context, 'Set A', setA, AppTheme.burgundy),
                const Icon(Icons.compare_arrows, color: AppTheme.brass, size: 32),
                _buildSet(context, 'Set B', setB, AppTheme.forestGreen),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkNavy,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.brass.withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: AppTheme.brass,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Find common elements',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.brass,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter comma-separated values (e.g., 2,8)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkParchment,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSet(BuildContext context, String label, List<String> elements, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.darkNavy,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...elements.map(
              (element) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    element,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.parchment,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
