import '../models/user_profile.dart';
import '../models/puzzle.dart';
import '../models/quest.dart';
import 'streak_reward_service.dart';
import 'token_service.dart';
import 'rank_progression_service.dart';
import 'puzzle_randomizer.dart';

/// Central service for managing all engagement features
/// Handles streaks, quests, rewards, and profile updates
class EngagementService {
  /// Process user login and check for streak updates
  static UserProfile processLogin(UserProfile profile, DateTime loginDate) {
    final lastPlayed = profile.lastPlayedDate;
    final isSameDay = _isSameDay(lastPlayed, loginDate);

    // If already played today, no streak update needed
    if (isSameDay) {
      return profile;
    }

    final isConsecutiveDay = _isConsecutiveDay(lastPlayed, loginDate);

    // Update streak
    final newStreak = isConsecutiveDay ? profile.currentStreak + 1 : 1;
    final newLongestStreak = newStreak > profile.longestStreak ? newStreak : profile.longestStreak;

    // Calculate streak reward
    final streakReward = StreakRewardService.calculateStreakReward(
      newStreak,
      profile.userId,
      loginDate,
    );

    // Update play history (keep last 30 days)
    final updatedHistory = [
      ...profile.playHistory.where((d) => loginDate.difference(d).inDays < 30),
      loginDate,
    ];

    // Apply streak rewards
    var updatedProfile = profile.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      lastPlayedDate: loginDate,
      playHistory: updatedHistory,
      tokens: profile.tokens + streakReward.tokens,
      lifetimeTokensEarned: profile.lifetimeTokensEarned + streakReward.tokens,
      reputationScore: profile.reputationScore + streakReward.reputationBonus,
    );

    // Apply free answers if earned
    if (streakReward.freeAnswers > 0) {
      final expiryDate = loginDate.add(const Duration(days: 2));
      updatedProfile = updatedProfile.copyWith(
        freeAnswersAvailable: streakReward.freeAnswers,
        freeAnswersExpiryDate: expiryDate,
      );
    }

    // Reset daily quests if it's a new day
    updatedProfile = _resetDailyQuestsIfNeeded(updatedProfile, loginDate);

    // Daily login bonus
    final dailyBonus = TokenService.getDailyLoginBonus(profile.userId, loginDate);
    updatedProfile = updatedProfile.copyWith(
      tokens: updatedProfile.tokens + dailyBonus,
      lifetimeTokensEarned: updatedProfile.lifetimeTokensEarned + dailyBonus,
    );

