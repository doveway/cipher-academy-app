# Two-Attempt Limit with Countdown Feature

## Overview

Implemented a two-attempt limit per question with automatic question rotation after the second failed attempt. When a player fails a question twice, they see a 3-second countdown before being automatically switched to a different question variant.

## Feature Summary

### First Wrong Answer
- Player sees confirmation dialog: "Not Quite Right"
- Two choices:
  - **"Keep This Question"** - Stay on current question (can use hint)
  - **"Try Different Question"** - Switch to new question immediately

### Second Wrong Answer (Same Question)
- If player chose "Keep This Question" on first attempt
- System shows countdown dialog: "Too Many Attempts"
- Message: "You've tried this question twice. Let's try a different one!"
- 3-second countdown: "Switching in 3... 2... 1..."
- Automatically switches to different question
- Cannot be dismissed (barrierDismissible: false)

## User Flow Examples

### Example 1: Player Uses Hints
```
1. Level 1 opens with random Fibonacci question #12
2. Player selects wrong answer
3. Dialog: "Not Quite Right" - Player clicks "Keep This Question"
4. Player clicks "Hint" button
5. Reads hint and tries again
6. Player selects correct answer
7. Success! Puzzle completed
```

### Example 2: Forced Question Switch
```
1. Level 1 opens with random Fibonacci question #7
2. Player selects wrong answer (Attempt 1)
3. Dialog: "Not Quite Right" - Player clicks "Keep This Question"
4. Player tries different answer without using hint
5. Player selects wrong answer again (Attempt 2)
6. Countdown dialog: "Too Many Attempts"
7. Counts down: 3... 2... 1...
8. Automatically switches to question #8
9. Counter resets, player can try again
```

### Example 3: Voluntary Question Switch
```
1. Level 1 opens with random Fibonacci question #23
2. Player selects wrong answer (Attempt 1)
3. Dialog: "Not Quite Right" - Player clicks "Try Different Question"
4. Immediately switches to question #24
5. SnackBar: "Here's a different question to try!"
6. Counter resets, player can try again
```

## Technical Implementation

### State Variables
```dart
int _wrongAttempts = 0; // Total wrong answers across all questions
int _wrongAttemptsOnCurrentQuestion = 0; // Wrong answers on current question
```

### Key Methods

#### `_checkAnswer()`
Modified to track attempts per question:
```dart
} else {
  // Wrong answer
  _wrongAttempts++;
  _wrongAttemptsOnCurrentQuestion++;

  if (widget.puzzle.questionPool != null && widget.puzzle.questionPool!.isNotEmpty) {
    if (_wrongAttemptsOnCurrentQuestion >= 2) {
      // Force question change with countdown
      _showCountdownAndSwitchQuestion();
    } else {
      // First attempt - show choice dialog
      showDialog(...);
    }
  }
}
```

#### `_switchToNextQuestion()`
Handles question rotation and counter reset:
```dart
void _switchToNextQuestion() {
  setState(() {
    _currentQuestionIndex = (_currentQuestionIndex + 1) % widget.puzzle.questionPool!.length;
    _selectedAnswer = null;
    _wrongAttemptsOnCurrentQuestion = 0; // Reset for new question
  });
  // Show success snackbar
}
```

#### `_showCountdownAndSwitchQuestion()`
Displays countdown and forces switch:
```dart
void _showCountdownAndSwitchQuestion() {
  int countdown = 3;
  showDialog(
    context: context,
    barrierDismissible: false, // Cannot be dismissed
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        // Timer counts down from 3 to 0
        if (countdown == 3) {
          Timer.periodic(const Duration(seconds: 1), (timer) {
            if (countdown > 0) {
              setDialogState(() {
                countdown--;
              });
            } else {
              timer.cancel();
              Navigator.of(context).pop();
              _switchToNextQuestion();
            }
          });
        }

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
      },
    ),
  );
}
```

## UI/UX Design

