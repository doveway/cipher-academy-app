import 'package:equatable/equatable.dart';
import 'puzzle.dart';

enum GameMode {
  quickMatch, // Fast 1v1 matches
  ranked, // Ranked competitive
  friendly, // Play with friends
  tournament, // Special events
}

enum GameStatus {
  waiting, // Waiting for opponent
  starting, // Countdown phase
  inProgress, // Game active
  completed, // Game finished
  abandoned, // Player left
}

enum PlayerStatus {
  ready,
  solving,
  submitted,
  disconnected,
}

class MultiplayerPlayer extends Equatable {
  final String userId;
  final String displayName;
  final String avatar;
  final String rank;
  final int rating; // ELO-style rating
  final PlayerStatus status;
  final String? answer;
  final int hintsUsed;
  final DateTime? submittedAt;
  final bool isCorrect;

  const MultiplayerPlayer({
    required this.userId,
    required this.displayName,
    required this.avatar,
    required this.rank,
    required this.rating,
    this.status = PlayerStatus.ready,
    this.answer,
    this.hintsUsed = 0,
    this.submittedAt,
    this.isCorrect = false,
  });

  @override
  List<Object?> get props => [
        userId,
        displayName,
        status,
        answer,
        submittedAt,
        isCorrect,
      ];

  MultiplayerPlayer copyWith({
    String? userId,
    String? displayName,
    String? avatar,
    String? rank,
    int? rating,
    PlayerStatus? status,
    String? answer,
    int? hintsUsed,
    DateTime? submittedAt,
    bool? isCorrect,
  }) {
    return MultiplayerPlayer(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      rank: rank ?? this.rank,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      answer: answer ?? this.answer,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      submittedAt: submittedAt ?? this.submittedAt,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'avatar': avatar,
      'rank': rank,
      'rating': rating,
      'status': status.name,
      'answer': answer,
      'hintsUsed': hintsUsed,
      'submittedAt': submittedAt?.toIso8601String(),
      'isCorrect': isCorrect,
    };
  }

  factory MultiplayerPlayer.fromJson(Map<String, dynamic> json) {
    return MultiplayerPlayer(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatar: json['avatar'] as String,
      rank: json['rank'] as String,
      rating: json['rating'] as int,
      status: PlayerStatus.values.byName(json['status'] as String? ?? 'ready'),
      answer: json['answer'] as String?,
      hintsUsed: json['hintsUsed'] as int? ?? 0,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }
}

class MultiplayerGame extends Equatable {
  final String gameId;
  final GameMode mode;
  final GameStatus status;
  final Puzzle puzzle;
  final List<MultiplayerPlayer> players;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int timeLimit; // Seconds
  final String? winnerId;
  final Map<String, int> scores; // userId -> score

  const MultiplayerGame({
    required this.gameId,
    required this.mode,
    required this.status,
    required this.puzzle,
    required this.players,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.timeLimit = 300, // 5 minutes default
    this.winnerId,
    this.scores = const {},
  });

  @override
  List<Object?> get props => [
        gameId,
        status,
        players,
        winnerId,
        completedAt,
      ];

  MultiplayerGame copyWith({
    String? gameId,
    GameMode? mode,
    GameStatus? status,
    Puzzle? puzzle,
    List<MultiplayerPlayer>? players,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? timeLimit,
    String? winnerId,
    Map<String, int>? scores,
  }) {
    return MultiplayerGame(
      gameId: gameId ?? this.gameId,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      puzzle: puzzle ?? this.puzzle,
      players: players ?? this.players,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      timeLimit: timeLimit ?? this.timeLimit,
      winnerId: winnerId ?? this.winnerId,
      scores: scores ?? this.scores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'mode': mode.name,
      'status': status.name,
      'puzzle': puzzle.toJson(),
      'players': players.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'timeLimit': timeLimit,
      'winnerId': winnerId,
      'scores': scores,
    };
  }