    return updatedProfile;
  }

  /// Process puzzle completion and update all related systems
  static ProfileUpdateResult processPuzzleCompletion({
    required UserProfile profile,
    required Puzzle puzzle,
    required bool usedHints,
    required bool wasFast,
    required bool isPerfect,
  }) {
    var updatedProfile = profile;

    // Award tokens for puzzle completion
    updatedProfile = TokenService.awardPuzzleTokens(
      updatedProfile,
      puzzle.difficulty,
      usedHints: usedHints,
      wasFast: wasFast,
      isPerfect: isPerfect,
    );

    // Update skill levels
    final updatedSkills = RankProgressionService.updateSkillLevels(
      updatedProfile.skillLevels,
      puzzle,
      isPerfect,
      usedHints,
    );

    updatedProfile = updatedProfile.copyWith(
      skillLevels: updatedSkills,
      totalPuzzlesSolved: updatedProfile.totalPuzzlesSolved + 1,
      perfectSolves: isPerfect ? updatedProfile.perfectSolves + 1 : updatedProfile.perfectSolves,
    );

    // Check for rank promotion
    final rankPromotion = RankProgressionService.checkRankPromotion(
      profile,
      updatedProfile,
    );
    if (rankPromotion != null) {
      updatedProfile = updatedProfile.copyWith(
        rank: rankPromotion.newRank,
        tokens: updatedProfile.tokens + rankPromotion.tokenReward,
        lifetimeTokensEarned: updatedProfile.lifetimeTokensEarned + rankPromotion.tokenReward,
      );
    }

    // Check for title promotion
    final titlePromotion = RankProgressionService.checkTitlePromotion(
      profile,
      updatedProfile,
    );
    if (titlePromotion != null) {
      updatedProfile = updatedProfile.copyWith(
        title: titlePromotion.newTitle,
        reputationScore: updatedProfile.reputationScore + titlePromotion.reputationReward,
      );
    }

    // Update quests
    final questUpdates = _updateQuestsProgress(
      updatedProfile,
      isPerfect: isPerfect,
      usedHints: usedHints,
    );
    updatedProfile = questUpdates.profile;

    return ProfileUpdateResult(
      profile: updatedProfile,
      rankPromotion: rankPromotion,
      titlePromotion: titlePromotion,
      completedQuests: questUpdates.completedQuests,
    );
  }

  /// Get randomized puzzle for user
  static Puzzle getRandomizedPuzzle(Puzzle original, String userId, DateTime date) {
    return PuzzleRandomizer.randomizePuzzle(original, userId, date);
  }

  /// Generate daily quests for user
  static List<Quest> generateDailyQuests(DateTime date) {
    return QuestGenerator.generateDailyQuests(date);
  }

  /// Update quest progress after action
  static QuestUpdateResult _updateQuestsProgress(
    UserProfile profile, {
    bool isPerfect = false,
    bool usedHints = false,
    int tokensEarned = 0,
  }) {
    final updatedQuests = <String, bool>{...profile.dailyQuests};
    final completedQuests = <Quest>[];

    // This is a simplified version - in real implementation,
    // you'd track detailed quest progress

    return QuestUpdateResult(
      profile: profile.copyWith(dailyQuests: updatedQuests),
      completedQuests: completedQuests,
    );
  }

  /// Reset daily quests if it's a new day
  static UserProfile _resetDailyQuestsIfNeeded(UserProfile profile, DateTime currentDate) {
    if (profile.lastQuestResetDate == null) {
      return profile.copyWith(
        lastQuestResetDate: currentDate,
        dailyQuests: {},
      );
    }

    final lastReset = profile.lastQuestResetDate!;
    if (!_isSameDay(lastReset, currentDate)) {
      return profile.copyWith(
        lastQuestResetDate: currentDate,
        dailyQuests: {},
      );
    }

    return profile;
  }

  /// Check if free answers have expired
  static UserProfile checkFreeAnswersExpiry(UserProfile profile) {
    if (profile.freeAnswersExpiryDate == null) {
      return profile;
    }

    final now = DateTime.now();
    if (now.isAfter(profile.freeAnswersExpiryDate!)) {
      return profile.copyWith(
        freeAnswersAvailable: 0,
        freeAnswersExpiryDate: null,
      );
    }

    return profile;
  }

  /// Helper: Check if two dates are the same day
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Helper: Check if dates are consecutive days
  static bool _isConsecutiveDay(DateTime lastDate, DateTime currentDate) {
    final difference = currentDate.difference(lastDate).inDays;
    return difference == 1;
  }
}

/// Result of profile update with all promotions and achievements
class ProfileUpdateResult {
  final UserProfile profile;
  final RankPromotion? rankPromotion;
  final TitlePromotion? titlePromotion;
  final List<Quest> completedQuests;

  const ProfileUpdateResult({
    required this.profile,
    this.rankPromotion,
    this.titlePromotion,
    this.completedQuests = const [],
  });

  bool get hasRankPromotion => rankPromotion != null;
  bool get hasTitlePromotion => titlePromotion != null;
  bool get hasCompletedQuests => completedQuests.isNotEmpty;
  bool get hasAnyAchievement => hasRankPromotion || hasTitlePromotion || hasCompletedQuests;
}

/// Result of quest updates
class QuestUpdateResult {
  final UserProfile profile;
  final List<Quest> completedQuests;

  const QuestUpdateResult({
    required this.profile,
    required this.completedQuests,
  });
}
