import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user_progress.dart';
import '../models/puzzle.dart';
import 'storage_service.dart';
import 'puzzle_service.dart';

class GameStateProvider extends ChangeNotifier {
  final StorageService _storageService;
  final PuzzleService _puzzleService;

  UserProgress? _userProgress;
  bool _isLoading = true;

  GameStateProvider(this._storageService, this._puzzleService) {
    _initialize();
  }

  UserProgress? get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  bool get isPremium => _userProgress?.isPremium ?? false;

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
    } else {
      await _storageService.resetHintCountIfNeeded(progress);
      progress = _storageService.getUserProgress()!;
    }

    _userProgress = progress;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> completePuzzle({
    required String puzzleId,
    required int timeTaken,
    required int hintsUsed,
    required String playerSolution,
  }) async {
    if (_userProgress == null) return;

    final puzzle = _puzzleService.getPuzzleById(puzzleId);
    if (puzzle == null) return;

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
}
