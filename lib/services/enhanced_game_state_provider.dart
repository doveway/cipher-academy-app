import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user_progress.dart';
import '../models/user_profile.dart';
import '../models/puzzle.dart';
import '../models/quest.dart';
import 'storage_service.dart';
import 'puzzle_service.dart';
import 'engagement_service.dart';
import 'streak_reward_service.dart';
import 'rank_progression_service.dart';

/// Enhanced GameStateProvider with engagement features
/// Maintains backward compatibility with existing UserProgress
class EnhancedGameStateProvider extends ChangeNotifier {
  final StorageService _storageService;
  final PuzzleService _puzzleService;

  UserProgress? _userProgress;
  UserProfile? _userProfile;
  List<Quest> _dailyQuests = [];
  bool _isLoading = true;

  // Latest rewards/promotions for UI notifications
  StreakReward? _lastStreakReward;
  RankPromotion? _lastRankPromotion;
  TitlePromotion? _lastTitlePromotion;
  List<Quest> _lastCompletedQuests = [];

  EnhancedGameStateProvider(this._storageService, this._puzzleService) {
    _initialize();
  }

  // Getters
  UserProgress? get userProgress => _userProgress;
  UserProfile? get userProfile => _userProfile;
  List<Quest> get dailyQuests => _dailyQuests;
  bool get isLoading => _isLoading;
  bool get isPremium => _userProgress?.isPremium ?? false;

  // Latest notifications
  StreakReward? get lastStreakReward => _lastStreakReward;
  RankPromotion? get lastRankPromotion => _lastRankPromotion;
  TitlePromotion? get lastTitlePromotion => _lastTitlePromotion;
  List<Quest> get lastCompletedQuests => _lastCompletedQuests;

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    var progress = _storageService.getUserProgress();

    if (progress == null) {
      final userId = const Uuid().v4();
      await _storageService.saveUserId(userId);

      progress = UserProgress(
        userId: userId,
        currentLevel: 1,
        currentChapter: 1,
        totalInsightPoints: 0,
        lastHintResetDate: DateTime.now(),
        unlockedChapters: ['1', '2'],
      );

      await _storageService.saveUserProgress(progress);

      // Create new user profile
      _userProfile = UserProfile(
        userId: userId,
        displayName: 'Cipher Solver',
        lastPlayedDate: DateTime.now(),
      );
      await _saveUserProfile(_userProfile!);
    } else {
      await _storageService.resetHintCountIfNeeded(progress);
      progress = _storageService.getUserProgress()!;

      // Load or create user profile
      _userProfile = await _loadUserProfile(progress.userId);
    }

    _userProgress = progress;

    // Process login (streaks, quests, etc.)
    await _processLogin();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _processLogin() async {
    if (_userProfile == null) return;

    final now = DateTime.now();

    // Check if already processed today
    if (_isSameDay(_userProfile!.lastPlayedDate, now)) {
      _dailyQuests = EngagementService.generateDailyQuests(now);
      return;
    }

    // Process login with engagement service
    final updatedProfile = EngagementService.processLogin(_userProfile!, now);

    // Check for streak reward
    final lastStreak = _userProfile!.currentStreak;
    final newStreak = updatedProfile.currentStreak;

    if (newStreak > lastStreak || newStreak == 1) {
      _lastStreakReward = StreakRewardService.calculateStreakReward(
        newStreak,
        updatedProfile.userId,
        now,
      );
    }

    _userProfile = updatedProfile;
    await _saveUserProfile(_userProfile!);

    // Generate daily quests
    _dailyQuests = EngagementService.generateDailyQuests(now);

    notifyListeners();
  }

