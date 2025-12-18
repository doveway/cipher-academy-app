import 'package:equatable/equatable.dart';

enum AvatarType {
  detective,
  scholar,
  strategist,
  codebreaker,
  mathematician,
  cryptographer,
  logician,
  analyst,
}

enum UserTitle {
  novice,
  solver,
  strategist,
  mastermind,
  grandmaster,
  legend,
}

enum SkillRank {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  master,
  grandmaster,
}

class UserProfile extends Equatable {
  final String userId;
  final String displayName;
  final AvatarType avatar;
  final UserTitle title;
  final SkillRank rank;

  // Token System
  final int tokens;
  final int lifetimeTokensEarned;
  final int tokensSpent;

  // Streak System
  final int currentStreak;
  final int longestStreak;
  final DateTime lastPlayedDate;
  final List<DateTime> playHistory; // Last 30 days

  // Free Answer Rewards
  final int freeAnswersAvailable;
  final DateTime? freeAnswersExpiryDate;
  final int partialStreakRewards; // Unpredictable rewards from 2-4 day streaks

  // Skills & Mastery
  final Map<String, int> skillLevels; // skill name -> level (0-100)
  final int reputationScore;
  final int totalPuzzlesSolved;
  final int perfectSolves; // No hints, fast time

  // Daily/Weekly Goals
  final Map<String, bool> dailyQuests; // quest_id -> completed
  final Map<String, int> weeklyGoals; // goal_id -> progress
  final DateTime? lastQuestResetDate;

  // Multiplayer Stats
  final int multiplayerWins;
  final int multiplayerGamesPlayed;
  final double winRate;
  final List<String> recentOpponents; // User IDs

  const UserProfile({
    required this.userId,
    required this.displayName,
    this.avatar = AvatarType.detective,
    this.title = UserTitle.novice,
    this.rank = SkillRank.bronze,
    this.tokens = 0,
    this.lifetimeTokensEarned = 0,
    this.tokensSpent = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastPlayedDate,
    this.playHistory = const [],
    this.freeAnswersAvailable = 0,
    this.freeAnswersExpiryDate,
    this.partialStreakRewards = 0,
    this.skillLevels = const {},
    this.reputationScore = 0,
    this.totalPuzzlesSolved = 0,
    this.perfectSolves = 0,
    this.dailyQuests = const {},
    this.weeklyGoals = const {},
    this.lastQuestResetDate,
    this.multiplayerWins = 0,
    this.multiplayerGamesPlayed = 0,
    this.winRate = 0.0,
    this.recentOpponents = const [],
  });

  @override
  List<Object?> get props => [
        userId,
        displayName,
        avatar,
        title,
        rank,
        tokens,
        currentStreak,
        reputationScore,
      ];

