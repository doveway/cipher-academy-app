# Cipher Academy

A mystery-driven math and logic puzzle game for teens built with Flutter.

## Overview

Cipher Academy is a cross-platform educational game that combines engaging storytelling with challenging puzzles. Players are recruited into a secret academy training young codebreakers, solving mysteries through increasingly complex mathematical and logical challenges.

### Features

- **Dark Academia Aesthetic**: Sophisticated UI with burgundy, forest green, navy, and brass color scheme
- **Progressive Difficulty**: From pattern recognition to advanced problem-solving (Levels 1-40+)
- **Compelling Narrative**: Season-based storylines with character development
- **Multiple Puzzle Types**:
  - Sequence completion (Fibonacci, geometric patterns)
  - Basic cryptography (Caesar ciphers, substitution)
  - Visual logic puzzles
  - Algebra and geometry challenges
  - And more!
- **Progress Tracking**: Local storage of user progress, achievements, and statistics
- **Hint System**: Free daily hints, unlimited hints for premium users
- **Freemium Model**: First 2 chapters free, premium subscription for full access

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── puzzle.dart          # Puzzle data structure
│   ├── chapter.dart         # Chapter and season models
│   └── user_progress.dart   # User progress tracking
├── screens/                  # UI screens
│   ├── home_screen.dart     # Main menu
│   ├── chapter_screen.dart  # Chapter details
│   └── puzzle_screen.dart   # Puzzle gameplay
├── widgets/                  # Reusable widgets
│   ├── stats_card.dart      # User statistics display
│   ├── chapter_card.dart    # Chapter list item
│   ├── puzzle_list_item.dart # Puzzle list item
│   └── puzzle_widgets/      # Puzzle-specific widgets
│       └── sequence_puzzle_widget.dart
├── services/                 # Business logic
│   ├── storage_service.dart      # Local storage
│   ├── game_state_provider.dart  # State management
│   └── puzzle_service.dart       # Puzzle data service
├── theme/                    # Theming
│   └── app_theme.dart       # Dark Academia theme
└── utils/                    # Utilities (future)
```

## Getting Started

### Prerequisites

1. **Install Flutter**: Download and install Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. **Verify Installation**: Run `flutter doctor` to ensure everything is set up correctly
3. **IDE Setup**: Install Flutter and Dart plugins for your IDE (VS Code or Android Studio)

### Installation

1. Navigate to the project directory:
   ```bash
   cd /Users/dovewaymacm4/Documents/FlutterProjects/CipherAcademy
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # For iOS simulator
   flutter run -d ios

   # For Android emulator
   flutter run -d android

   # For web
   flutter run -d chrome
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS (requires Mac)
flutter build ios --release

# Web
flutter build web --release
```

## Game Content

### Season 1: The Stolen Algorithm

#### Chapter 1: The Vanishing Equation (FREE)
- **Puzzles**: 5 beginner-level challenges
- **Story**: A mysterious equation has disappeared from the Academy archives
- **Puzzle Types**: Fibonacci sequences, geometric progressions, Caesar ciphers

#### Chapter 2: Cipher in the Library (FREE)
- **Puzzles**: 6-7 puzzles
- **Story**: Hidden messages in ancient books lead to the truth
- **Puzzle Types**: Substitution ciphers, book codes, pattern analysis

### Future Chapters (Premium)
- Chapter 3-8 planned with increasing difficulty
- Meta-puzzles requiring cross-chapter solutions
- Time-based challenges for competitive players

## Development Roadmap

### Phase 1: MVP (Current)
- ✅ Core game mechanics
- ✅ 2 free chapters with 10+ puzzles
- ✅ Dark Academia UI theme
- ✅ Progress tracking
- ✅ Hint system

### Phase 2: Enhancement
- [ ] Additional puzzle types (graph theory, set theory)
- [ ] Sound effects and background music
- [ ] Animated puzzle transitions
- [ ] Achievement system
- [ ] Leaderboards

### Phase 3: Monetization
- [ ] In-app purchase integration
- [ ] Premium subscription system
- [ ] Ad integration for free tier
- [ ] Analytics tracking

### Phase 4: Scale
- [ ] AI-generated practice puzzles
- [ ] Multiplayer co-op mode
- [ ] User-generated content
- [ ] Season 2 content

## Technical Architecture

### State Management
- **Provider**: For global state management (user progress, game state)
- **StatefulWidget**: For local UI state

### Data Persistence
- **SharedPreferences**: Local storage for user progress
- **JSON serialization**: For puzzle and chapter data

### Navigation
- **go_router**: (planned) For complex navigation flows
- **MaterialPageRoute**: For simple screen transitions

### Theme
- **Custom Dark Academia theme** using Material Design 3
- **Google Fonts** (Crimson Text) for elegant typography

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Performance Optimization

- Lazy loading of puzzle data
- Cached theme and font assets
- Optimized widget rebuilds with Provider
- Efficient state management

## Contributing

This is currently a solo project, but contributions are welcome in the future!

### Guidelines
1. Follow the existing code style (see `analysis_options.yaml`)
2. Write meaningful commit messages
3. Add tests for new features
4. Update documentation

## Educational Value

Cipher Academy helps teens develop:
- **Critical thinking**: Multi-step problem solving
- **Pattern recognition**: Foundation for programming logic
- **Mathematical reasoning**: Applied algebra, geometry, statistics
- **Persistence**: Growth mindset through challenges

## License

All rights reserved. This is a proprietary educational game.

## Contact

For questions or feedback about development, please create an issue in the repository.

## Acknowledgments

- Inspired by games like The Room, Monument Valley, and Brilliant.org
- Dark Academia aesthetic for teen-friendly, sophisticated design
- Educational content designed for ages 13-18

---

**Version**: 1.0.0
**Last Updated**: December 2024
**Status**: MVP Development
