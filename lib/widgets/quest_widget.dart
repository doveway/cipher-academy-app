import 'package:flutter/material.dart';
import '../models/quest.dart';
import '../theme/app_theme.dart';

class QuestWidget extends StatelessWidget {
  final Quest quest;

  const QuestWidget({
    super.key,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
    final progress = quest.currentProgress / quest.targetCount;
    final isCompleted = quest.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getQuestColor(quest.type).withOpacity(0.2),
            AppTheme.darkNavy.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppTheme.forestGreen
              : _getQuestColor(quest.type).withOpacity(0.5),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getQuestColor(quest.type).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getQuestIcon(quest.objective),
                  color: _getQuestColor(quest.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quest.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.forestGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(
                isCompleted ? AppTheme.forestGreen : _getQuestColor(quest.type),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${quest.currentProgress}/${quest.targetCount}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildRewards(quest),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewards(Quest quest) {
    return Row(
      children: [
        if (quest.tokenReward > 0) ...[
          Icon(
            Icons.monetization_on,
            color: AppTheme.brass,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '+${quest.tokenReward}',
            style: TextStyle(
              color: AppTheme.brass,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        if (quest.reputationReward > 0) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.star,
            color: AppTheme.forestGreen,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '+${quest.reputationReward}',
            style: TextStyle(
              color: AppTheme.forestGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        if (quest.freeAnswersReward != null && quest.freeAnswersReward! > 0) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.card_giftcard,
            color: Colors.orange,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '+${quest.freeAnswersReward}',
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Color _getQuestColor(QuestType type) {
    switch (type) {
      case QuestType.daily:
        return AppTheme.brass;
      case QuestType.weekly:
        return AppTheme.burgundy;
      case QuestType.bonus:
        return Colors.purple;
    }
  }

  IconData _getQuestIcon(QuestObjective objective) {
    switch (objective) {
      case QuestObjective.solvePuzzles:
        return Icons.check_circle_outline;
      case QuestObjective.perfectSolve:
        return Icons.stars;
      case QuestObjective.playMultiplayer:
        return Icons.group;
      case QuestObjective.winMultiplayer:
        return Icons.emoji_events;
      case QuestObjective.maintainStreak:
        return Icons.local_fire_department;
      case QuestObjective.earnTokens:
        return Icons.monetization_on;
      case QuestObjective.solveWithoutHints:
        return Icons.psychology;
      case QuestObjective.skillMastery:
        return Icons.trending_up;
    }
  }
}

/// Daily Quests Panel
class DailyQuestsPanel extends StatelessWidget {
  final List<Quest> quests;

  const DailyQuestsPanel({
    super.key,
    required this.quests,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = quests.where((q) => q.isCompleted).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.brass.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assignment,
                    color: AppTheme.brass,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Daily Quests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: completedCount == quests.length
                      ? AppTheme.forestGreen
                      : AppTheme.brass.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount/${quests.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...quests.map((quest) => QuestWidget(quest: quest)),
          if (completedCount == quests.length) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.forestGreen.withOpacity(0.3),
                    AppTheme.brass.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: AppTheme.brass,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'All quests completed! New quests tomorrow.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Quest completion notification
void showQuestCompletionNotification(BuildContext context, Quest quest) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppTheme.darkNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.forestGreen),
      ),
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.forestGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Quest Completed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  quest.title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (quest.tokenReward > 0)
            Row(
              children: [
                Icon(Icons.monetization_on, color: AppTheme.brass, size: 16),
                const SizedBox(width: 4),
                Text(
                  '+${quest.tokenReward}',
                  style: TextStyle(
                    color: AppTheme.brass,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
