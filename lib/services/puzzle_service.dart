import 'dart:math';
import '../models/puzzle.dart';
import '../models/chapter.dart';

class PuzzleService {
  final List<Puzzle> _puzzles = [];
  final List<Chapter> _chapters = [];

  PuzzleService() {
    _initializeSampleData();
  }

  // Generate 30 Fibonacci sequence questions
  List<PuzzleVariant> _generateFibonacciQuestions() {
    final questions = <PuzzleVariant>[];
    final random = Random(42); // Seeded for consistency

    for (int i = 0; i < 30; i++) {
      // Generate different starting points for Fibonacci sequences
      int a = random.nextInt(5) + 1;
      int b = random.nextInt(5) + 1;
      List<int> sequence = [a, b];

      for (int j = 0; j < 6; j++) {
        sequence.add(sequence[sequence.length - 1] + sequence[sequence.length - 2]);
      }

      final answer = sequence[7];
      final wrongOptions = [
        answer - 1,
        answer + 1,
        answer + random.nextInt(5) + 2,
      ];

      // Create sequence array with '?' for the visual display
      final displaySequence = [...sequence.sublist(0, 7), '?'];

      questions.add(PuzzleVariant(
        question: 'What number comes next: ${sequence.sublist(0, 7).join(", ")}, ?',
        solution: answer.toString(),
        options: [answer.toString(), ...wrongOptions.map((e) => e.toString())]..shuffle(random),
        variantData: {
          'sequence': displaySequence,
          'type': 'fibonacci',
        },
      ));
    }

    return questions;
  }

  // Generate 30 Geometric sequence questions (Level 2)
  List<PuzzleVariant> _generateGeometricQuestions() {
    final questions = <PuzzleVariant>[];
    final random = Random(43);

    for (int i = 0; i < 30; i++) {
      int start = random.nextInt(3) + 2; // 2-4
      int multiplier = random.nextInt(3) + 2; // 2-4
      List<int> sequence = [start];

      for (int j = 0; j < 4; j++) {
        sequence.add(sequence.last * multiplier);
      }

      final answer = sequence.last * multiplier;
      final wrongOptions = [
        answer - multiplier,
        answer + multiplier,
        answer * 2,
      ];

      final displaySequence = [...sequence, '?'];

      questions.add(PuzzleVariant(
        question: 'What number comes next: ${sequence.join(", ")}, ?',
        solution: answer.toString(),
        options: [answer.toString(), ...wrongOptions.map((e) => e.toString())]..shuffle(random),
        variantData: {
          'sequence': displaySequence,
          'type': 'geometric',
          'operation': 'multiplication',
        },
      ));
    }

    return questions;
  }

  // Generate 30 Symbol Logic questions (Level 3)
  List<PuzzleVariant> _generateSymbolLogicQuestions() {
    final questions = <PuzzleVariant>[];
    final symbols = [
      {'symbol': '△', 'name': 'Triangle', 'angles': 3},
      {'symbol': '○', 'name': 'Circle', 'angles': 0},
      {'symbol': '□', 'name': 'Square', 'angles': 4},
      {'symbol': '◇', 'name': 'Diamond', 'angles': 4},
      {'symbol': '⬠', 'name': 'Pentagon', 'angles': 5},
      {'symbol': '⬡', 'name': 'Hexagon', 'angles': 6},
    ];

    for (int i = 0; i < 30; i++) {
      // Pick 4 different symbols, with one being the odd one out
      final oddIndex = i % symbols.length;
      final oddSymbol = symbols[oddIndex];

      // Get 3 other symbols with similar properties
      final similarAngleCount = oddSymbol['angles'] as int;
      final others = symbols.where((s) =>
        s != oddSymbol && (s['angles'] as int) != similarAngleCount
      ).take(3).toList();

      if (others.length < 3) continue;

      final allSymbols = [...others, oddSymbol]..shuffle(Random(44 + i));

      questions.add(PuzzleVariant(
        question: 'Look at these symbols: ${allSymbols.map((s) => s['symbol']).join(", ")}. Which one is the odd one out based on its angles?',
        solution: '${oddSymbol['symbol']} ${(oddSymbol['name'] as String).toUpperCase()}',
        options: allSymbols.map((s) => '${s['symbol']} ${s['name']}').toList(),
      ));
    }

    return questions.take(30).toList();
  }

