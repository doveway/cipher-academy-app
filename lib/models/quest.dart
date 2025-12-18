import 'dart:math';
import 'package:equatable/equatable.dart';

enum QuestType {
  daily,
  weekly,
  bonus,
}

enum QuestObjective {
  solvePuzzles,
  perfectSolve,
  solveWithoutHints,
  playMultiplayer,
  winMultiplayer,
  maintainStreak,
  earnTokens,
  skillMastery,
}

class Quest extends Equatable {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final QuestObjective objective;
  final int targetCount;
  final int currentProgress;
  final bool isCompleted;
  final DateTime? expiryDate;

  // Rewards
  final int tokenReward;
  final int reputationReward;
  final int? freeAnswersReward;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.objective,
    required this.targetCount,
    this.currentProgress = 0,
    this.isCompleted = false,
    this.expiryDate,
    required this.tokenReward,
    this.reputationReward = 0,
    this.freeAnswersReward,
  });

  @override
  List<Object?> get props => [id, currentProgress, isCompleted];

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    QuestType? type,
    QuestObjective? objective,
    int? targetCount,
    int? currentProgress,
    bool? isCompleted,
    DateTime? expiryDate,
    int? tokenReward,
    int? reputationReward,
    int? freeAnswersReward,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      objective: objective ?? this.objective,
      targetCount: targetCount ?? this.targetCount,
      currentProgress: currentProgress ?? this.currentProgress,
      isCompleted: isCompleted ?? this.isCompleted,
      expiryDate: expiryDate ?? this.expiryDate,
      tokenReward: tokenReward ?? this.tokenReward,
      reputationReward: reputationReward ?? this.reputationReward,
      freeAnswersReward: freeAnswersReward ?? this.freeAnswersReward,
    );
  }

  double get progressPercentage => targetCount > 0 ? (currentProgress / targetCount).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'objective': objective.name,
      'targetCount': targetCount,
      'currentProgress': currentProgress,
      'isCompleted': isCompleted,
      'expiryDate': expiryDate?.toIso8601String(),
      'tokenReward': tokenReward,
      'reputationReward': reputationReward,
      'freeAnswersReward': freeAnswersReward,
    };
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: QuestType.values.byName(json['type'] as String),
      objective: QuestObjective.values.byName(json['objective'] as String),
      targetCount: json['targetCount'] as int,
      currentProgress: json['currentProgress'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      tokenReward: json['tokenReward'] as int,
      reputationReward: json['reputationReward'] as int? ?? 0,
      freeAnswersReward: json['freeAnswersReward'] as int?,
    );
  }
}

// Quest generator with daily variety
class QuestGenerator {
  static List<Quest> generateDailyQuests(DateTime date) {
    // Use date as seed for pseudo-random but consistent daily quests
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = _SeededRandom(seed);

    final quests = <Quest>[];

    // Always 3 daily quests
    final questPool = [
      _createSolvePuzzlesQuest(random),
      _createPerfectSolveQuest(random),
      _createNoHintsQuest(random),
      _createMultiplayerQuest(random),
      _createStreakQuest(random),
    ];

    // Pick 3 random quests
    questPool.shuffle(Random(seed + 1));
    quests.addAll(questPool.take(3));

    return quests;
  }

  static List<Quest> generateWeeklyGoals(DateTime date) {
    final seed = date.year * 100 + _getWeekOfYear(date);
    final random = _SeededRandom(seed);

    return [
      Quest(
        id: 'weekly_puzzles_$seed',
        title: 'Weekly Puzzle Master',
        description: 'Solve 20 puzzles this week',
        type: QuestType.weekly,
        objective: QuestObjective.solvePuzzles,
        targetCount: 20,
        expiryDate: _getEndOfWeek(date),
        tokenReward: 150,
        reputationReward: 50,
      ),
      Quest(
        id: 'weekly_perfect_$seed',
        title: 'Perfection Streak',
        description: 'Complete 10 perfect solves',
        type: QuestType.weekly,
        objective: QuestObjective.perfectSolve,
        targetCount: 10,
        expiryDate: _getEndOfWeek(date),
        tokenReward: 200,
        reputationReward: 75,
      ),
    ];
  }

  static Quest _createSolvePuzzlesQuest(_SeededRandom random) {
    final count = random.nextInt(3) + 3; // 3-5 puzzles
    return Quest(
      id: 'daily_solve_${random.seed}',
      title: 'Daily Solver',
      description: 'Solve $count puzzles today',
      type: QuestType.daily,
      objective: QuestObjective.solvePuzzles,
      targetCount: count,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
      tokenReward: count * 10,
      reputationReward: count * 5,
    );
  }

  static Quest _createPerfectSolveQuest(_SeededRandom random) {
    return Quest(
      id: 'daily_perfect_${random.seed}',
      title: 'Perfect Performance',
      description: 'Complete 2 puzzles with no hints and fast time',
      type: QuestType.daily,
      objective: QuestObjective.perfectSolve,
      targetCount: 2,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
      tokenReward: 40,
      reputationReward: 20,
    );
  }

  static Quest _createNoHintsQuest(_SeededRandom random) {
    return Quest(
      id: 'daily_nohints_${random.seed}',
      title: 'Self Reliant',
      description: 'Solve 3 puzzles without using hints',
      type: QuestType.daily,
      objective: QuestObjective.solveWithoutHints,
      targetCount: 3,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
      tokenReward: 35,
      reputationReward: 15,
    );
  }

  static Quest _createMultiplayerQuest(_SeededRandom random) {
    return Quest(
      id: 'daily_mp_${random.seed}',
      title: 'Social Solver',
      description: 'Play 2 multiplayer matches',
      type: QuestType.daily,
      objective: QuestObjective.playMultiplayer,
      targetCount: 2,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
      tokenReward: 50,
      reputationReward: 25,
    );
  }

  static Quest _createStreakQuest(_SeededRandom random) {
    return Quest(
      id: 'daily_streak_${random.seed}',
      title: 'Consistency',
      description: 'Maintain your daily streak',
      type: QuestType.daily,
      objective: QuestObjective.maintainStreak,
      targetCount: 1,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
      tokenReward: 25,
      reputationReward: 10,
    );
  }

  static int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }

  static DateTime _getEndOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return DateTime(date.year, date.month, date.day, 23, 59, 59)
        .add(Duration(days: daysUntilSunday));
  }
}

// Simple seeded random for consistent quest generation
class _SeededRandom {
  int seed;

  _SeededRandom(this.seed);

  int nextInt(int max) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    return seed % max;
  }
}