  UserProfile copyWith({
    String? userId,
    String? displayName,
    AvatarType? avatar,
    UserTitle? title,
    SkillRank? rank,
    int? tokens,
    int? lifetimeTokensEarned,
    int? tokensSpent,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPlayedDate,
    List<DateTime>? playHistory,
    int? freeAnswersAvailable,
    DateTime? freeAnswersExpiryDate,
    int? partialStreakRewards,
    Map<String, int>? skillLevels,
    int? reputationScore,
    int? totalPuzzlesSolved,
    int? perfectSolves,
    Map<String, bool>? dailyQuests,
    Map<String, int>? weeklyGoals,
    DateTime? lastQuestResetDate,
    int? multiplayerWins,
    int? multiplayerGamesPlayed,
    double? winRate,
    List<String>? recentOpponents,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      title: title ?? this.title,
      rank: rank ?? this.rank,
      tokens: tokens ?? this.tokens,
      lifetimeTokensEarned: lifetimeTokensEarned ?? this.lifetimeTokensEarned,
      tokensSpent: tokensSpent ?? this.tokensSpent,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      playHistory: playHistory ?? this.playHistory,
      freeAnswersAvailable: freeAnswersAvailable ?? this.freeAnswersAvailable,
      freeAnswersExpiryDate: freeAnswersExpiryDate ?? this.freeAnswersExpiryDate,
      partialStreakRewards: partialStreakRewards ?? this.partialStreakRewards,
      skillLevels: skillLevels ?? this.skillLevels,
      reputationScore: reputationScore ?? this.reputationScore,
      totalPuzzlesSolved: totalPuzzlesSolved ?? this.totalPuzzlesSolved,
      perfectSolves: perfectSolves ?? this.perfectSolves,
      dailyQuests: dailyQuests ?? this.dailyQuests,
      weeklyGoals: weeklyGoals ?? this.weeklyGoals,
      lastQuestResetDate: lastQuestResetDate ?? this.lastQuestResetDate,
      multiplayerWins: multiplayerWins ?? this.multiplayerWins,
      multiplayerGamesPlayed: multiplayerGamesPlayed ?? this.multiplayerGamesPlayed,
      winRate: winRate ?? this.winRate,
      recentOpponents: recentOpponents ?? this.recentOpponents,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'avatar': avatar.name,
      'title': title.name,
      'rank': rank.name,
      'tokens': tokens,
      'lifetimeTokensEarned': lifetimeTokensEarned,
      'tokensSpent': tokensSpent,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastPlayedDate': lastPlayedDate.toIso8601String(),
      'playHistory': playHistory.map((d) => d.toIso8601String()).toList(),
      'freeAnswersAvailable': freeAnswersAvailable,
      'freeAnswersExpiryDate': freeAnswersExpiryDate?.toIso8601String(),
      'partialStreakRewards': partialStreakRewards,
      'skillLevels': skillLevels,
      'reputationScore': reputationScore,
      'totalPuzzlesSolved': totalPuzzlesSolved,
      'perfectSolves': perfectSolves,
      'dailyQuests': dailyQuests,
      'weeklyGoals': weeklyGoals,
      'lastQuestResetDate': lastQuestResetDate?.toIso8601String(),
      'multiplayerWins': multiplayerWins,
      'multiplayerGamesPlayed': multiplayerGamesPlayed,
      'winRate': winRate,
      'recentOpponents': recentOpponents,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatar: AvatarType.values.byName(json['avatar'] as String? ?? 'detective'),
      title: UserTitle.values.byName(json['title'] as String? ?? 'novice'),
      rank: SkillRank.values.byName(json['rank'] as String? ?? 'bronze'),
      tokens: json['tokens'] as int? ?? 0,
      lifetimeTokensEarned: json['lifetimeTokensEarned'] as int? ?? 0,
      tokensSpent: json['tokensSpent'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastPlayedDate: DateTime.parse(json['lastPlayedDate'] as String),
      playHistory: (json['playHistory'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d as String))
              .toList() ??
          [],
      freeAnswersAvailable: json['freeAnswersAvailable'] as int? ?? 0,
      freeAnswersExpiryDate: json['freeAnswersExpiryDate'] != null
          ? DateTime.parse(json['freeAnswersExpiryDate'] as String)
          : null,
      partialStreakRewards: json['partialStreakRewards'] as int? ?? 0,
      skillLevels: (json['skillLevels'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
      reputationScore: json['reputationScore'] as int? ?? 0,
      totalPuzzlesSolved: json['totalPuzzlesSolved'] as int? ?? 0,
      perfectSolves: json['perfectSolves'] as int? ?? 0,
      dailyQuests: (json['dailyQuests'] as Map<String, dynamic>?)?.cast<String, bool>() ?? {},
      weeklyGoals: (json['weeklyGoals'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
      lastQuestResetDate: json['lastQuestResetDate'] != null
          ? DateTime.parse(json['lastQuestResetDate'] as String)
          : null,
      multiplayerWins: json['multiplayerWins'] as int? ?? 0,
      multiplayerGamesPlayed: json['multiplayerGamesPlayed'] as int? ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
      recentOpponents: (json['recentOpponents'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  // Helper methods
  String get titleDisplay {
    switch (title) {
      case UserTitle.novice:
        return 'Novice';
      case UserTitle.solver:
        return 'Solver';
      case UserTitle.strategist:
        return 'Strategist';
      case UserTitle.mastermind:
        return 'Mastermind';
      case UserTitle.grandmaster:
        return 'Grandmaster';
      case UserTitle.legend:
        return 'Legend';
    }
  }

  String get rankDisplay {
    switch (rank) {
      case SkillRank.bronze:
        return 'Bronze';
      case SkillRank.silver:
        return 'Silver';
      case SkillRank.gold:
        return 'Gold';
      case SkillRank.platinum:
        return 'Platinum';
      case SkillRank.diamond:
        return 'Diamond';
      case SkillRank.master:
        return 'Master';
      case SkillRank.grandmaster:
        return 'Grandmaster';
    }
  }

  bool get hasStreakReward => currentStreak >= 5;
  bool get hasFreeAnswers => freeAnswersAvailable > 0 &&
      (freeAnswersExpiryDate == null || DateTime.now().isBefore(freeAnswersExpiryDate!));
}
