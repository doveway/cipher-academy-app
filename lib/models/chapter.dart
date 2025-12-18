import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final int number;
  final String title;
  final String subtitle;
  final String description;
  final String storyline;
  final int seasonNumber;
  final List<String> puzzleIds;
  final bool isFree;
  final String? coverImagePath;
  final String? unlockRequirement;

  const Chapter({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.storyline,
    this.seasonNumber = 1,
    required this.puzzleIds,
    this.isFree = false,
    this.coverImagePath,
    this.unlockRequirement,
  });

  @override
  List<Object?> get props => [
        number,
        title,
        seasonNumber,
      ];

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      number: json['number'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      storyline: json['storyline'] as String,
      seasonNumber: json['seasonNumber'] as int? ?? 1,
      puzzleIds: (json['puzzleIds'] as List<dynamic>).cast<String>(),
      isFree: json['isFree'] as bool? ?? false,
      coverImagePath: json['coverImagePath'] as String?,
      unlockRequirement: json['unlockRequirement'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'storyline': storyline,
      'seasonNumber': seasonNumber,
      'puzzleIds': puzzleIds,
      'isFree': isFree,
      'coverImagePath': coverImagePath,
      'unlockRequirement': unlockRequirement,
    };
  }
}

class Season extends Equatable {
  final int number;
  final String title;
  final String description;
  final List<Chapter> chapters;
  final bool isReleased;

  const Season({
    required this.number,
    required this.title,
    required this.description,
    required this.chapters,
    this.isReleased = true,
  });

  @override
  List<Object?> get props => [number, title];

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      number: json['number'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      isReleased: json['isReleased'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'description': description,
      'chapters': chapters.map((e) => e.toJson()).toList(),
      'isReleased': isReleased,
    };
  }
}
