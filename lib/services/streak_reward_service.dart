import 'dart:math';
import '../models/user_profile.dart';

class StreakReward {
  final int tokens;
  final int freeAnswers;
  final int reputationBonus;
  final String message;
  final bool isSpecial;

  const StreakReward({
    required this.tokens,
    this.freeAnswers = 0,
    this.reputationBonus = 0,
    required this.message,
    this.isSpecial = false,
  });
}

class StreakRewardService {
  static const int _freeAnswerStreakRequirement = 5;
  static const int _freeAnswerDuration = 2; // days

  /// Calculate reward for current streak
  /// Uses user ID + date as seed for consistent but unpredictable rewards
  static StreakReward calculateStreakReward(
    int streakDay,
    String userId,
    DateTime date,
  ) {
    // Use user ID and date for pseudo-random but consistent rewards
    final seed = _generateSeed(userId, date);
    final random = Random(seed);

    // Day 1-2: Minimal rewards
    if (streakDay <= 2) {
      return _smallReward(streakDay, random);
    }

    // Day 3-4: Partial streak rewards (unpredictable)
    if (streakDay <= 4) {
      return _partialStreakReward(streakDay, random);
    }

    // Day 5: BIG reward - Free answers unlock!
    if (streakDay == 5) {
      return const StreakReward(
        tokens: 100,
        freeAnswers: 999, // Unlimited for 2 days
        reputationBonus: 50,
        message: '🔥 5-Day Streak! Unlocked FREE answers for 2 days!',
        isSpecial: true,
      );
    }

    // Day 6-9: Good rewards (streak maintenance)
    if (streakDay <= 9) {
      return _maintenanceReward(streakDay, random);
    }

    // Day 10+: Legendary rewards
    return _legendaryReward(streakDay, random);
  }

  static StreakReward _smallReward(int day, Random random) {
    final tokens = 10 + random.nextInt(15); // 10-24 tokens
    return StreakReward(
      tokens: tokens,
      message: '✨ Day $day! Keep it up! +$tokens tokens',
      isSpecial: false,
    );
  }

  static StreakReward _partialStreakReward(int day, Random random) {
    // Unpredictable rewards - sometimes big, sometimes small
    final rewardTier = random.nextInt(10);

    if (rewardTier < 3) {
      // 30% chance: Small reward
      final tokens = 15 + random.nextInt(10);
      return StreakReward(
        tokens: tokens,
        message: '⭐ Day $day streak! +$tokens tokens',
      );
    } else if (rewardTier < 7) {
      // 40% chance: Medium reward
      final tokens = 25 + random.nextInt(20);
      final rep = 5 + random.nextInt(10);
      return StreakReward(
        tokens: tokens,
        reputationBonus: rep,
        message: '🌟 Day $day! Great progress! +$tokens tokens, +$rep reputation',
      );
    } else {
      // 30% chance: Big surprise reward
      final tokens = 50 + random.nextInt(30);
      final rep = 15 + random.nextInt(15);
      final freeAnswers = random.nextInt(2); // 0-1 free answer
      return StreakReward(
        tokens: tokens,
        freeAnswers: freeAnswers,
        reputationBonus: rep,
        message: freeAnswers > 0
            ? '💎 Day $day! Lucky day! +$tokens tokens, +$rep reputation, +$freeAnswers free answer!'
            : '💫 Day $day! Excellent! +$tokens tokens, +$rep reputation',
        isSpecial: freeAnswers > 0,
      );
    }
  }

  static StreakReward _maintenanceReward(int day, Random random) {
    final tokens = 30 + random.nextInt(30); // 30-59 tokens
    final rep = 10 + random.nextInt(15);

    // 20% chance for bonus free answer
    final bonusFreeAnswer = random.nextInt(5) == 0 ? 1 : 0;

    return StreakReward(
      tokens: tokens,
      freeAnswers: bonusFreeAnswer,
      reputationBonus: rep,
      message: bonusFreeAnswer > 0
          ? '🎁 Day $day streak! Bonus reward! +$tokens tokens, +$rep reputation, +1 free answer'
          : '🔥 Day $day streak! Strong! +$tokens tokens, +$rep reputation',
      isSpecial: bonusFreeAnswer > 0,
    );
  }