  factory MultiplayerGame.fromJson(Map<String, dynamic> json) {
    return MultiplayerGame(
      gameId: json['gameId'] as String,
      mode: GameMode.values.byName(json['mode'] as String),
      status: GameStatus.values.byName(json['status'] as String),
      puzzle: Puzzle.fromJson(json['puzzle'] as Map<String, dynamic>),
      players: (json['players'] as List<dynamic>)
          .map((p) => MultiplayerPlayer.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      timeLimit: json['timeLimit'] as int? ?? 300,
      winnerId: json['winnerId'] as String?,
      scores: (json['scores'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
    );
  }

  // Helper methods
  bool get isWaiting => status == GameStatus.waiting;
  bool get isActive => status == GameStatus.inProgress;
  bool get isFinished => status == GameStatus.completed;

  MultiplayerPlayer? getPlayer(String userId) {
    try {
      return players.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  bool get allPlayersReady {
    return players.every((p) => p.status == PlayerStatus.ready);
  }

  bool get allPlayersSubmitted {
    return players.every((p) => p.status == PlayerStatus.submitted);
  }

  int getRemainingTime() {
    if (startedAt == null) return timeLimit;
    final elapsed = DateTime.now().difference(startedAt!).inSeconds;
    return (timeLimit - elapsed).clamp(0, timeLimit);
  }

  /// Calculate score based on correctness, speed, and hints
  int calculateScore(MultiplayerPlayer player) {
    if (!player.isCorrect) return 0;

    int baseScore = 1000;

    // Speed bonus (faster = more points)
    if (player.submittedAt != null && startedAt != null) {
      final timeUsed = player.submittedAt!.difference(startedAt!).inSeconds;
      final timeBonus = ((timeLimit - timeUsed) / timeLimit * 500).round();
      baseScore += timeBonus.clamp(0, 500);
    }

    // Hint penalty
    baseScore -= player.hintsUsed * 100;

    // Difficulty multiplier
    final difficultyMultiplier = {
      Difficulty.beginner: 1.0,
      Difficulty.intermediate: 1.5,
      Difficulty.advanced: 2.0,
      Difficulty.expert: 2.5,
      Difficulty.master: 3.0,
    }[puzzle.difficulty] ?? 1.0;

    return (baseScore * difficultyMultiplier).round().clamp(0, 5000);
  }
}

/// Matchmaking queue entry
class MatchmakingEntry extends Equatable {
  final String userId;
  final String displayName;
  final String avatar;
  final String rank;
  final int rating;
  final GameMode mode;
  final Difficulty? preferredDifficulty;
  final DateTime queuedAt;

  const MatchmakingEntry({
    required this.userId,
    required this.displayName,
    required this.avatar,
    required this.rank,
    required this.rating,
    required this.mode,
    this.preferredDifficulty,
    required this.queuedAt,
  });

  @override
  List<Object?> get props => [userId, queuedAt];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'avatar': avatar,
      'rank': rank,
      'rating': rating,
      'mode': mode.name,
      'preferredDifficulty': preferredDifficulty?.name,
      'queuedAt': queuedAt.toIso8601String(),
    };
  }

  factory MatchmakingEntry.fromJson(Map<String, dynamic> json) {
    return MatchmakingEntry(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatar: json['avatar'] as String,
      rank: json['rank'] as String,
      rating: json['rating'] as int,
      mode: GameMode.values.byName(json['mode'] as String),
      preferredDifficulty: json['preferredDifficulty'] != null
          ? Difficulty.values.byName(json['preferredDifficulty'] as String)
          : null,
      queuedAt: DateTime.parse(json['queuedAt'] as String),
    );
  }
}

/// Game result for updating player stats
class GameResult extends Equatable {
  final String gameId;
  final String userId;
  final bool won;
  final int score;
  final int tokensEarned;
  final int reputationEarned;
  final int ratingChange; // ELO change
  final DateTime completedAt;

  const GameResult({
    required this.gameId,
    required this.userId,
    required this.won,
    required this.score,
    required this.tokensEarned,
    required this.reputationEarned,
    required this.ratingChange,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [gameId, userId];

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'userId': userId,
      'won': won,
      'score': score,
      'tokensEarned': tokensEarned,
      'reputationEarned': reputationEarned,
      'ratingChange': ratingChange,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      gameId: json['gameId'] as String,
      userId: json['userId'] as String,
      won: json['won'] as bool,
      score: json['score'] as int,
      tokensEarned: json['tokensEarned'] as int,
      reputationEarned: json['reputationEarned'] as int,
      ratingChange: json['ratingChange'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}