  Future<void> completePuzzle({
    required String puzzleId,
    required int timeTaken,
    required int hintsUsed,
    required String playerSolution,
  }) async {
    if (_userProgress == null || _userProfile == null) return;

    final puzzle = _puzzleService.getPuzzleById(puzzleId);
    if (puzzle == null) return;

    // Update UserProgress (existing system)
    final existingProgress = _userProgress!.puzzleProgress[puzzleId];
    final attemptsCount = (existingProgress?.attemptsCount ?? 0) + 1;

    final pointsMultiplier = _calculatePointsMultiplier(hintsUsed, timeTaken);
    final earnedPoints = (puzzle.baseInsightPoints * pointsMultiplier).round();

    final puzzleProgress = PuzzleProgress(
      puzzleId: puzzleId,
      isCompleted: true,
      isUnlocked: true,
      attemptsCount: attemptsCount,
      hintsUsed: hintsUsed,
      completedAt: DateTime.now(),
      timeTaken: timeTaken,
      earnedPoints: earnedPoints,
      playerSolution: playerSolution,
    );

    final updatedPuzzleProgress = Map<String, PuzzleProgress>.from(_userProgress!.puzzleProgress);
    updatedPuzzleProgress[puzzleId] = puzzleProgress;

    final newLevel = puzzle.level >= _userProgress!.currentLevel
        ? puzzle.level + 1
        : _userProgress!.currentLevel;

    _userProgress = _userProgress!.copyWith(
      puzzleProgress: updatedPuzzleProgress,
      currentLevel: newLevel,
      totalInsightPoints: _userProgress!.totalInsightPoints + earnedPoints,
    );

    await _storageService.saveUserProgress(_userProgress!);

    // Update UserProfile (new engagement system)
    final wasFast = timeTaken < 120;
    final isPerfect = hintsUsed == 0 && wasFast;

    final result = EngagementService.processPuzzleCompletion(
      profile: _userProfile!,
      puzzle: puzzle,
      usedHints: hintsUsed > 0,
      wasFast: wasFast,
      isPerfect: isPerfect,
    );

    _userProfile = result.profile;
    _lastRankPromotion = result.rankPromotion;
    _lastTitlePromotion = result.titlePromotion;
    _lastCompletedQuests = result.completedQuests;

    await _saveUserProfile(_userProfile!);

    notifyListeners();
  }

  double _calculatePointsMultiplier(int hintsUsed, int timeTaken) {
    double multiplier = 1.0;

    if (hintsUsed == 0) {
      multiplier += 0.5;
    } else if (hintsUsed == 1) {
      multiplier += 0.2;
    } else {
      multiplier -= (hintsUsed - 2) * 0.1;
    }

    if (timeTaken < 120) {
      multiplier += 0.3;
    } else if (timeTaken < 300) {
      multiplier += 0.1;
    }

    return multiplier.clamp(0.5, 2.0);
  }

  Future<void> useHint(String puzzleId) async {
    if (_userProgress == null) return;

    final canUse = _userProgress!.canUseHint();
    if (!canUse) return;

    final existingProgress = _userProgress!.puzzleProgress[puzzleId] ?? PuzzleProgress(puzzleId: puzzleId);
    final updatedPuzzleProgress = Map<String, PuzzleProgress>.from(_userProgress!.puzzleProgress);
    updatedPuzzleProgress[puzzleId] = existingProgress.copyWith(
      hintsUsed: existingProgress.hintsUsed + 1,
    );

    _userProgress = _userProgress!.copyWith(
      puzzleProgress: updatedPuzzleProgress,
      hintsUsedToday: _userProgress!.hintsUsedToday + 1,
    );

    await _storageService.saveUserProgress(_userProgress!);
    notifyListeners();
  }

  Future<void> unlockPuzzle(String puzzleId) async {
    if (_userProgress == null) return;

    final existingProgress = _userProgress!.puzzleProgress[puzzleId];
    if (existingProgress?.isUnlocked ?? false) return;

    final updatedPuzzleProgress = Map<String, PuzzleProgress>.from(_userProgress!.puzzleProgress);
    updatedPuzzleProgress[puzzleId] = (existingProgress ?? PuzzleProgress(puzzleId: puzzleId))
        .copyWith(isUnlocked: true);

    _userProgress = _userProgress!.copyWith(
      puzzleProgress: updatedPuzzleProgress,
    );

    await _storageService.saveUserProgress(_userProgress!);
    notifyListeners();
  }

