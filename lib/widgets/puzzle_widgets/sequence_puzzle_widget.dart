import 'package:flutter/material.dart';
import '../../models/puzzle.dart';
import '../../theme/app_theme.dart';

class SequencePuzzleWidget extends StatelessWidget {
  final Puzzle puzzle;

  const SequencePuzzleWidget({
    super.key,
    required this.puzzle,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleData = puzzle.puzzleData;

    if (puzzle.type == PuzzleType.sequenceCompletion) {
      return _buildSequenceWidget(context, puzzleData);
    } else if (puzzle.type == PuzzleType.basicCryptography) {
      return _buildCryptographyWidget(context, puzzleData);
    }

    return _buildGenericWidget(context);
  }

  Widget _buildSequenceWidget(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final sequence = data['sequence'] as List<dynamic>;

    return Card(
      elevation: 2,
      color: AppTheme.navy,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Find the missing number:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.brass,
                  ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: sequence.map((item) {
                final isQuestion = item.toString() == '?';
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isQuestion
                        ? AppTheme.burgundy.withOpacity(0.3)
                        : AppTheme.darkNavy,
                    border: Border.all(
                      color: isQuestion ? AppTheme.brass : AppTheme.forestGreen,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isQuestion
                        ? const Icon(
                            Icons.help_outline,
                            color: AppTheme.brass,
                            size: 32,
                          )
                        : Text(
                            item.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.parchment,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (data.containsKey('type'))
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.lightForestGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Type: ${data['type']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightForestGreen,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptographyWidget(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final encrypted = data['encrypted'] as String? ?? '';

    return Card(
      elevation: 2,
      color: AppTheme.navy,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Decrypt the message:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.brass,
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkNavy,
                border: Border.all(color: AppTheme.brass, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock,
                        color: AppTheme.brass,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Encrypted Text',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.brass,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    encrypted,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.parchment,
                          fontFamily: 'Courier',
                          letterSpacing: 4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (data.containsKey('hint')) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.lightForestGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['hint'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightForestGreen,
                            ),
                        textAlign: TextAlign.center,
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

  Widget _buildGenericWidget(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppTheme.navy,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.psychology,
              color: AppTheme.brass,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Solve this puzzle!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.brass,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use the clues and your logical reasoning to find the answer.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
