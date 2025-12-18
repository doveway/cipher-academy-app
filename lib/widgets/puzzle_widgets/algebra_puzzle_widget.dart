import 'package:flutter/material.dart';
import '../../models/puzzle.dart';
import '../../theme/app_theme.dart';

class AlgebraPuzzleWidget extends StatelessWidget {
  final Puzzle puzzle;

  const AlgebraPuzzleWidget({
    super.key,
    required this.puzzle,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleData = puzzle.puzzleData;
    final equation = puzzleData['equation'] as String? ?? '';
    final variable = puzzleData['variable'] as String? ?? 'x';
    final context_text = puzzleData['context'] as String?;

    return Card(
      elevation: 2,
      color: AppTheme.navy,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Solve for $variable:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.brass,
                  ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: AppTheme.darkNavy,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.brass,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    equation,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppTheme.parchment,
                          fontFamily: 'monospace',
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        variable,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppTheme.brass,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '= ?',
                        style: TextStyle(
                          fontSize: 32,
                          color: AppTheme.burgundy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (context_text != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.lightForestGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context_text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightForestGreen,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
