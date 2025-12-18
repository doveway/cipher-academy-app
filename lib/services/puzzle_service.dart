import '../models/puzzle.dart';
import '../models/chapter.dart';

class PuzzleService {
  final List<Puzzle> _puzzles = [];
  final List<Chapter> _chapters = [];

  PuzzleService() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _chapters.addAll([
      const Chapter(
        number: 1,
        title: 'The Vanishing Equation',
        subtitle: 'Season 1: The Stolen Algorithm',
        description:
            'A mysterious equation has disappeared from the Academy archives. Your journey as a codebreaker begins here.',
        storyline:
            'Professor Caldwell summons you to his office with urgent news. The Euler Manuscript, containing a revolutionary algorithm, has vanished. Only you possess the pattern recognition skills to decode the clues left behind.',
        seasonNumber: 1,
        puzzleIds: ['p1_1', 'p1_2', 'p1_3', 'p1_4', 'p1_5'],
        isFree: true,
      ),
      const Chapter(
        number: 2,
        title: 'Cipher in the Library',
        subtitle: 'Season 1: The Stolen Algorithm',
        description:
            'The trail leads to the ancient library where cryptic messages await decryption.',
        storyline:
            'Hidden within dusty tomes, you discover a series of encoded messages. Each cipher brings you closer to understanding who took the manuscript and why.',
        seasonNumber: 1,
        puzzleIds: ['p2_1', 'p2_2', 'p2_3', 'p2_4', 'p2_5', 'p2_6'],
        isFree: true,
      ),
    ]);

