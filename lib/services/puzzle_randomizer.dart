import 'dart:math';
import '../models/puzzle.dart';

/// Randomizes puzzle data to prevent boredom
/// Each user gets different variations based on their ID + date
class PuzzleRandomizer {
  /// Randomize a puzzle based on user ID and date
  /// Returns a new puzzle with randomized data but same type/difficulty
  static Puzzle randomizePuzzle(Puzzle original, String userId, DateTime date) {
    final seed = _generateSeed(userId, date, original.id);
    final random = Random(seed);

    switch (original.type) {
      case PuzzleType.sequenceCompletion:
        return _randomizeSequence(original, random);
      case PuzzleType.basicCryptography:
        return _randomizeCryptography(original, random);
      case PuzzleType.visualLogic:
        return _randomizeVisualLogic(original, random);
      case PuzzleType.algebra:
        return _randomizeAlgebra(original, random);
      case PuzzleType.setTheory:
        return _randomizeSetTheory(original, random);
      default:
        return original;
    }
  }

  static Puzzle _randomizeSequence(Puzzle original, Random random) {
    final originalData = original.puzzleData;
    final type = originalData['type'] as String?;

    Map<String, dynamic> newData;
    String newSolution;

    switch (type) {
      case 'fibonacci':
        newData = _generateFibonacci(random);
        newSolution = newData['answer'] as String;
        break;

      case 'geometric':
        newData = _generateGeometric(random);
        newSolution = newData['answer'] as String;
        break;

      case 'prime_numbers':
        newData = _generatePrimes(random);
        newSolution = newData['answer'] as String;
        break;

      case 'perfect_squares':
        newData = _generateSquares(random);
        newSolution = newData['answer'] as String;
        break;

      default:
        return original;
    }

    return Puzzle(
      id: original.id,
      title: original.title,
      description: original.description,
      type: original.type,
      category: original.category,
      difficulty: original.difficulty,
      level: original.level,
      chapterNumber: original.chapterNumber,
      chapterTitle: original.chapterTitle,
      puzzleData: newData,
      solution: newSolution,
      hints: original.hints,
      baseInsightPoints: original.baseInsightPoints,
      hintCost: original.hintCost,
      storyContext: original.storyContext,
    );
  }

  static Map<String, dynamic> _generateFibonacci(Random random) {
    // Start with random first two numbers (1-5)
    final a = random.nextInt(5) + 1;
    final b = random.nextInt(5) + 1;

    final sequence = [a, b];
    for (var i = 0; i < 5; i++) {
      sequence.add(sequence[sequence.length - 1] + sequence[sequence.length - 2]);
    }

    // Hide one number (not the first two)
    final hideIndex = random.nextInt(sequence.length - 2) + 2;
    final answer = sequence[hideIndex];
    sequence[hideIndex] = '?';

    return {
      'sequence': sequence,
      'type': 'fibonacci',
      'answer': answer.toString(),
    };
  }

  static Map<String, dynamic> _generateGeometric(Random random) {
    // Random starting number and multiplier
    final start = random.nextInt(5) + 1;
    final multiplier = random.nextInt(3) + 2; // 2-4

    final sequence = <dynamic>[start];
    for (var i = 0; i < 4; i++) {
      sequence.add(sequence.last * multiplier);
    }

    // Hide last number
    final answer = sequence.last;
    sequence[sequence.length - 1] = '?';

    return {
      'sequence': sequence,
      'type': 'geometric',
      'operation': 'multiplication',
      'answer': answer.toString(),
    };
  }

  static Map<String, dynamic> _generatePrimes(Random random) {
    final primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47];

    // Start from random position
    final startIndex = random.nextInt(5);
    final sequence = primes.sublist(startIndex, startIndex + 7);

    // Hide one prime
    final hideIndex = random.nextInt(sequence.length - 1) + 1;
    final answer = sequence[hideIndex];
    sequence[hideIndex] = '?';

