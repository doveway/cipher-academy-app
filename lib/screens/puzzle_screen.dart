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

  @override
  void initState() {
    super.initState();
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

    if (!gameState.userProgress!.canUseHint() && !gameState.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Daily free hint already used. Upgrade to Premium for unlimited hints!'),
          backgroundColor: AppTheme.errorRed,
          action: SnackBarAction(
            label: 'Upgrade',
            onPressed: () {
              // Navigate to premium screen
            },
          ),
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

  void _checkAnswer() {
    final answer = _answerController.text.trim().toUpperCase();
    final correctAnswer = widget.puzzle.solution.toUpperCase();

    if (answer == correctAnswer) {
      final gameState = context.read<GameStateProvider>();
      final hintsUsed = gameState.getHintsUsedForPuzzle(widget.puzzle.id);

      gameState.completePuzzle(
        puzzleId: widget.puzzle.id,
        timeTaken: _secondsElapsed,
        hintsUsed: hintsUsed,
        playerSolution: answer,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.successGreen, size: 32),
              SizedBox(width: 8),
              Text('Solved!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Excellent work, Detective!'),
              const SizedBox(height: 16),
              _buildStatRow('Time:', _formatTime(_secondsElapsed)),
              _buildStatRow('Hints used:', '$hintsUsed'),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not quite right. Try again!'),
          backgroundColor: AppTheme.errorRed,
          duration: Duration(seconds: 2),
        ),
      );
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
    switch (widget.puzzle.type) {
      case PuzzleType.sequenceCompletion:
        return SequencePuzzleWidget(puzzle: widget.puzzle);
      case PuzzleType.basicCryptography:
        return SequencePuzzleWidget(puzzle: widget.puzzle);
      case PuzzleType.visualLogic:
        return VisualLogicPuzzleWidget(puzzle: widget.puzzle);
      case PuzzleType.algebra:
        return AlgebraPuzzleWidget(puzzle: widget.puzzle);
      case PuzzleType.setTheory:
        return SetTheoryPuzzleWidget(puzzle: widget.puzzle);
      default:
        return SequencePuzzleWidget(puzzle: widget.puzzle);
    }
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
                widget.puzzle.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildPuzzleWidget(),
              const SizedBox(height: 24),
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
              Text(
                '${widget.puzzle.hints.length - hintsUsed} hints remaining',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