  // Generate 30 Caesar Cipher questions (Level 4)
  List<PuzzleVariant> _generateCaesarCipherQuestions() {
    final questions = <PuzzleVariant>[];
    final words = [
      'HELLO', 'WORLD', 'CIPHER', 'SECRET', 'PUZZLE', 'CRYPTO',
      'DECODE', 'ENIGMA', 'HIDDEN', 'CLUE', 'MYSTERY', 'CODE',
      'VAULT', 'LOCK', 'KEY', 'SAFE', 'GUARD', 'TRUST',
      'LIGHT', 'DARK', 'NIGHT', 'STARS', 'MOON', 'SUN',
      'WATER', 'FIRE', 'EARTH', 'WIND', 'STORM', 'CLOUD'
    ];

    for (int i = 0; i < 30; i++) {
      final word = words[i];
      final encrypted = word.split('').map((char) {
        return String.fromCharCode(((char.codeUnitAt(0) - 65 + 3) % 26) + 65);
      }).join('');

      final wrongOptions = [
        words[(i + 5) % words.length],
        words[(i + 10) % words.length],
        words[(i + 15) % words.length],
      ];

      questions.add(PuzzleVariant(
        question: 'Decode this encrypted message by shifting each letter back 3 positions in the alphabet: "$encrypted"',
        solution: word,
        options: [word, ...wrongOptions]..shuffle(Random(45 + i)),
      ));
    }

    return questions;
  }

  // Generate 30 Algebra questions (Level 5)
  List<PuzzleVariant> _generateAlgebraQuestions() {
    final questions = <PuzzleVariant>[];
    final random = Random(46);

    for (int i = 0; i < 30; i++) {
      int coefficient = random.nextInt(5) + 2; // 2-6
      int constant = random.nextInt(10) + 1; // 1-10
      int x = random.nextInt(8) + 1; // 1-8
      int result = coefficient * x + constant;

      final wrongOptions = [
        x - 1,
        x + 1,
        x + 2,
      ];

      questions.add(PuzzleVariant(
        question: 'Solve for x in this equation: ${coefficient}x + $constant = $result',
        solution: x.toString(),
        options: [x.toString(), ...wrongOptions.map((e) => e.toString())]..shuffle(random),
      ));
    }

    return questions;
  }

  // Generate 30 Caesar Cipher (two words) questions (Level 6)
  List<PuzzleVariant> _generateCaesarTwoWordsQuestions() {
    final questions = <PuzzleVariant>[];
    final wordPairs = [
      ['HELLO', 'WORLD'], ['NIGHT', 'LIGHT'], ['GRAND', 'THEFT'],
      ['PRIME', 'CRIME'], ['SILENT', 'NIGHT'], ['QUICK', 'BROWN'],
      ['LAZY', 'RIVER'], ['BRIGHT', 'STARS'], ['DARK', 'MOON'],
      ['LIGHT', 'HOUSE'], ['WILD', 'WIND'], ['CALM', 'STORM'],
      ['COLD', 'WATER'], ['HOT', 'FIRE'], ['DEEP', 'OCEAN'],
    ];

    for (int i = 0; i < 30; i++) {
      final pair = wordPairs[i % wordPairs.length];
      final encrypted = pair.map((word) =>
        word.split('').map((char) {
          return String.fromCharCode(((char.codeUnitAt(0) - 65 + 3) % 26) + 65);
        }).join('')
      ).join(' ');

      final decrypted = pair.join(' ');

      final wrongOptions = [
        wordPairs[(i + 3) % wordPairs.length].join(' '),
        wordPairs[(i + 7) % wordPairs.length].join(' '),
        wordPairs[(i + 11) % wordPairs.length].join(' '),
      ];

      questions.add(PuzzleVariant(
        question: 'Decode this message (Caesar shift -3): "$encrypted"',
        solution: decrypted,
        options: [decrypted, ...wrongOptions]..shuffle(Random(47 + i)),
      ));
    }

    return questions;
  }

  // Generate 30 Prime Number questions (Level 8)
  List<PuzzleVariant> _generatePrimeNumberQuestions() {
    final questions = <PuzzleVariant>[];
    final primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97];

    for (int i = 0; i < 30; i++) {
      final startIndex = i % 18; // Leave room for 6-element sequences
      final sequence = primes.sublist(startIndex, startIndex + 6);
      final answer = primes[startIndex + 6];

      final wrongOptions = [
        answer - 2,
        answer + 1,
        answer + 2,
      ];

      final displaySequence = [...sequence, '?'];

      questions.add(PuzzleVariant(
        question: 'What is the next prime number in this sequence: ${sequence.join(", ")}, ?',
        solution: answer.toString(),
        options: [answer.toString(), ...wrongOptions.map((e) => e.toString())]..shuffle(Random(48 + i)),
        variantData: {
          'sequence': displaySequence,
          'type': 'prime_numbers',
        },
      ));
    }

