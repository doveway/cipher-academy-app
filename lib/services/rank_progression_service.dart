import '../models/user_profile.dart';
import '../models/puzzle.dart';

/// Skill-based rank progression system
/// Ranks are earned through performance, not just time played
class RankProgressionService {
  /// Calculate if user should rank up based on their performance
  static SkillRank calculateRank(UserProfile profile) {
    final score = _calculateRankScore(profile);

    if (score >= 10000) return SkillRank.grandmaster;
    if (score >= 7000) return SkillRank.master;
    if (score >= 5000) return SkillRank.diamond;
    if (score >= 3000) return SkillRank.platinum;
    if (score >= 1500) return SkillRank.gold;
    if (score >= 500) return SkillRank.silver;
    return SkillRank.bronze;
  }

  /// Calculate overall rank score based on multiple factors
  static int _calculateRankScore(UserProfile profile) {
    int score = 0;

    // Reputation is the primary factor (40% weight)
    score += (profile.reputationScore * 0.4).round();

    // Perfect solves show mastery (30% weight)
    score += profile.perfectSolves * 50;

    // Multiplayer performance matters (20% weight)
    if (profile.multiplayerGamesPlayed > 0) {
      final multiplayerScore = (profile.winRate * 1000).round();
      score += (multiplayerScore * 0.2).round();
    }

    // Total puzzles solved (10% weight, but capped to prevent grinding)
    final puzzleScore = (profile.totalPuzzlesSolved * 5).clamp(0, 500);
    score += (puzzleScore * 0.1).round();

    // Skill mastery bonus
    score += _calculateSkillMasteryBonus(profile.skillLevels);

    return score;
  }

  /// Calculate bonus from skill levels
  static int _calculateSkillMasteryBonus(Map<String, int> skillLevels) {
    if (skillLevels.isEmpty) return 0;

    int bonus = 0;

    // Reward well-rounded skills
    final averageSkill = skillLevels.values.reduce((a, b) => a + b) / skillLevels.length;
    bonus += (averageSkill * 5).round();

    // Extra bonus for maxed skills (level 100)
    final maxedSkills = skillLevels.values.where((level) => level >= 100).length;
    bonus += maxedSkills * 200;

    return bonus;
  }

  /// Calculate title based on achievements and reputation
  static UserTitle calculateTitle(UserProfile profile) {
    final reputation = profile.reputationScore;
    final perfectRate = profile.totalPuzzlesSolved > 0
        ? profile.perfectSolves / profile.totalPuzzlesSolved
        : 0.0;

    // Legend: Top tier, needs perfect mastery
    if (reputation >= 5000 && perfectRate >= 0.7 && profile.multiplayerWins >= 100) {
      return UserTitle.legend;
    }

    // Grandmaster: Expert level
    if (reputation >= 3000 && perfectRate >= 0.5) {
      return UserTitle.grandmaster;
    }

    // Mastermind: High skill
    if (reputation >= 1500 && perfectRate >= 0.3) {
      return UserTitle.mastermind;
    }

    // Strategist: Good tactical play
    if (reputation >= 750 && profile.totalPuzzlesSolved >= 30) {
      return UserTitle.strategist;
    }

    // Solver: Consistent player
    if (reputation >= 250 && profile.totalPuzzlesSolved >= 10) {
      return UserTitle.solver;
    }

    // Novice: Starting out
    return UserTitle.novice;
  }

  /// Update skill levels based on puzzle performance
  static Map<String, int> updateSkillLevels(
    Map<String, int> currentSkills,
    Puzzle puzzle,
    bool perfect,
    bool usedHints,
  ) {
    final updatedSkills = Map<String, int>.from(currentSkills);

    // Get skill category from puzzle
    final skillName = _getSkillName(puzzle.category, puzzle.type);

    // Current level
    final currentLevel = updatedSkills[skillName] ?? 0;

    // Calculate XP gain
    int xpGain = _calculateSkillXP(puzzle.difficulty, perfect, usedHints);

    // Diminishing returns at high levels
    if (currentLevel >= 80) {
      xpGain = (xpGain * 0.5).round();
    } else if (currentLevel >= 50) {
      xpGain = (xpGain * 0.75).round();
    }

    // Update skill level (capped at 100)
    updatedSkills[skillName] = (currentLevel + xpGain).clamp(0, 100);

    return updatedSkills;
  }

  /// Get skill name from puzzle category and type
  static String _getSkillName(PuzzleCategory category, PuzzleType type) {
    switch (category) {
      case PuzzleCategory.patternRecognition:
        return 'Pattern Recognition';
      case PuzzleCategory.strategicThinking:
        if (type == PuzzleType.setTheory) {
          return 'Set Theory';
        }
        return 'Strategic Thinking';
      case PuzzleCategory.advancedProblemSolving:
        if (type == PuzzleType.algebra) {
          return 'Algebra';
        }
        return 'Advanced Problem Solving';
      case PuzzleCategory.metaPuzzles:
        return 'Meta Puzzles';
    }
  }

  /// Calculate skill XP gain
  static int _calculateSkillXP(Difficulty difficulty, bool perfect, bool usedHints) {
    int baseXP = 0;

    switch (difficulty) {
      case Difficulty.beginner:
        baseXP = 5;
        break;
      case Difficulty.intermediate:
        baseXP = 10;
        break;
      case Difficulty.advanced:
        baseXP = 15;
        break;
      case Difficulty.expert:
        baseXP = 20;
        break;
      case Difficulty.master:
        baseXP = 25;
        break;
    }

    // Bonuses
    if (perfect) {
      baseXP = (baseXP * 2).round();
    } else if (!usedHints) {
      baseXP = (baseXP * 1.5).round();
    }

    return baseXP;
  }

