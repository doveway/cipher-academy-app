import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/puzzle.dart';
import '../services/game_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/puzzle_widgets/sequence_puzzle_widget.dart';
import '../widgets/puzzle_widgets/visual_logic_puzzle_widget.dart';
import '../widgets/puzzle_widgets/algebra_puzzle_widget.dart';
import '../widgets/puzzle_widgets/set_theory_puzzle_widget.dart';
import 'settings_screen.dart';

class PuzzleScreen extends StatefulWidget {
  final Puzzle puzzle;

  const PuzzleScreen({
    super.key,
    required this.puzzle,
  });

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  late Timer _timer;
  int _secondsElapsed = 0;
  int _currentHintIndex = 0;
  bool _showingHint = false;
  final TextEditingController _answerController = TextEditingController();
  String? _selectedAnswer; // For multiple choice
  int _currentQuestionIndex = 0; // Index of current question variant
  int _wrongAttempts = 0; // Track wrong answers
  int _wrongAttemptsOnCurrentQuestion = 0; // Track wrong attempts on current question

  @override
  void initState() {
    super.initState();
    // Select random question from pool if available
    if (widget.puzzle.questionPool != null && widget.puzzle.questionPool!.isNotEmpty) {
      _currentQuestionIndex = DateTime.now().millisecondsSinceEpoch % widget.puzzle.questionPool!.length;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _answerController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showHint() {
    final gameState = context.read<GameStateProvider>();

    if (!gameState.userProgress!.canUseHint()) {
      final isPremium = gameState.isPremium;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.lock_outline, color: AppTheme.burgundy),
              const SizedBox(width: 8),
              Text(isPremium ? 'Daily Limit Reached' : 'Hint Limit Reached'),
            ],
          ),
          content: Text(
            isPremium
                ? 'You\'ve used all 50 premium hints for today. Reset tomorrow!'
                : 'You\'ve used all 3 free hints for today. Upgrade to Premium for 50 hints per day!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            if (!isPremium)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brass,
                ),
                child: const Text('Upgrade'),
              ),
          ],
        ),
      );
      return;
    }

    if (_currentHintIndex >= widget.puzzle.hints.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No more hints available for this puzzle.'),
          backgroundColor: AppTheme.burgundy,
        ),
      );
      return;
    }

    gameState.useHint(widget.puzzle.id);

    setState(() {
      _showingHint = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: AppTheme.brass),
            const SizedBox(width: 8),
            Text('Hint ${_currentHintIndex + 1}'),
          ],
        ),
        content: Text(widget.puzzle.hints[_currentHintIndex]),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentHintIndex++;
                _showingHint = false;
              });
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _switchToNextQuestion() {
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % widget.puzzle.questionPool!.length;
      _selectedAnswer = null; // Clear selection
      _wrongAttemptsOnCurrentQuestion = 0; // Reset counter for new question
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Here\'s a different question to try!'),
        backgroundColor: AppTheme.successGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCountdownAndSwitchQuestion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CountdownDialog(
        onComplete: () {
          Navigator.of(context).pop();
          _switchToNextQuestion();
        },
      ),
    );
  }

  void _checkAnswer() {
    // For multiple choice or question pool, check if answer is selected
    if ((widget.puzzle.questionPool != null || widget.puzzle.multipleChoiceOptions != null) &&
        _selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer first!'),
          backgroundColor: AppTheme.burgundy,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Get the current question variant or use default puzzle data
    String correctAnswer;
    if (widget.puzzle.questionPool != null && widget.puzzle.questionPool!.isNotEmpty) {
      correctAnswer = widget.puzzle.questionPool![_currentQuestionIndex].solution.toUpperCase();
    } else {
      correctAnswer = widget.puzzle.solution.toUpperCase();
    }

    // Get answer from either text input or multiple choice
    final answer = widget.puzzle.questionPool != null
        ? (_selectedAnswer?.trim().toUpperCase() ?? '')
        : (widget.puzzle.multipleChoiceOptions != null
            ? (_selectedAnswer?.trim().toUpperCase() ?? '')
            : _answerController.text.trim().toUpperCase());

    if (answer == correctAnswer) {
      final gameState = context.read<GameStateProvider>();
      final hintsUsed = gameState.getHintsUsedForPuzzle(widget.puzzle.id);
      final wasAlreadyCompleted = gameState.isPuzzleCompleted(widget.puzzle.id);

      // Only award points if not already completed
      if (!wasAlreadyCompleted) {
        gameState.completePuzzle(
          puzzleId: widget.puzzle.id,
          timeTaken: _secondsElapsed,
          hintsUsed: hintsUsed,
          playerSolution: answer,
        );
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                wasAlreadyCompleted ? Icons.replay : Icons.check_circle,
                color: AppTheme.successGreen,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(wasAlreadyCompleted ? 'Correct!' : 'Solved!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(wasAlreadyCompleted
                  ? 'You\'ve already completed this puzzle.'
                  : 'Excellent work, Detective!'),
              const SizedBox(height: 16),
              _buildStatRow('Time:', _formatTime(_secondsElapsed)),
              _buildStatRow('Hints used:', '$hintsUsed'),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              if (wasAlreadyCompleted)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.burgundy.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.burgundy.withOpacity(0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.burgundy, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No points awarded for replaying',
                          style: TextStyle(
                            color: AppTheme.burgundy,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    const Icon(Icons.star, color: AppTheme.brass, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '+${(widget.puzzle.baseInsightPoints * _calculateMultiplier(hintsUsed)).round()} Insight Points',
                      style: const TextStyle(
                        color: AppTheme.brass,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else {
      // Wrong answer - show dialog and offer to try different question
      _wrongAttempts++;
      _wrongAttemptsOnCurrentQuestion++;

      if (widget.puzzle.questionPool != null && widget.puzzle.questionPool!.isNotEmpty) {
        // If they've already failed twice on this question, force question change with countdown
        if (_wrongAttemptsOnCurrentQuestion >= 2) {
          _showCountdownAndSwitchQuestion();
        } else {
          // First wrong attempt - give them choice
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.close_outlined, color: AppTheme.errorRed),
                  SizedBox(width: 8),
                  Text('Not Quite Right'),
                ],
              ),
              content: const Text(
                'That\'s not the correct answer. Would you like to try a different question from this level?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Keep This Question'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _switchToNextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brass,
                  ),
                  child: const Text('Try Different Question'),
                ),
              ],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not quite right. Try again!'),
            backgroundColor: AppTheme.errorRed,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.darkParchment)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  double _calculateMultiplier(int hintsUsed) {
    double multiplier = 1.0;
    if (hintsUsed == 0) {
      multiplier += 0.5;
    } else if (hintsUsed == 1) {
      multiplier += 0.2;
    }
    if (_secondsElapsed < 120) {
      multiplier += 0.3;
    }
    return multiplier.clamp(0.5, 2.0);
  }

  Widget _buildPuzzleWidget() {
    // Create a modified puzzle with current variant's data if available
    Puzzle displayPuzzle = widget.puzzle;
    if (widget.puzzle.questionPool != null && widget.puzzle.questionPool!.isNotEmpty) {
      final currentVariant = widget.puzzle.questionPool![_currentQuestionIndex];
      if (currentVariant.variantData != null) {
        // Create a new puzzle with merged puzzleData
        displayPuzzle = Puzzle(
          id: widget.puzzle.id,
          title: widget.puzzle.title,
          description: widget.puzzle.description,
          type: widget.puzzle.type,
          category: widget.puzzle.category,
          difficulty: widget.puzzle.difficulty,
          level: widget.puzzle.level,
          chapterNumber: widget.puzzle.chapterNumber,
          chapterTitle: widget.puzzle.chapterTitle,
          puzzleData: {...widget.puzzle.puzzleData, ...currentVariant.variantData!},
          solution: widget.puzzle.solution,
          hints: widget.puzzle.hints,
          baseInsightPoints: widget.puzzle.baseInsightPoints,
          hintCost: widget.puzzle.hintCost,
          storyContext: widget.puzzle.storyContext,
          prerequisitePuzzleIds: widget.puzzle.prerequisitePuzzleIds,
          multipleChoiceOptions: widget.puzzle.multipleChoiceOptions,
          questionPool: widget.puzzle.questionPool,
        );
      }
    }

    switch (widget.puzzle.type) {
      case PuzzleType.sequenceCompletion:
        return SequencePuzzleWidget(puzzle: displayPuzzle);
      case PuzzleType.basicCryptography:
        return SequencePuzzleWidget(puzzle: displayPuzzle);
      case PuzzleType.visualLogic:
        return VisualLogicPuzzleWidget(puzzle: displayPuzzle);
      case PuzzleType.algebra:
        return AlgebraPuzzleWidget(puzzle: displayPuzzle);
      case PuzzleType.setTheory:
        return SetTheoryPuzzleWidget(puzzle: displayPuzzle);
      default:
        return SequencePuzzleWidget(puzzle: displayPuzzle);
    }
  }

  Widget _buildMultipleChoice() {
    // Get options from question pool or regular multiple choice options
    final options = widget.puzzle.questionPool != null && widget.puzzle.questionPool!.isNotEmpty
        ? widget.puzzle.questionPool![_currentQuestionIndex].options
        : widget.puzzle.multipleChoiceOptions!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select your answer:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.brass,
              ),
        ),
        const SizedBox(height: 12),
        ...options.map((option) {
          final isSelected = _selectedAnswer == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedAnswer = option;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.brass.withOpacity(0.2)
                      : AppTheme.navy,
                  border: Border.all(
                    color: isSelected ? AppTheme.brass : AppTheme.lightCharcoal,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected ? AppTheme.brass : AppTheme.darkParchment,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.brass : AppTheme.parchment,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameStateProvider>();
    final hintsUsed = gameState.getHintsUsedForPuzzle(widget.puzzle.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.puzzle.level}'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_secondsElapsed),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show banner if puzzle already completed
              if (gameState.isPuzzleCompleted(widget.puzzle.id)) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.brass.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.brass),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.replay, color: AppTheme.brass, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Practice Mode - No points will be awarded',
                          style: TextStyle(
                            color: AppTheme.brass,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (widget.puzzle.storyContext != null) ...[
                Card(
                  color: AppTheme.darkNavy,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.menu_book,
                          color: AppTheme.brass,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.puzzle.storyContext!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text(
                widget.puzzle.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                // Use question from pool if available, otherwise use puzzle description
                widget.puzzle.questionPool != null && widget.puzzle.questionPool!.isNotEmpty
                    ? widget.puzzle.questionPool![_currentQuestionIndex].question
                    : widget.puzzle.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildPuzzleWidget(),
              const SizedBox(height: 24),
              // Show multiple choice or text input based on puzzle configuration
              if (widget.puzzle.questionPool != null || widget.puzzle.multipleChoiceOptions != null)
                _buildMultipleChoice()
              else
                TextField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    labelText: 'Your Answer',
                    hintText: 'Enter your solution here',
                    prefixIcon: Icon(Icons.create, color: AppTheme.brass),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: (_) => _checkAnswer(),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showHint,
                      icon: const Icon(Icons.lightbulb_outline),
                      label: Text('Hint ($hintsUsed used)'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      child: const Text('Check Answer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: hintsUsed / widget.puzzle.hints.length,
                backgroundColor: AppTheme.navy,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.burgundy),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.puzzle.hints.length - hintsUsed} puzzle hints left',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (!gameState.isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: gameState.userProgress!.canUseHint()
                            ? AppTheme.successGreen.withOpacity(0.2)
                            : AppTheme.errorRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: gameState.userProgress!.canUseHint()
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                        ),
                      ),
                      child: Text(
                        '${gameState.userProgress!.remainingHints}/${gameState.isPremium ? 50 : 3} daily hints',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: gameState.userProgress!.canUseHint()
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownDialog extends StatefulWidget {
  final VoidCallback onComplete;

  const _CountdownDialog({required this.onComplete});

  @override
  State<_CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<_CountdownDialog> {
  int countdown = 3;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.info_outline, color: AppTheme.burgundy),
          SizedBox(width: 8),
          Text('Too Many Attempts'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'You\'ve tried this question twice. Let\'s try a different one!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Switching in $countdown...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.brass,
            ),
          ),
        ],
      ),
    );
  }
}
