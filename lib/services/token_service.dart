import '../models/puzzle.dart';
import '../models/user_profile.dart';

class TokenCost {
  // Answer reveal costs based on difficulty
  static int getAnswerRevealCost(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.beginner:
        return 15;
      case Difficulty.intermediate:
        return 25;
      case Difficulty.advanced:
        return 40;
      case Difficulty.expert:
        return 60;
      case Difficulty.master:
        return 100;
    }
  }

  // Hint costs (lower than full answer)
  static int getHintCost(Difficulty difficulty, int hintIndex) {
    final baseCost = getAnswerRevealCost(difficulty);
    final hintCost = (baseCost * 0.3).round(); // Hints are 30% of answer cost

    // First hint cheaper, subsequent hints more expensive
    return hintCost + (hintIndex * 5);
  }

  // Token earning from solving puzzles
  static int getTokenReward(
    Difficulty difficulty,
    bool usedHints,
    bool wasFast,
    bool isPerfect,
  ) {
    int baseReward;

    switch (difficulty) {
      case Difficulty.beginner:
        baseReward = 10;
        break;
      case Difficulty.intermediate:
        baseReward = 20;
        break;
      case Difficulty.advanced:
        baseReward = 35;
        break;
      case Difficulty.expert:
        baseReward = 55;
        break;
      case Difficulty.master:
        baseReward = 80;
        break;
    }

    // Bonuses
    if (isPerfect) {
      baseReward = (baseReward * 2).round(); // 2x for perfect solve
    } else {
      if (!usedHints) {
        baseReward = (baseReward * 1.5).round(); // 1.5x for no hints
      }
      if (wasFast) {
        baseReward = (baseReward * 1.3).round(); // 1.3x for fast solve
      }
    }

    return baseReward;
  }

  // Multiplayer rewards
  static int getMultiplayerWinReward(Difficulty difficulty) {
    return getAnswerRevealCost(difficulty) * 2; // 2x the answer cost
  }

  static int getMultiplayerLossReward(Difficulty difficulty) {
    return getAnswerRevealCost(difficulty); // Participation reward
  }

  // Purchase validation
  static bool canAffordAnswerReveal(UserProfile profile, Difficulty difficulty) {
    // Check if has free answers first
    if (profile.hasFreeAnswers && profile.freeAnswersAvailable > 0) {
      return true;
    }

    // Check if has enough tokens
    return profile.tokens >= getAnswerRevealCost(difficulty);
  }

  static String getInsufficientTokensMessage(int required, int current) {
    final needed = required - current;
    return 'Need $needed more tokens! Complete quests or play multiplayer to earn tokens.';
  }
}

class TokenService {
  /// Purchase answer reveal - returns updated profile or null if can't afford
  static UserProfile? purchaseAnswerReveal(
    UserProfile profile,
    Difficulty difficulty,
  ) {
    // Use free answer if available
    if (profile.hasFreeAnswers && profile.freeAnswersAvailable > 0) {
      return profile.copyWith(
        freeAnswersAvailable: profile.freeAnswersAvailable - 1,
      );
    }

    // Check if can afford
    final cost = TokenCost.getAnswerRevealCost(difficulty);
    if (profile.tokens < cost) {
      return null;
    }

    // Deduct tokens
    return profile.copyWith(
      tokens: profile.tokens - cost,
      tokensSpent: profile.tokensSpent + cost,
    );
  }

  /// Award tokens for puzzle completion
  static UserProfile awardPuzzleTokens(
    UserProfile profile,
    Difficulty difficulty, {
    required bool usedHints,
    required bool wasFast,
    required bool isPerfect,
  }) {
    final tokens = TokenCost.getTokenReward(
      difficulty,
      usedHints,
      wasFast,
      isPerfect,
    );

    return profile.copyWith(
      tokens: profile.tokens + tokens,
      lifetimeTokensEarned: profile.lifetimeTokensEarned + tokens,
    );
  }

  /// Award tokens for multiplayer
  static UserProfile awardMultiplayerTokens(
    UserProfile profile,
    Difficulty difficulty,
    bool won,
  ) {
    final tokens = won
        ? TokenCost.getMultiplayerWinReward(difficulty)
        : TokenCost.getMultiplayerLossReward(difficulty);

    return profile.copyWith(
      tokens: profile.tokens + tokens,
      lifetimeTokensEarned: profile.lifetimeTokensEarned + tokens,
      multiplayerWins: won ? profile.multiplayerWins + 1 : profile.multiplayerWins,
      multiplayerGamesPlayed: profile.multiplayerGamesPlayed + 1,
      winRate: won
          ? (profile.multiplayerWins + 1) / (profile.multiplayerGamesPlayed + 1)
          : profile.multiplayerWins / (profile.multiplayerGamesPlayed + 1),
    );
  }

  /// Award tokens from quest completion
  static UserProfile awardQuestTokens(
    UserProfile profile,
    int tokenReward,
    int reputationReward,
  ) {
    return profile.copyWith(
      tokens: profile.tokens + tokenReward,
      lifetimeTokensEarned: profile.lifetimeTokensEarned + tokenReward,
      reputationScore: profile.reputationScore + reputationReward,
    );
  }

  /// Daily login bonus (random amount)
  static int getDailyLoginBonus(String userId, DateTime date) {
    final seed = userId.hashCode + date.day;
    final random = _SeededRandom(seed);

    // 10-30 tokens daily login
    return 10 + random.nextInt(20);
  }
}

class _SeededRandom {
  int seed;
  _SeededRandom(this.seed);

  int nextInt(int max) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    return seed % max;
  }
}