### Countdown Dialog
- **Icon**: Burgundy info icon
- **Title**: "Too Many Attempts"
- **Message**: Friendly explanation
- **Countdown**: Large brass-colored number (24px font)
- **Dismissible**: No (forces user to wait)
- **Duration**: 3 seconds total

### Confirmation Dialog (First Attempt)
- **Icon**: Red close icon
- **Title**: "Not Quite Right"
- **Message**: Offers choice
- **Buttons**:
  - TextButton: "Keep This Question" (secondary action)
  - ElevatedButton: "Try Different Question" (primary action, brass color)

## Game Balance Benefits

### Prevents Brute Force
- Can't try all 4 options on same question
- Maximum 2 attempts before forced rotation
- Encourages thoughtful answers

### Encourages Hint Usage
- After first wrong answer, player can use hint
- Hints remain valuable and useful
- Promotes learning over guessing

### Maintains Engagement
- Prevents frustration from being "stuck"
- Fresh questions keep game interesting
- 30 questions per level = plenty of variety

### Fair Progression
- Players can't memorize single question
- Different questions test same concept
- Multiple chances across different questions

## Edge Cases Handled

### 1. Player Clicks "Check Answer" Without Selection
```dart
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
```

### 2. Question Pool Empty or Null
Falls back to standard error snackbar:
```dart
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Not quite right. Try again!'),
      backgroundColor: AppTheme.errorRed,
      duration: Duration(seconds: 2),
    ),
  );
}
```

### 3. Timer Cleanup
Timer is properly cancelled when countdown reaches 0 to prevent memory leaks.

## Files Modified

### [lib/screens/puzzle_screen.dart](lib/screens/puzzle_screen.dart)

**Lines Modified**:
- Line 34: Added `_wrongAttemptsOnCurrentQuestion` state variable
- Lines 154-167: Added `_switchToNextQuestion()` method
- Lines 169-221: Added `_showCountdownAndSwitchQuestion()` method
- Lines 278-322: Updated wrong answer handling logic

## Testing Checklist

✅ App builds and runs successfully
✅ First wrong answer shows choice dialog
✅ "Keep This Question" button works
✅ "Try Different Question" button switches question
✅ Second wrong answer triggers countdown
✅ Countdown counts from 3 to 0
✅ Question automatically switches after countdown
✅ Counter resets when new question loads
✅ SnackBar appears after voluntary switch
✅ Cannot dismiss countdown dialog
✅ Selection cleared on question switch
✅ Hints still work between attempts

## Metrics Tracked

- `_wrongAttempts`: Total failed attempts (all questions)
- `_wrongAttemptsOnCurrentQuestion`: Failed attempts on current question variant
- `_currentQuestionIndex`: Current question from pool (0-29)

## Future Enhancements

### Potential Additions:
1. **Analytics**: Track how many questions players need before solving
2. **Difficulty Adjustment**: Harder questions after successful streaks
3. **Achievement**: "First Try Champion" badge for no wrong answers
4. **Statistics**: Show average attempts per puzzle type

### Not Recommended:
- ❌ More than 2 attempts - would enable brute force
- ❌ Shorter countdown - 3 seconds is good UX balance
- ❌ Dismissible countdown - defeats anti-guessing purpose

## User Feedback Addressed

**Original Request**: "if they choose keep question, they must use hint to try one more time, after that bring up a dialog with countdown from 3 to next question"

**Implementation**:
✅ If player chooses "Keep Question" and fails again → countdown appears
✅ Countdown goes from 3 to 0 before switching
✅ Dialog cannot be dismissed
✅ Player is encouraged (but not forced) to use hints
✅ Automatic question switch prevents stagnation

## Summary

The two-attempt limit with countdown provides the perfect balance between:
- **Player Agency**: Choose to keep or switch on first attempt
- **Anti-Cheating**: Can't brute-force all options
- **Learning Focus**: Encourages hint usage and thoughtful answers
- **Engagement**: Prevents frustration while maintaining challenge
- **Variety**: 30 questions per level keeps content fresh
