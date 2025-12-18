import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chapter.dart';
import '../services/game_state_provider.dart';
import '../services/puzzle_service.dart';
import '../theme/app_theme.dart';
import '../screens/chapter_screen.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapter;

  const ChapterCard({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameStateProvider, PuzzleService>(
      builder: (context, gameState, puzzleService, child) {
        final puzzles = puzzleService.getPuzzlesByChapter(chapter.number);
        final completedCount = puzzles
            .where((p) => gameState.isPuzzleCompleted(p.id))
            .length;

        // Check if previous chapter is completed (for sequential unlocking)
        bool isPreviousChapterCompleted = true;
        if (chapter.number > 1) {
          final previousChapterPuzzles = puzzleService.getPuzzlesByChapter(chapter.number - 1);
          isPreviousChapterCompleted = previousChapterPuzzles.isNotEmpty &&
              previousChapterPuzzles.every((p) => gameState.isPuzzleCompleted(p.id));
        }

        // Chapter is locked if it's premium content OR if previous chapter isn't completed
        final isLocked = (!chapter.isFree && !gameState.isPremium) || !isPreviousChapterCompleted;

        return Card(
          elevation: 4,
          child: InkWell(
            onTap: isLocked
                ? () => _showLockedDialog(context, isPreviousChapterCompleted)
                : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChapterScreen(chapter: chapter),
                      ),
                    ),
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isLocked
                                  ? AppTheme.lightCharcoal
                                  : AppTheme.burgundy,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isLocked ? Icons.lock : Icons.auto_stories,
                              color: AppTheme.parchment,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Chapter ${chapter.number}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppTheme.brass,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  chapter.title,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        chapter.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.psychology,
                                size: 16,
                                color: AppTheme.darkParchment,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${puzzles.length} Puzzles',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          if (!isLocked)
                            Row(
                              children: [
                                Text(
                                  '$completedCount/${puzzles.length}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.brass,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  child: LinearProgressIndicator(
                                    value: puzzles.isEmpty
                                        ? 0
                                        : completedCount / puzzles.length,
                                    backgroundColor: AppTheme.navy,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppTheme.brass),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (chapter.isFree)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          color: AppTheme.parchment,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLockedDialog(BuildContext context, bool isPreviousChapterCompleted) {
    if (!isPreviousChapterCompleted) {
      // Show progression dialog if previous chapter not completed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.lock_outline, color: AppTheme.burgundy),
              SizedBox(width: 8),
              Text('Chapter Locked'),
            ],
          ),
          content: Text(
            'Complete all puzzles in Chapter ${chapter.number - 1} to unlock this chapter.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        ),
      );
    } else {
      // Show premium dialog if it's premium content
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.lock, color: AppTheme.brass),
              SizedBox(width: 8),
              Text('Premium Content'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This chapter is part of the premium content. Upgrade to unlock:',
              ),
              SizedBox(height: 16),
              _PremiumFeatureItem(
                icon: Icons.all_inclusive,
                text: 'All chapters and puzzles',
              ),
              _PremiumFeatureItem(
                icon: Icons.lightbulb,
                text: '50 hints per day',
              ),
              _PremiumFeatureItem(
                icon: Icons.ad_units,
                text: 'Ad-free experience',
              ),
              _PremiumFeatureItem(
                icon: Icons.workspace_premium,
                text: 'Exclusive bonus content',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to premium purchase
                Navigator.of(context).pop();
              },
              child: const Text('Upgrade Now'),
            ),
          ],
        ),
      );
    }
  }
}

class _PremiumFeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PremiumFeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.brass, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