    _puzzles.addAll([
      // Chapter 1 Puzzles
      Puzzle(
        id: 'p1_1',
        title: 'The Fibonacci Sequence',
        description: 'Complete the sequence to unlock the first clue.',
        type: PuzzleType.sequenceCompletion,
        category: PuzzleCategory.patternRecognition,
        difficulty: Difficulty.beginner,
        level: 1,
        chapterNumber: 1,
        chapterTitle: 'The Vanishing Equation',
        puzzleData: {
          'sequence': [1, 1, 2, 3, 5, 8, 13, '?', 34],
          'type': 'fibonacci',
        },
        solution: '21',
        hints: [
          'Each number is the sum of the two preceding numbers.',
          'Look at the pattern: 1+1=2, 1+2=3, 2+3=5...',
          'What is 8+13?',
        ],
        baseInsightPoints: 50,
        storyContext:
            'On Professor Caldwell\'s desk, you notice a peculiar note with numbers arranged in sequence. The last visible number seems deliberately smudged.',
      ),
      Puzzle(
        id: 'p1_2',
        title: 'Geometric Progression',
        description: 'Identify the pattern in this geometric sequence.',
        type: PuzzleType.sequenceCompletion,
        category: PuzzleCategory.patternRecognition,
        difficulty: Difficulty.beginner,
        level: 2,
        chapterNumber: 1,
        chapterTitle: 'The Vanishing Equation',
        puzzleData: {
          'sequence': [2, 6, 18, 54, '?'],
          'type': 'geometric',
          'operation': 'multiplication',
        },
        solution: '162',
        hints: [
          'Each number is multiplied by a constant to get the next one.',
          'Try dividing each number by its predecessor.',
          'The multiplier is 3. Calculate 54 × 3.',
        ],
        baseInsightPoints: 50,
        storyContext:
            'A series of brass weights sits on the professor\'s scale, each precisely three times heavier than the last.',
      ),
      Puzzle(
        id: 'p1_3',
        title: 'Symbol Arrangement',
        description: 'Arrange the symbols according to the hidden rule.',
        type: PuzzleType.visualLogic,
        category: PuzzleCategory.patternRecognition,
        difficulty: Difficulty.beginner,
        level: 3,
        chapterNumber: 1,
        chapterTitle: 'The Vanishing Equation',
        puzzleData: {
          'symbols': ['△', '○', '□', '◇'],
          'rules': ['3 sides', '0 sides', '4 sides', '4 sides'],
          'question': 'Which symbol is different?',
        },
        solution: '◇',
        hints: [
          'Count the number of sides each shape has.',
          'Most shapes have an even number of sides or a specific count.',
          'The diamond (◇) follows the same pattern as the square - both have 4 sides, but look at angles.',
        ],
        baseInsightPoints: 75,
        storyContext:
            'Ancient symbols are carved into the oak door of the archive room. One symbol glows faintly different from the others.',
      ),
      Puzzle(
        id: 'p1_4',
        title: 'Caesar\'s Message',
        description: 'Decode this message using a simple shift cipher.',
        type: PuzzleType.basicCryptography,
        category: PuzzleCategory.patternRecognition,
        difficulty: Difficulty.beginner,
        level: 4,
        chapterNumber: 1,
        chapterTitle: 'The Vanishing Equation',
        puzzleData: {
          'encrypted': 'KHOOR',
          'shift': 3,
          'hint': 'Shift back by 3 letters',
        },
        solution: 'HELLO',
        hints: [
          'Each letter is shifted forward in the alphabet.',
          'K shifted back 3 positions becomes H.',
          'Continue shifting each letter back by 3: K→H, H→E, O→L, O→L, R→O',
        ],
        baseInsightPoints: 100,
        storyContext:
            'You find a note pinned to the manuscript\'s empty display case. The handwriting is hurried, the letters strangely shifted.',
      ),
      Puzzle(
        id: 'p1_5',
        title: 'The Missing Variable',
        description: 'Find the value that balances the equation.',
        type: PuzzleType.algebra,
        category: PuzzleCategory.patternRecognition,
        difficulty: Difficulty.intermediate,
        level: 5,
        chapterNumber: 1,
        chapterTitle: 'The Vanishing Equation',
        puzzleData: {
          'equation': '2x + 5 = 17',
          'variable': 'x',
        },
        solution: '6',
        hints: [
          'Isolate the variable by performing inverse operations.',
          'Subtract 5 from both sides: 2x = 12',
          'Divide both sides by 2 to find x.',
        ],
        baseInsightPoints: 125,
        storyContext:
            'The final clue is an equation etched into brass. Solving it reveals the combination to the professor\'s safe.',
      ),

      // Chapter 2 Puzzles
      Puzzle(
        id: 'p2_1',
        title: 'Substitution Cipher',
        description: 'Decode the message using letter frequency analysis.',
        type: PuzzleType.basicCryptography,
        category: PuzzleCategory.patternRecognition,
        difficulty: Difficulty.intermediate,
        level: 6,
        chapterNumber: 2,
        chapterTitle: 'Cipher in the Library',
        puzzleData: {
          'encrypted': 'KHOOR ZRUOG',
          'type': 'substitution',
          'commonLetters': ['E', 'T', 'A', 'O'],
        },
        solution: 'HELLO WORLD',
        hints: [
          'The most common letter in English is E.',
          'Look for short words like THE, AND, OR.',
          'This is a Caesar cipher with shift 3.',
        ],
        baseInsightPoints: 150,
        storyContext:
            'Between the pages of an ancient cryptography tome, you discover a folded parchment with an encoded message.',
      ),
      Puzzle(
        id: 'p2_2',
        title: 'Book Code',
        description: 'Use the book reference to decode the message.',
        type: PuzzleType.basicCryptography,
        category: PuzzleCategory.strategicThinking,
        difficulty: Difficulty.intermediate,
        level: 7,
        chapterNumber: 2,
        chapterTitle: 'Cipher in the Library',
        puzzleData: {
          'code': [[1, 1, 1], [1, 5, 1], [2, 3, 1]],
          'book': [
            ['The', 'quick', 'brown'],
            ['fox', 'jumps', 'over'],
            ['the', 'lazy', 'dog'],
          ],
          'format': 'line, word, letter',
        },
        solution: 'TJL',
        hints: [
          'The format is [line, word, letter position].',
          '[1,1,1] means line 1, word 1, letter 1 = "T".',
          'Continue with [1,5,1] and [2,3,1].',
        ],
        baseInsightPoints: 175,
        storyContext:
            'A specific book on the shelf has dog-eared pages with numbers scribbled in the margins.',
      ),
      Puzzle(
        id: 'p2_3',
        title: 'Pattern in Prime Numbers',
        description: 'Find the next prime number in the sequence.',
        type: PuzzleType.sequenceCompletion,
        category: PuzzleCategory.strategicThinking,
        difficulty: Difficulty.intermediate,
        level: 8,
        chapterNumber: 2,
        chapterTitle: 'Cipher in the Library',
        puzzleData: {
          'sequence': [2, 3, 5, 7, 11, 13, '?'],
          'type': 'prime_numbers',
        },
        solution: '17',
        hints: [
          'These are all prime numbers - numbers divisible only by 1 and themselves.',
          'Check each number after 13: Is 14 prime? Is 15 prime? Is 16 prime?',
          'The next prime number after 13 is 17.',
        ],
        baseInsightPoints: 150,
        storyContext:
            'The library catalog system uses prime numbers as reference codes. One entry is missing.',
      ),
      Puzzle(
        id: 'p2_4',
        title: 'Venn Diagram Mystery',
        description: 'Determine which element belongs in the intersection.',
        type: PuzzleType.setTheory,
        category: PuzzleCategory.strategicThinking,
        difficulty: Difficulty.intermediate,
        level: 9,
        chapterNumber: 2,
        chapterTitle: 'Cipher in the Library',
        puzzleData: {
          'setA': ['2', '4', '6', '8', '10'],
          'setB': ['1', '2', '3', '5', '8'],
          'question': 'Which numbers are in both sets?',
        },
        solution: '2,8',
        hints: [
          'Look for numbers that appear in BOTH lists.',
          'Set A contains even numbers, Set B contains specific numbers.',
          'The numbers 2 and 8 appear in both sets.',
        ],
        baseInsightPoints: 175,
        storyContext:
            'Two suspect lists overlap. The culprit must appear on both.',
      ),
      Puzzle(
        id: 'p2_5',
        title: 'Balance the Scale',
        description: 'Find the weight needed to balance the equation.',
        type: PuzzleType.algebra,
        category: PuzzleCategory.advancedProblemSolving,
        difficulty: Difficulty.intermediate,
        level: 10,
        chapterNumber: 2,
        chapterTitle: 'Cipher in the Library',
        puzzleData: {
          'equation': '3x - 7 = 11',
          'variable': 'x',
          'context': 'An ancient scale requires precise balance to unlock the vault.',
        },
        solution: '6',
        hints: [
          'Add 7 to both sides to isolate the term with x.',
          'After adding 7: 3x = 18',
          'Divide both sides by 3 to find x = 6.',
        ],
        baseInsightPoints: 200,
        storyContext:
            'The vault\'s locking mechanism is a perfectly balanced scale. Only the correct weight will open it.',
      ),
      Puzzle(
        id: 'p2_6',
        title: 'The Librarian\'s Riddle',
        description: 'Solve the pattern to find the missing book number.',
        type: PuzzleType.sequenceCompletion,
        category: PuzzleCategory.patternRecognition,
        difficulty: Difficulty.intermediate,
        level: 11,
        chapterNumber: 2,
        chapterTitle: 'Cipher in the Library',
        puzzleData: {
          'sequence': [1, 4, 9, 16, 25, '?', 49],
          'type': 'perfect_squares',
        },
        solution: '36',
        hints: [
          'Each number is a perfect square: 1², 2², 3², 4², 5²...',
          'What is 6²?',
          '6 × 6 = 36',
        ],
        baseInsightPoints: 150,
        storyContext:
            'The final clue: a sequence of book numbers following a mathematical pattern. One shelf label is missing.',
      ),
    ]);
  }

  List<Puzzle> getAllPuzzles() => List.unmodifiable(_puzzles);

  List<Chapter> getAllChapters() => List.unmodifiable(_chapters);

  Puzzle? getPuzzleById(String id) {
    try {
      return _puzzles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Chapter? getChapterByNumber(int number) {
    try {
      return _chapters.firstWhere((c) => c.number == number);
    } catch (e) {
      return null;
    }
  }

  List<Puzzle> getPuzzlesByChapter(int chapterNumber) {
    return _puzzles.where((p) => p.chapterNumber == chapterNumber).toList();
  }

  List<Puzzle> getPuzzlesByCategory(PuzzleCategory category) {
    return _puzzles.where((p) => p.category == category).toList();
  }

  List<Puzzle> getPuzzlesByLevel(int level) {
    return _puzzles.where((p) => p.level == level).toList();
  }
}
