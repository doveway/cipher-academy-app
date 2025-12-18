import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chapter.dart';
import '../services/puzzle_service.dart';
import '../services/game_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/puzzle_list_item.dart';

class ChapterScreen extends StatelessWidget {
  final Chapter chapter;

  const ChapterScreen({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleService = context.read<PuzzleService>();
    final puzzles = puzzleService.getPuzzlesByChapter(chapter.number);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(chapter.title),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.darkNavy,
                      AppTheme.burgundy.withOpacity(0.7),
                      AppTheme.forestGreen.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        chapter.subtitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.brass,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_stories_outlined,
                                color: AppTheme.brass,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'The Story',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            chapter.storyline,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Puzzles',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Chip(
                        label: Text('${puzzles.length} Challenges'),
                        avatar: const Icon(
                          Icons.psychology,
                          size: 16,
                          color: AppTheme.brass,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Consumer<GameStateProvider>(
            builder: (context, gameState, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final puzzle = puzzles[index];
                    final isUnlocked = index == 0 ||
                        gameState.isPuzzleCompleted(puzzles[index - 1].id);
                    final isCompleted = gameState.isPuzzleCompleted(puzzle.id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: PuzzleListItem(
                        puzzle: puzzle,
                        isUnlocked: isUnlocked,
                        isCompleted: isCompleted,
                      ),
                    );
                  },
                  childCount: puzzles.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}