    return {
      'sequence': sequence,
      'type': 'prime_numbers',
      'answer': answer.toString(),
    };
  }

  static Map<String, dynamic> _generateSquares(Random random) {
    // Start from random number (1-5)
    final start = random.nextInt(5) + 1;

    final sequence = <dynamic>[];
    for (var i = 0; i < 7; i++) {
      final num = start + i;
      sequence.add(num * num);
    }

    // Hide one square
    final hideIndex = random.nextInt(sequence.length - 1) + 1;
    final answer = sequence[hideIndex];
    sequence[hideIndex] = '?';

    return {
      'sequence': sequence,
      'type': 'perfect_squares',
      'answer': answer.toString(),
    };
  }

  static Puzzle _randomizeCryptography(Puzzle original, Random random) {
    final messages = [
      'HELLO',
      'WORLD',
      'CIPHER',
      'SECRET',
      'PUZZLE',
      'SOLVE',
      'BRAIN',
      'LOGIC',
    ];

    final message = messages[random.nextInt(messages.length)];
    final shift = random.nextInt(13) + 3; // Caesar shift 3-15

    final encrypted = _caesarEncrypt(message, shift);

    return Puzzle(
      id: original.id,
      title: original.title,
      description: original.description,
      type: original.type,
      category: original.category,
      difficulty: original.difficulty,
      level: original.level,
      chapterNumber: original.chapterNumber,
      chapterTitle: original.chapterTitle,
      puzzleData: {
        'encrypted': encrypted,
        'shift': shift,
        'hint': 'Shift back by $shift letters',
      },
      solution: message,
      hints: original.hints,
      baseInsightPoints: original.baseInsightPoints,
      hintCost: original.hintCost,
      storyContext: original.storyContext,
    );
  }

  static String _caesarEncrypt(String text, int shift) {
    return text.split('').map((char) {
      if (!RegExp(r'[A-Z]').hasMatch(char)) return char;
      final code = char.codeUnitAt(0);
      final shifted = ((code - 65 + shift) % 26) + 65;
      return String.fromCharCode(shifted);
    }).join();
  }

  static Puzzle _randomizeVisualLogic(Puzzle original, Random random) {
    // Keep original for now - can add shape/symbol variations
    return original;
  }

  static Puzzle _randomizeAlgebra(Puzzle original, Random random) {
    // Generate random linear equation: ax + b = c
    final a = random.nextInt(5) + 2; // 2-6
    final x = random.nextInt(10) + 1; // 1-10
    final b = random.nextInt(20) - 10; // -10 to 9
    final c = a * x + b;

    final equation = b >= 0 ? '${a}x + $b = $c' : '${a}x - ${b.abs()} = $c';

    return Puzzle(
      id: original.id,
      title: original.title,
      description: original.description,
      type: original.type,
      category: original.category,
      difficulty: original.difficulty,
      level: original.level,
      chapterNumber: original.chapterNumber,
      chapterTitle: original.chapterTitle,
      puzzleData: {
        'equation': equation,
        'variable': 'x',
      },
      solution: x.toString(),
      hints: original.hints,
      baseInsightPoints: original.baseInsightPoints,
      hintCost: original.hintCost,
      storyContext: original.storyContext,
    );
  }

  static Puzzle _randomizeSetTheory(Puzzle original, Random random) {
    // Generate two random sets with some overlap
    final setASize = random.nextInt(4) + 4; // 4-7 elements
    final setBSize = random.nextInt(4) + 4;

    final setA = <String>{};
    final setB = <String>{};

    // Generate set A
    for (var i = 0; i < setASize; i++) {
      setA.add((random.nextInt(20) + 1).toString());
    }

    // Generate set B with some overlap (30% chance per element)
    for (var i = 0; i < setBSize; i++) {
      if (random.nextDouble() < 0.3 && setA.isNotEmpty) {
        // Add from set A (overlap)
        setB.add(setA.elementAt(random.nextInt(setA.length)));
      } else {
        // Add new element
        setB.add((random.nextInt(20) + 1).toString());
      }
    }

    final intersection = setA.intersection(setB).toList()..sort();

    return Puzzle(
      id: original.id,
      title: original.title,
      description: original.description,
      type: original.type,
      category: original.category,
      difficulty: original.difficulty,
      level: original.level,
      chapterNumber: original.chapterNumber,
      chapterTitle: original.chapterTitle,
      puzzleData: {
        'setA': setA.toList()..sort(),
        'setB': setB.toList()..sort(),
        'question': 'Which numbers are in both sets?',
      },
      solution: intersection.join(','),
      hints: original.hints,
      baseInsightPoints: original.baseInsightPoints,
      hintCost: original.hintCost,
      storyContext: original.storyContext,
    );
  }

  static int _generateSeed(String userId, DateTime date, String puzzleId) {
    final userHash = userId.hashCode;
    final dateHash = date.year * 10000 + date.month * 100 + date.day;
    final puzzleHash = puzzleId.hashCode;
    return userHash + dateHash + puzzleHash;
  }
}
