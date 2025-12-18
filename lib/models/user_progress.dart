import 'package:equatable/equatable.dart';

class UserProgress extends Equatable {
  final String userId;
  final int currentLevel;
  final int currentChapter;
  final int totalInsightPoints;
  final int hintsUsedToday;
  final DateTime lastHintResetDate;
  final Map<String, PuzzleProgress> puzzleProgress;
  final List<String> unlockedChapters;
  final Map<String, int> skillMastery;
  final bool isPremium;
  final DateTime? premiumExpiryDate;

  const UserProgress({
    required this.userId,
    this.currentLevel = 1,
    this.currentChapter = 1,
    this.totalInsightPoints = 0,
    this.hintsUsedToday = 0,
    required this.lastHintResetDate,
    this.puzzleProgress = const {},
    this.unlockedChapters = const ['1'],
    this.skillMastery = const {},
    this.isPremium = false,
    this.premiumExpiryDate,
  });

  @override
  List<Object?> get props => [
        userId,
        currentLevel,
        currentChapter,
        totalInsightPoints,
        puzzleProgress,
        isPremium,
      ];

  bool canUseHint() {
    if (isPremium) {
      return hintsUsedToday < 50; // Premium: 50 hints per day
    }
    return hintsUsedToday < 3; // Free: 3 hints per day
  }

  int get remainingHints {
    if (isPremium) {
      return (50 - hintsUsedToday).clamp(0, 50);
    }
    return (3 - hintsUsedToday).clamp(0, 3);
  }

  UserProgress copyWith({
    String? userId,
    int? currentLevel,
    int? currentChapter,
    int? totalInsightPoints,
    int? hintsUsedToday,
    DateTime? lastHintResetDate,
    Map<String, PuzzleProgress>? puzzleProgress,
    List<String>? unlockedChapters,
    Map<String, int>? skillMastery,
    bool? isPremium,
    DateTime? premiumExpiryDate,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      currentLevel: currentLevel ?? this.currentLevel,
      currentChapter: currentChapter ?? this.currentChapter,
      totalInsightPoints: totalInsightPoints ?? this.totalInsightPoints,
      hintsUsedToday: hintsUsedToday ?? this.hintsUsedToday,
      lastHintResetDate: lastHintResetDate ?? this.lastHintResetDate,
      puzzleProgress: puzzleProgress ?? this.puzzleProgress,
      unlockedChapters: unlockedChapters ?? this.unlockedChapters,
      skillMastery: skillMastery ?? this.skillMastery,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentLevel': currentLevel,
      'currentChapter': currentChapter,
      'totalInsightPoints': totalInsightPoints,
      'hintsUsedToday': hintsUsedToday,
      'lastHintResetDate': lastHintResetDate.toIso8601String(),
      'puzzleProgress': puzzleProgress.map((key, value) => MapEntry(key, value.toJson())),
      'unlockedChapters': unlockedChapters,
      'skillMastery': skillMastery,
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate?.toIso8601String(),
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'] as String,
      currentLevel: json['currentLevel'] as int? ?? 1,
      currentChapter: json['currentChapter'] as int? ?? 1,
      totalInsightPoints: json['totalInsightPoints'] as int? ?? 0,
      hintsUsedToday: json['hintsUsedToday'] as int? ?? 0,
      lastHintResetDate: DateTime.parse(json['lastHintResetDate'] as String),
      puzzleProgress: (json['puzzleProgress'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, PuzzleProgress.fromJson(value as Map<String, dynamic>)),
          ) ??
          {},
      unlockedChapters: (json['unlockedChapters'] as List<dynamic>?)?.cast<String>() ?? ['1'],
      skillMastery: (json['skillMastery'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
      isPremium: json['isPremium'] as bool? ?? false,
      premiumExpiryDate: json['premiumExpiryDate'] != null
          ? DateTime.parse(json['premiumExpiryDate'] as String)
          : null,
    );
  }
}

class PuzzleProgress extends Equatable {
  final String puzzleId;
  final bool isCompleted;
  final bool isUnlocked;
  final int attemptsCount;
  final int hintsUsed;
  final DateTime? completedAt;
  final int? timeTaken;
  final int earnedPoints;
  final String? playerSolution;

  const PuzzleProgress({
    required this.puzzleId,
    this.isCompleted = false,
    this.isUnlocked = false,
    this.attemptsCount = 0,
    this.hintsUsed = 0,
    this.completedAt,
    this.timeTaken,
    this.earnedPoints = 0,
    this.playerSolution,
  });

  @override
  List<Object?> get props => [
        puzzleId,
        isCompleted,
        attemptsCount,
        completedAt,
      ];

  PuzzleProgress copyWith({
    String? puzzleId,
    bool? isCompleted,
    bool? isUnlocked,
    int? attemptsCount,
    int? hintsUsed,
    DateTime? completedAt,
    int? timeTaken,
    int? earnedPoints,
    String? playerSolution,
  }) {
    return PuzzleProgress(
      puzzleId: puzzleId ?? this.puzzleId,
      isCompleted: isCompleted ?? this.isCompleted,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      completedAt: completedAt ?? this.completedAt,
      timeTaken: timeTaken ?? this.timeTaken,
      earnedPoints: earnedPoints ?? this.earnedPoints,
      playerSolution: playerSolution ?? this.playerSolution,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'puzzleId': puzzleId,
      'isCompleted': isCompleted,
      'isUnlocked': isUnlocked,
      'attemptsCount': attemptsCount,
      'hintsUsed': hintsUsed,
      'completedAt': completedAt?.toIso8601String(),
      'timeTaken': timeTaken,
      'earnedPoints': earnedPoints,
      'playerSolution': playerSolution,
    };
  }

  factory PuzzleProgress.fromJson(Map<String, dynamic> json) {
    return PuzzleProgress(
      puzzleId: json['puzzleId'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      attemptsCount: json['attemptsCount'] as int? ?? 0,
      hintsUsed: json['hintsUsed'] as int? ?? 0,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      timeTaken: json['timeTaken'] as int?,
      earnedPoints: json['earnedPoints'] as int? ?? 0,
      playerSolution: json['playerSolution'] as String?,
    );
  }
}
