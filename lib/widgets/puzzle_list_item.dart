import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../theme/app_theme.dart';
import '../screens/puzzle_screen.dart';

class PuzzleListItem extends StatelessWidget {
  final Puzzle puzzle;
  final bool isUnlocked;
  final bool isCompleted;

  const PuzzleListItem({
    super.key,
    required this.puzzle,
    required this.isUnlocked,
    required this.isCompleted,
  });

  IconData _getDifficultyIcon() {
    switch (puzzle.difficulty) {
      case Difficulty.beginner:
        return Icons.looks_one;
      case Difficulty.intermediate:
        return Icons.looks_two;
      case Difficulty.advanced:
        return Icons.looks_3;
      case Difficulty.expert:
        return Icons.looks_4;
      case Difficulty.master:
        return Icons.looks_5;
    }
  }

  Color _getDifficultyColor() {
    switch (puzzle.difficulty) {
      case Difficulty.beginner:
        return AppTheme.successGreen;
      case Difficulty.intermediate:
        return AppTheme.forestGreen;
      case Difficulty.advanced:
        return AppTheme.brass;
      case Difficulty.expert:
        return AppTheme.burgundy;
      case Difficulty.master:
        return AppTheme.errorRed;
    }
  }

  String _getDifficultyLabel() {
    return puzzle.difficulty.name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isCompleted ? 2 : 4,
      color: isCompleted ? AppTheme.navy : AppTheme.darkNavy,
      child: InkWell(
        onTap: isUnlocked
            ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PuzzleScreen(puzzle: puzzle),
                  ),
                )
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? (isCompleted
                          ? AppTheme.successGreen
                          : AppTheme.burgundy)
                      : AppTheme.lightCharcoal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check_circle,
                          color: AppTheme.parchment,
                          size: 32,
                        )
                      : isUnlocked
                          ? Text(
                              '${puzzle.level}',
                              style: const TextStyle(
                                color: AppTheme.parchment,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(
                              Icons.lock,
                              color: AppTheme.darkParchment,
                              size: 28,
                            ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            puzzle.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: isUnlocked
                                      ? AppTheme.parchment
                                      : AppTheme.darkParchment,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor().withOpacity(0.2),
                            border: Border.all(
                              color: _getDifficultyColor(),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getDifficultyIcon(),
                                size: 14,
                                color: _getDifficultyColor(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getDifficultyLabel(),
                                style: TextStyle(
                                  color: _getDifficultyColor(),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      puzzle.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isUnlocked
                                ? AppTheme.darkParchment
                                : AppTheme.lightCharcoal,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star_outline,
                          size: 14,
                          color: isUnlocked
                              ? AppTheme.brass
                              : AppTheme.lightCharcoal,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${puzzle.baseInsightPoints} pts',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isUnlocked
                                        ? AppTheme.brass
                                        : AppTheme.lightCharcoal,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isUnlocked && !isCompleted)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.brass,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