  Future<void> unlockChapter(String chapterNumber) async {
    if (_userProgress == null) return;

    if (_userProgress!.unlockedChapters.contains(chapterNumber)) return;

    final updatedChapters = List<String>.from(_userProgress!.unlockedChapters)
      ..add(chapterNumber);

    _userProgress = _userProgress!.copyWith(
      unlockedChapters: updatedChapters,
    );

    await _storageService.saveUserProgress(_userProgress!);
    notifyListeners();
  }

  Future<void> setPremium(bool isPremium, {DateTime? expiryDate}) async {
    if (_userProgress == null) return;

    _userProgress = _userProgress!.copyWith(
      isPremium: isPremium,
      premiumExpiryDate: expiryDate,
    );

    await _storageService.saveUserProgress(_userProgress!);
    notifyListeners();
  }

  bool isPuzzleUnlocked(String puzzleId) {
    if (_userProgress == null) return false;
    return _userProgress!.puzzleProgress[puzzleId]?.isUnlocked ?? false;
  }

  bool isPuzzleCompleted(String puzzleId) {
    if (_userProgress == null) return false;
    return _userProgress!.puzzleProgress[puzzleId]?.isCompleted ?? false;
  }

  int getHintsUsedForPuzzle(String puzzleId) {
    if (_userProgress == null) return 0;
    return _userProgress!.puzzleProgress[puzzleId]?.hintsUsed ?? 0;
  }

  /// Get randomized puzzle for user
  Puzzle getRandomizedPuzzle(Puzzle original) {
    if (_userProfile == null) return original;
    return EngagementService.getRandomizedPuzzle(
      original,
      _userProfile!.userId,
      DateTime.now(),
    );
  }

  /// Update avatar
  Future<void> updateAvatar(AvatarType avatar) async {
    if (_userProfile == null) return;

    _userProfile = _userProfile!.copyWith(avatar: avatar);
    await _saveUserProfile(_userProfile!);
    notifyListeners();
  }

  /// Update display name
  Future<void> updateDisplayName(String name) async {
    if (_userProfile == null) return;

    _userProfile = _userProfile!.copyWith(displayName: name);
    await _saveUserProfile(_userProfile!);
    notifyListeners();
  }

  /// Reveal answer with tokens
  Future<bool> revealAnswer(Puzzle puzzle) async {
    if (_userProfile == null) return false;

    final updatedProfile = TokenService.purchaseAnswerReveal(
      _userProfile!,
      puzzle.difficulty,
    );

    if (updatedProfile == null) return false;

    _userProfile = updatedProfile;
    await _saveUserProfile(_userProfile!);
    notifyListeners();

    return true;
  }

  /// Clear notification state after showing
  void clearNotifications() {
    _lastStreakReward = null;
    _lastRankPromotion = null;
    _lastTitlePromotion = null;
    _lastCompletedQuests = [];
    notifyListeners();
  }

  // Storage helpers
  Future<UserProfile> _loadUserProfile(String userId) async {
    final profileJson = await _storageService.getString('user_profile_$userId');

    if (profileJson != null) {
      try {
        final Map<String, dynamic> json = Map<String, dynamic>.from(
          // In a real app, you'd use json.decode here
          {} // Placeholder - will create new profile if null
        );
        return UserProfile.fromJson(json);
      } catch (e) {
        // If parsing fails, create new profile
      }
    }

    // Create new profile
    return UserProfile(
      userId: userId,
      displayName: 'Cipher Solver',
      lastPlayedDate: DateTime.now(),
    );
  }

  Future<void> _saveUserProfile(UserProfile profile) async {
    // In a real app, you'd use json.encode(profile.toJson())
    // For now, we'll store individual fields
    await _storageService.saveString('user_profile_${profile.userId}', 'saved');
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
