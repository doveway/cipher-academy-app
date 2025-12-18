import 'package:flutter/material.dart';
import '../services/streak_reward_service.dart';
import '../theme/app_theme.dart';

class StreakNotificationDialog extends StatelessWidget {
  final StreakReward reward;
  final int currentStreak;

  const StreakNotificationDialog({
    super.key,
    required this.reward,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.burgundy.withOpacity(0.95),
              AppTheme.darkNavy.withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: reward.isSpecial ? Colors.amber : AppTheme.brass,
            width: reward.isSpecial ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (reward.isSpecial ? Colors.amber : AppTheme.brass).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flame icon with animation potential
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: currentStreak >= 5
                        ? [Colors.orange, Colors.red]
                        : [AppTheme.brass.withOpacity(0.3), AppTheme.burgundy.withOpacity(0.3)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (currentStreak >= 5 ? Colors.orange : AppTheme.brass).withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_fire_department,
                  size: reward.isSpecial ? 80 : 60,
                  color: currentStreak >= 5 ? Colors.white : AppTheme.brass,
                ),
              ),
              const SizedBox(height: 20),

              // Streak count
              Text(
                '$currentStreak Day Streak!',
                style: TextStyle(
                  color: reward.isSpecial ? Colors.amber : Colors.white,
                  fontSize: reward.isSpecial ? 32 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                reward.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Rewards display
              _buildRewardsDisplay(reward),

              const SizedBox(height: 24),

              // Close button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: reward.isSpecial ? Colors.amber : AppTheme.brass,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Awesome!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsDisplay(StreakReward reward) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reward.isSpecial ? Colors.amber.withOpacity(0.5) : AppTheme.brass.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          if (reward.isSpecial)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '⭐ SPECIAL REWARD ⭐',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Tokens
          if (reward.tokens > 0)
            _buildRewardRow(
              Icons.monetization_on,
              '+${reward.tokens} Tokens',
              AppTheme.brass,
            ),

          // Free Answers
          if (reward.freeAnswers > 0) ...[
            if (reward.tokens > 0) const SizedBox(height: 12),
            _buildRewardRow(
              Icons.card_giftcard,
              reward.freeAnswers >= 999
                  ? 'Free Answers for 2 Days!'
                  : '+${reward.freeAnswers} Free Answer${reward.freeAnswers > 1 ? 's' : ''}',
              Colors.orange,
              isSpecial: reward.freeAnswers >= 999,
            ),
          ],

          // Reputation
          if (reward.reputationBonus > 0) ...[
            if (reward.tokens > 0 || reward.freeAnswers > 0) const SizedBox(height: 12),
            _buildRewardRow(
              Icons.star,
              '+${reward.reputationBonus} Reputation',
              AppTheme.forestGreen,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardRow(IconData icon, String text, Color color, {bool isSpecial = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: isSpecial ? 28 : 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSpecial ? 18 : 16,
            fontWeight: isSpecial ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Streak widget for home screen
class StreakWidget extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final VoidCallback? onTap;

  const StreakWidget({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOnFire = currentStreak >= 5;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isOnFire
                ? [Colors.orange.withOpacity(0.3), Colors.red.withOpacity(0.3)]
                : [AppTheme.brass.withOpacity(0.2), AppTheme.burgundy.withOpacity(0.2)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOnFire ? Colors.orange : AppTheme.brass.withOpacity(0.5),
            width: isOnFire ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isOnFire ? Colors.orange : AppTheme.brass).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_fire_department,
                color: isOnFire ? Colors.orange : AppTheme.brass,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$currentStreak Day Streak',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isOnFire) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ON FIRE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Best: $longestStreak days',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  if (currentStreak >= 5) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.orange,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Free answers unlocked!',
                          style: TextStyle(
                            color: Colors.orange.shade300,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ] else if (currentStreak > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${5 - currentStreak} more day${5 - currentStreak > 1 ? 's' : ''} to unlock free answers',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}

/// Show streak notification
void showStreakNotification(BuildContext context, StreakReward reward, int currentStreak) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StreakNotificationDialog(
      reward: reward,
      currentStreak: currentStreak,
    ),
  );
}
