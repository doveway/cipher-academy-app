import 'package:flutter/material.dart';
import '../../models/puzzle.dart';
import '../../theme/app_theme.dart';

class VisualLogicPuzzleWidget extends StatelessWidget {
  final Puzzle puzzle;

  const VisualLogicPuzzleWidget({
    super.key,
    required this.puzzle,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleData = puzzle.puzzleData;
    final symbols = puzzleData['symbols'] as List<dynamic>? ?? [];
    final rules = puzzleData['rules'] as List<dynamic>? ?? [];
    final question = puzzleData['question'] as String? ?? 'Which symbol is different?';

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
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: List.generate(symbols.length, (index) {
                return _buildSymbolBox(
                  context,
                  symbols[index].toString(),
                  index,
                );
              }),
            ),
            if (rules.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkNavy,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.forestGreen.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.rule,
                          color: AppTheme.lightForestGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Properties:',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.lightForestGreen,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      rules.length.clamp(0, symbols.length),
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              symbols[index].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppTheme.brass,
                                  ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppTheme.darkParchment,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                rules[index].toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
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

  Widget _buildSymbolBox(BuildContext context, String symbol, int index) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.darkNavy,
        border: Border.all(
          color: AppTheme.brass,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          symbol,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.parchment,
              ),
        ),
      ),
    );
  }
}
