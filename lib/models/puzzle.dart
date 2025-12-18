import 'package:equatable/equatable.dart';

enum PuzzleCategory {
  patternRecognition,
  strategicThinking,
  advancedProblemSolving,
  metaPuzzles,
}

enum PuzzleType {
  // Pattern Recognition (Levels 1-10)
  sequenceCompletion,
  visualLogic,
  basicCryptography,

  // Strategic Thinking (Levels 11-25)
  graphTheory,
  probability,
  setTheory,

  // Advanced Problem Solving (Levels 26-40)
  algebra,
  geometry,
  combinatorics,

  // Meta Puzzles (Levels 41+)
  multiStep,
  crossReference,
  timeBased,
}

enum Difficulty {
  beginner,
  intermediate,
  advanced,
  expert,
  master,
}

class Puzzle extends Equatable {
  final String id;
  final String title;
  final String description;
  final PuzzleType type;
  final PuzzleCategory category;
  final Difficulty difficulty;
  final int level;
  final int chapterNumber;
  final String chapterTitle;
  final Map<String, dynamic> puzzleData;
  final String solution;
  final List<String> hints;
  final int baseInsightPoints;
  final int hintCost;
  final String? storyContext;
  final List<String>? prerequisitePuzzleIds;

  const Puzzle({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.difficulty,
    required this.level,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.puzzleData,
    required this.solution,
    required this.hints,
    required this.baseInsightPoints,
    this.hintCost = 10,
    this.storyContext,
    this.prerequisitePuzzleIds,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        level,
        chapterNumber,
      ];

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: PuzzleType.values.byName(json['type'] as String),
      category: PuzzleCategory.values.byName(json['category'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      level: json['level'] as int,
      chapterNumber: json['chapterNumber'] as int,
      chapterTitle: json['chapterTitle'] as String,
      puzzleData: json['puzzleData'] as Map<String, dynamic>,
      solution: json['solution'] as String,
      hints: (json['hints'] as List<dynamic>).cast<String>(),
      baseInsightPoints: json['baseInsightPoints'] as int,
      hintCost: json['hintCost'] as int? ?? 10,
      storyContext: json['storyContext'] as String?,
      prerequisitePuzzleIds: (json['prerequisitePuzzleIds'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'category': category.name,
      'difficulty': difficulty.name,
      'level': level,
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'puzzleData': puzzleData,
      'solution': solution,
      'hints': hints,
      'baseInsightPoints': baseInsightPoints,
      'hintCost': hintCost,
      'storyContext': storyContext,
      'prerequisitePuzzleIds': prerequisitePuzzleIds,
    };
  }
}
