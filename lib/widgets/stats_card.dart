import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state_provider.dart';
import '../theme/app_theme.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        if (gameState.isLoading || gameState.userProgress == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final progress = gameState.userProgress!;
        final completedCount = progress.puzzleProgress.values
            .where((p) => p.isCompleted)
            .length;

        return Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Progress',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (progress.isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.brass, AppTheme.lightBrass],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppTheme.darkNavy,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'PREMIUM',
                              style: TextStyle(
                                color: AppTheme.darkNavy,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      icon: Icons.emoji_events,
                      label: 'Level',
                      value: progress.currentLevel.toString(),
                      color: AppTheme.brass,
                    ),
                    _buildStatItem(
                      context,
                      icon: Icons.check_circle,
                      label: 'Solved',
                      value: completedCount.toString(),
                      color: AppTheme.successGreen,
                    ),
                    _buildStatItem(
                      context,
                      icon: Icons.psychology,
                      label: 'Insight',
                      value: progress.totalInsightPoints.toString(),
                      color: AppTheme.lightBurgundy,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      progress.canUseHint()
                          ? Icons.lightbulb
                          : Icons.lightbulb_outline,
                      color: AppTheme.brass,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      progress.isPremium
                          ? 'Unlimited hints available'
                          : progress.canUseHint()
                              ? 'Daily free hint available'
                              : 'Next free hint tomorrow',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