  static StreakReward _legendaryReward(int day, Random random) {
    final baseTokens = 60 + (day - 10) * 10; // Scales with streak
    final variance = random.nextInt(50);
    final tokens = baseTokens + variance;

    final rep = 25 + random.nextInt(30);

    // Higher chance of free answers at high streaks
    final freeAnswers = random.nextInt(3); // 0-2 free answers

    // Every 7 days: Super special reward
    final isMilestone = day % 7 == 0;

    if (isMilestone) {
      return StreakReward(
        tokens: tokens * 2,
        freeAnswers: freeAnswers + 2,
        reputationBonus: rep * 2,
        message: '👑 Day $day MILESTONE! LEGENDARY! +${tokens * 2} tokens, +${rep * 2} reputation, +${freeAnswers + 2} free answers!',
        isSpecial: true,
      );
    }

    return StreakReward(
      tokens: tokens,
      freeAnswers: freeAnswers,
      reputationBonus: rep,
      message: freeAnswers > 0
          ? '⚡ Day $day! Unstoppable! +$tokens tokens, +$rep reputation, +$freeAnswers free answers'
          : '🌠 Day $day streak! Amazing! +$tokens tokens, +$rep reputation',
      isSpecial: freeAnswers > 0,
    );
  }

  /// Check if user played today
  static bool hasPlayedToday(UserProfile profile) {
    final today = DateTime.now();
    final lastPlayed = profile.lastPlayedDate;

    return lastPlayed.year == today.year &&
        lastPlayed.month == today.month &&
        lastPlayed.day == today.day;
  }

  /// Update streak when user plays
  static Map<String, dynamic> updateStreak(UserProfile profile) {
    final now = DateTime.now();
    final lastPlayed = profile.lastPlayedDate;

    // Already played today
    if (hasPlayedToday(profile)) {
      return {
        'newStreak': profile.currentStreak,
        'reward': null,
        'streakBroken': false,
      };
    }

    final daysSinceLastPlay = now.difference(lastPlayed).inDays;

    // Streak continues (played yesterday or today)
    if (daysSinceLastPlay <= 1) {
      final newStreak = profile.currentStreak + 1;
      final reward = calculateStreakReward(newStreak, profile.userId, now);

      return {
        'newStreak': newStreak,
        'reward': reward,
        'streakBroken': false,
      };
    }

    // Streak broken (missed a day)
    return {
      'newStreak': 1, // Start fresh
      'reward': calculateStreakReward(1, profile.userId, now),
      'streakBroken': true,
    };
  }

  /// Check if free answers are still valid
  static bool hasFreeAnswers(UserProfile profile) {
    if (profile.freeAnswersAvailable <= 0) return false;

    if (profile.freeAnswersExpiryDate == null) return true;

    return DateTime.now().isBefore(profile.freeAnswersExpiryDate!);
  }

  /// Calculate expiry date for free answers (2 days from now)
  static DateTime getFreeAnswerExpiryDate() {
    return DateTime.now().add(const Duration(days: _freeAnswerDuration));
  }

  static int _generateSeed(String userId, DateTime date) {
    // Combine user ID hash with date for consistent but unique rewards
    final userHash = userId.hashCode;
    final dateHash = date.year * 10000 + date.month * 100 + date.day;
    return userHash + dateHash;
  }

  /// Get encouragement message for broken streak
  static String getStreakBrokenMessage(int oldStreak) {
    if (oldStreak <= 2) {
      return 'Don\'t worry! Every master starts somewhere. Let\'s build that streak!';
    } else if (oldStreak <= 5) {
      return 'Streak reset! You were doing great. Let\'s get back on track!';
    } else if (oldStreak <= 10) {
      return 'Oops! You had a $oldStreak day streak. Let\'s rebuild even stronger!';
    } else {
      return 'Wow, you had an amazing $oldStreak day streak! Ready to beat that record?';
    }
  }
}