  /// Check if user ranked up and return promotion details
  static RankPromotion? checkRankPromotion(
    UserProfile oldProfile,
    UserProfile newProfile,
  ) {
    final oldRank = oldProfile.rank;
    final newRank = calculateRank(newProfile);

    if (newRank.index > oldRank.index) {
      return RankPromotion(
        oldRank: oldRank,
        newRank: newRank,
        tokenReward: _getRankPromotionReward(newRank),
        message: _getRankPromotionMessage(newRank),
      );
    }

    return null;
  }

  /// Check if user earned a new title
  static TitlePromotion? checkTitlePromotion(
    UserProfile oldProfile,
    UserProfile newProfile,
  ) {
    final oldTitle = oldProfile.title;
    final newTitle = calculateTitle(newProfile);

    if (newTitle.index > oldTitle.index) {
      return TitlePromotion(
        oldTitle: oldTitle,
        newTitle: newTitle,
        reputationReward: _getTitlePromotionReward(newTitle),
        message: _getTitlePromotionMessage(newTitle),
      );
    }

    return null;
  }

  /// Get token reward for rank promotion
  static int _getRankPromotionReward(SkillRank rank) {
    switch (rank) {
      case SkillRank.silver:
        return 50;
      case SkillRank.gold:
        return 100;
      case SkillRank.platinum:
        return 200;
      case SkillRank.diamond:
        return 350;
      case SkillRank.master:
        return 500;
      case SkillRank.grandmaster:
        return 1000;
      default:
        return 0;
    }
  }

  /// Get reputation reward for title promotion
  static int _getTitlePromotionReward(UserTitle title) {
    switch (title) {
      case UserTitle.solver:
        return 100;
      case UserTitle.strategist:
        return 250;
      case UserTitle.mastermind:
        return 500;
      case UserTitle.grandmaster:
        return 1000;
      case UserTitle.legend:
        return 2500;
      default:
        return 0;
    }
  }

  /// Get promotion message for rank
  static String _getRankPromotionMessage(SkillRank rank) {
    switch (rank) {
      case SkillRank.bronze:
        return 'Welcome to Bronze rank! Your journey begins.';
      case SkillRank.silver:
        return 'Promoted to Silver! You\'re showing real potential.';
      case SkillRank.gold:
        return 'Gold rank achieved! Your skills are impressive.';
      case SkillRank.platinum:
        return 'Platinum rank! You\'re among the elite.';
      case SkillRank.diamond:
        return 'Diamond rank! Exceptional mastery displayed.';
      case SkillRank.master:
        return 'Master rank attained! Few reach this level.';
      case SkillRank.grandmaster:
        return 'Grandmaster! You stand at the pinnacle of achievement.';
    }
  }

  /// Get promotion message for title
  static String _getTitlePromotionMessage(UserTitle title) {
    switch (title) {
      case UserTitle.novice:
        return 'Welcome, Novice. Every master was once a beginner.';
      case UserTitle.solver:
        return 'Title earned: Solver. You\'re proving your worth.';
      case UserTitle.strategist:
        return 'Title earned: Strategist. Your tactical mind shines.';
      case UserTitle.mastermind:
        return 'Title earned: Mastermind. Brilliance recognized.';
      case UserTitle.grandmaster:
        return 'Title earned: Grandmaster. A legend in the making.';
      case UserTitle.legend:
        return 'Title earned: Legend. Your name will be remembered.';
    }
  }

  /// Get progress to next rank (0.0 to 1.0)
  static double getRankProgress(UserProfile profile) {
    final currentRank = profile.rank;
    final currentScore = _calculateRankScore(profile);

    // Already at max rank
    if (currentRank == SkillRank.grandmaster) {
      return 1.0;
    }

    final nextRankThreshold = _getNextRankThreshold(currentRank);
    final currentRankThreshold = _getCurrentRankThreshold(currentRank);

    final progress = (currentScore - currentRankThreshold) /
        (nextRankThreshold - currentRankThreshold);

    return progress.clamp(0.0, 1.0);
  }

  static int _getCurrentRankThreshold(SkillRank rank) {
    switch (rank) {
      case SkillRank.bronze:
        return 0;
      case SkillRank.silver:
        return 500;
      case SkillRank.gold:
        return 1500;
      case SkillRank.platinum:
        return 3000;
      case SkillRank.diamond:
        return 5000;
      case SkillRank.master:
        return 7000;
      case SkillRank.grandmaster:
        return 10000;
    }
  }

  static int _getNextRankThreshold(SkillRank rank) {
    switch (rank) {
      case SkillRank.bronze:
        return 500;
      case SkillRank.silver:
        return 1500;
      case SkillRank.gold:
        return 3000;
      case SkillRank.platinum:
        return 5000;
      case SkillRank.diamond:
        return 7000;
      case SkillRank.master:
        return 10000;
      case SkillRank.grandmaster:
        return 10000; // Max rank
    }
  }
}

/// Rank promotion details
class RankPromotion {
  final SkillRank oldRank;
  final SkillRank newRank;
  final int tokenReward;
  final String message;

  const RankPromotion({
    required this.oldRank,
    required this.newRank,
    required this.tokenReward,
    required this.message,
  });
}

/// Title promotion details
class TitlePromotion {
  final UserTitle oldTitle;
  final UserTitle newTitle;
  final int reputationReward;
  final String message;

  const TitlePromotion({
    required this.oldTitle,
    required this.newTitle,
    required this.reputationReward,
    required this.message,
  });
}
