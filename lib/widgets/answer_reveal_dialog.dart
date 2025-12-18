import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../models/user_profile.dart';
import '../services/token_service.dart';
import '../theme/app_theme.dart';

class AnswerRevealDialog extends StatelessWidget {
  final Puzzle puzzle;
  final UserProfile profile;
  final VoidCallback onReveal;

  const AnswerRevealDialog({
    super.key,
    required this.puzzle,
    required this.profile,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    final cost = TokenCost.getAnswerRevealCost(puzzle.difficulty);
    final canAfford = TokenCost.canAffordAnswerReveal(profile, puzzle.difficulty);
    final hasFreeAnswer = profile.hasFreeAnswers && profile.freeAnswersAvailable > 0;

    return Dialog(
      backgroundColor: AppTheme.darkNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppTheme.brass.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.brass.withOpacity(0.3),
                    AppTheme.burgundy.withOpacity(0.3),
                  ],
                ),
                border: Border.all(color: AppTheme.brass, width: 2),
              ),
              child: Icon(
                hasFreeAnswer ? Icons.card_giftcard : Icons.lightbulb_outline,
                size: 48,
                color: AppTheme.brass,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              hasFreeAnswer ? 'Free Answer Available!' : 'Reveal Answer?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              hasFreeAnswer
                  ? 'You earned a free answer from your ${profile.currentStreak}-day streak!'
                  : 'This will reveal the complete solution to this puzzle.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Cost display
            if (hasFreeAnswer)
              _buildFreeAnswerInfo(profile)
            else
              _buildCostInfo(cost, profile.tokens, canAfford),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canAfford
                        ? () {
                            Navigator.pop(context);
                            onReveal();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasFreeAnswer
                          ? AppTheme.forestGreen
                          : AppTheme.brass,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      hasFreeAnswer ? 'Use Free Answer' : 'Reveal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Insufficient tokens message
            if (!canAfford && !hasFreeAnswer) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.burgundy.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.burgundy.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.burgundy,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        TokenCost.getInsufficientTokensMessage(cost, profile.tokens),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
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
      ),
    );
  }

  Widget _buildCostInfo(int cost, int currentTokens, bool canAfford) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canAfford
              ? AppTheme.brass.withOpacity(0.5)
              : AppTheme.burgundy.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cost:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: AppTheme.brass,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    cost.toString(),
                    style: TextStyle(
                      color: AppTheme.brass,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Tokens:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                currentTokens.toString(),
                style: TextStyle(
                  color: canAfford ? AppTheme.forestGreen : AppTheme.burgundy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (canAfford) ...[
            const SizedBox(height: 8),
            Divider(color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'After Purchase:',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                Text(
                  (currentTokens - cost).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFreeAnswerInfo(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.forestGreen.withOpacity(0.3),
            AppTheme.brass.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.forestGreen),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '${profile.currentStreak}-Day Streak Reward',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Free Answers Remaining:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  profile.freeAnswersAvailable.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (profile.freeAnswersExpiryDate != null) ...[
            const SizedBox(height: 8),
            Text(
              'Expires: ${_formatExpiryDate(profile.freeAnswersExpiryDate!)}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatExpiryDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      return 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else {
      return 'soon';
    }
  }
}

/// Widget button to show the answer reveal dialog
class AnswerRevealButton extends StatelessWidget {
  final Puzzle puzzle;
  final UserProfile profile;
  final VoidCallback onReveal;

  const AnswerRevealButton({
    super.key,
    required this.puzzle,
    required this.profile,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    final hasFreeAnswer = profile.hasFreeAnswers && profile.freeAnswersAvailable > 0;

    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AnswerRevealDialog(
            puzzle: puzzle,
            profile: profile,
            onReveal: onReveal,
          ),
        );
      },
      icon: Icon(
        hasFreeAnswer ? Icons.card_giftcard : Icons.lightbulb_outline,
        size: 20,
      ),
      label: Text(
        hasFreeAnswer ? 'Free Answer!' : 'Reveal Answer',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: hasFreeAnswer ? AppTheme.forestGreen : AppTheme.brass,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