    return questions;
  }

  // Generate 30 Venn Diagram (Set Theory) questions (Level 9)
  List<PuzzleVariant> _generateVennDiagramQuestions() {
    final questions = <PuzzleVariant>[];
    final random = Random(49);

    for (int i = 0; i < 30; i++) {
      // Generate two sets with some overlap
      final setAStart = random.nextInt(5) + 1;
      final setBStart = random.nextInt(5) + 1;

      final setA = List.generate(5, (index) => (setAStart + index * 2).toString());
      final setB = List.generate(5, (index) => (setBStart + index).toString());

      final intersection = setA.where((e) => setB.contains(e)).toList();

      if (intersection.isEmpty) {
        i--;
        continue;
      }

      final wrongOptions = [
        setA.where((e) => !setB.contains(e)).take(2).join(', '),
        setB.where((e) => !setA.contains(e)).take(2).join(', '),
        '${setA.first}, ${setB.last}',
      ];

      questions.add(PuzzleVariant(
        question: 'Set A = {${setA.join(", ")}}, Set B = {${setB.join(", ")}}. Which numbers appear in BOTH sets?',
        solution: intersection.join(','),
        options: [intersection.join(', '), ...wrongOptions]..shuffle(random),
      ));
    }

    return questions;
  }

  // Generate 30 Algebra questions for Level 10
  List<PuzzleVariant> _generateAlgebraLevel10Questions() {
    final questions = <PuzzleVariant>[];
    final random = Random(50);

    for (int i = 0; i < 30; i++) {
      int coefficient = random.nextInt(5) + 2; // 2-6
      int constant = random.nextInt(15) + 5; // 5-19
      int x = random.nextInt(8) + 2; // 2-9
      int result = coefficient * x - constant;

      final wrongOptions = [
        x - 1,
        x + 1,
        x + 2,
      ];

      questions.add(PuzzleVariant(
        question: 'Solve for x: ${coefficient}x - $constant = $result',
        solution: x.toString(),
        options: [x.toString(), ...wrongOptions.map((e) => e.toString())]..shuffle(random),
      ));
    }

    return questions;
  }

  // Generate 30 Perfect Squares questions (Level 11)
  List<PuzzleVariant> _generatePerfectSquaresQuestions() {
    final questions = <PuzzleVariant>[];

    for (int i = 0; i < 30; i++) {
      final start = (i % 5) + 1;
      final sequence = List.generate(6, (index) => (start + index) * (start + index));
      final answer = (start + 6) * (start + 6);

      final wrongOptions = [
        answer - 4,
        answer + 4,
        answer - 1,
      ];

      final displaySequence = [...sequence, '?'];

      questions.add(PuzzleVariant(
        question: 'Find the missing number in this sequence: ${sequence.join(", ")}, ?',
        solution: answer.toString(),
        options: [answer.toString(), ...wrongOptions.map((e) => e.toString())]..shuffle(Random(51 + i)),
        variantData: {
          'sequence': displaySequence,
          'type': 'perfect_squares',
        },
      ));
    }

    return questions;
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
            'Professor Chukwuemeka Okonkwo summons you to his office with urgent news. The legendary mathematician, alongside his colleague Dr. Eleanor Hartley, discovered that the Euler Manuscript has vanished from the Academy vault. The manuscript contained groundbreaking work by the late Professor Adaeze Nwosu, who collaborated with Dr. Heinrich Schmidt before her mysterious disappearance. Only you possess the pattern recognition skills to decode the clues left behind.',
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
            'Librarian Ngozi Okoro discovered unusual activity in the restricted archives the night Professor Nwosu\'s manuscript vanished. With help from visiting scholar Dr. Viktor Petrov and young researcher Chioma Eze, you uncover a series of encoded messages hidden within dusty tomes. Each cipher reveals more about the shadowy figure who orchestrated the theft—someone who knew Professor Nwosu\'s work intimately.',
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
        description: 'What number comes next in this sequence: 1, 1, 2, 3, 5, 8, 13, ?, 34',
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
            'On Professor Okonkwo\'s mahogany desk, you notice a peculiar note with numbers arranged in sequence. The last visible number seems deliberately smudged.',
        questionPool: _generateFibonacciQuestions(),
      ),
      Puzzle(
        id: 'p1_2',
        title: 'Geometric Progression',
        description: 'What number comes next: 2, 6, 18, 54, ?',
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
            'A series of brass weights, once belonging to Professor Nwosu, sits on the antique scale. Each is precisely three times heavier than the last.',
        questionPool: _generateGeometricQuestions(),
      ),
      Puzzle(
        id: 'p1_3',
        title: 'Symbol Logic',
        description: 'Look at these symbols: △ (triangle), ○ (circle), □ (square), ◇ (diamond). Which one is the odd one out based on its angles?',
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
        solution: '○ CIRCLE',
        hints: [
          'Think about the angles each shape has.',
          'A circle has no corners or angles.',
          'All other shapes have angles: triangle (3), square (4), diamond (4).',
        ],
        baseInsightPoints: 75,
        storyContext:
            'Ancient symbols are carved into the oak door of the archive room. One symbol glows faintly different from the others.',
        questionPool: _generateSymbolLogicQuestions(),
      ),
      Puzzle(
        id: 'p1_4',
        title: 'Caesar\'s Message',
        description: 'Decode this encrypted message by shifting each letter back 3 positions in the alphabet: "KHOOR"',
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
            'You find a note pinned to the manuscript\'s empty display case. Dr. Hartley confirms the handwriting doesn\'t match any Academy staff. The letters are strangely shifted.',
        questionPool: _generateCaesarCipherQuestions(),
      ),
      Puzzle(
        id: 'p1_5',
        title: 'The Missing Variable',
        description: 'Solve for x in this equation: 2x + 5 = 17',
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
            'The final clue is an equation etched into brass, hidden in Professor Nwosu\'s old laboratory. Solving it reveals the combination to her private safe.',
        questionPool: _generateAlgebraQuestions(),
      ),

      // Chapter 2 Puzzles
      Puzzle(
        id: 'p2_1',
        title: 'Substitution Cipher',
        description: 'Decode this message (Caesar shift -3): "KHOOR ZRUOG"',
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
            'Ngozi Okoro, the head librarian, shows you an ancient cryptography tome where she found a folded parchment with an encoded message tucked between its pages.',
        questionPool: _generateCaesarTwoWordsQuestions(),
      ),
      Puzzle(
        id: 'p2_2',
        title: 'Book Code',
        description: 'Using this text: "The quick brown / fox jumps over / the lazy dog", decode [1,1,1][1,5,1][2,3,1] (format: line, word, letter)',
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
            'Chioma Eze points out a specific book on the restricted shelf—one of Dr. Schmidt\'s journals with dog-eared pages and numbers scribbled in the margins.',
        multipleChoiceOptions: ['TBD', 'TJL', 'QJL', 'THE'],
      ),
      Puzzle(
        id: 'p2_3',
        title: 'Pattern in Prime Numbers',
        description: 'What is the next prime number in this sequence: 2, 3, 5, 7, 11, 13, ?',
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
            'Dr. Petrov notices that the library catalog system, designed by Professor Nwosu herself, uses prime numbers as reference codes. One crucial entry is missing.',
        questionPool: _generatePrimeNumberQuestions(),
      ),
      Puzzle(
        id: 'p2_4',
        title: 'Venn Diagram Mystery',
        description: 'Set A = {2, 4, 6, 8, 10}, Set B = {1, 2, 3, 5, 8}. Which numbers appear in BOTH sets?',
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
            'Security Chief Obinna Ugwu provides two lists of people with vault access. The thief must appear on both lists.',
        questionPool: _generateVennDiagramQuestions(),
      ),
      Puzzle(
        id: 'p2_5',
        title: 'Balance the Scale',
        description: 'Solve for x: 3x - 7 = 11',
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
            'The restricted vault, protected by an ingenious mechanism designed by Professor Okonkwo and Professor Nwosu, requires a perfectly balanced scale. Only the correct weight will open it.',
        questionPool: _generateAlgebraLevel10Questions(),
      ),
      Puzzle(
        id: 'p2_6',
        title: 'The Librarian\'s Riddle',
        description: 'Find the missing number in this sequence: 1, 4, 9, 16, 25, ?, 49',
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
            'The final clue: Ngozi Okoro reveals a sequence of book numbers following a mathematical pattern on the Archive shelf. One label is missing—the location of Professor Nwosu\'s hidden research notes.',
        questionPool: _generatePerfectSquaresQuestions(),
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
