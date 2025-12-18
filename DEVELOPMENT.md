# Development Guide - Cipher Academy

This guide outlines how to extend and enhance Cipher Academy.

## Quick Start Development Tasks

### 1. Adding New Puzzles

Edit [lib/services/puzzle_service.dart](lib/services/puzzle_service.dart) in the `_initializeSampleData()` method:

```dart
_puzzles.add(
  Puzzle(
    id: 'p1_6',  // Unique ID
    title: 'Your Puzzle Title',
    description: 'Brief description for puzzle list',
    type: PuzzleType.sequenceCompletion,  // Choose appropriate type
    category: PuzzleCategory.patternRecognition,
    difficulty: Difficulty.beginner,
    level: 6,  // Progressive level number
    chapterNumber: 1,  // Which chapter this belongs to
    chapterTitle: 'The Vanishing Equation',
    puzzleData: {
      // Custom data for your puzzle
      'sequence': [2, 4, 8, 16, '?'],
      'type': 'powers_of_2',
    },
    solution: '32',  // The correct answer
    hints: [
      'First hint - gentle nudge',
      'Second hint - more specific',
      'Third hint - almost gives it away',
    ],
    baseInsightPoints: 100,  // Points awarded for solving
    storyContext: 'Narrative context that appears in the puzzle screen.',
  ),
);
```

### 2. Creating New Chapters

Add chapters to [lib/services/puzzle_service.dart](lib/services/puzzle_service.dart):

```dart
_chapters.add(
  const Chapter(
    number: 3,
    title: 'The Secret Laboratory',
    subtitle: 'Season 1: The Stolen Algorithm',
    description: 'Short description for chapter card',
    storyline: 'Longer narrative that appears on chapter screen...',
    seasonNumber: 1,
    puzzleIds: ['p3_1', 'p3_2', 'p3_3'],  // Reference puzzle IDs
    isFree: false,  // Set to true for free chapters
  ),
);
```

### 3. Adding New Puzzle Types

#### Step 1: Define the Puzzle Type
Edit [lib/models/puzzle.dart](lib/models/puzzle.dart):

```dart
enum PuzzleType {
  // Existing types...

  // Add your new type
  sudoku,
  mazeNavigation,
  logicGrid,
}
```

#### Step 2: Create the Widget
Create a new file: `lib/widgets/puzzle_widgets/your_puzzle_widget.dart`

```dart
import 'package:flutter/material.dart';
import '../../models/puzzle.dart';
import '../../theme/app_theme.dart';

class YourPuzzleWidget extends StatelessWidget {
  final Puzzle puzzle;

  const YourPuzzleWidget({super.key, required this.puzzle});

  @override
  Widget build(BuildContext context) {
    final puzzleData = puzzle.puzzleData;

    // Build your custom puzzle UI
    return Card(
      color: AppTheme.navy,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Your puzzle UI here
          ],
        ),
      ),
    );
  }
}
```

#### Step 3: Register in Puzzle Screen
Edit [lib/screens/puzzle_screen.dart](lib/screens/puzzle_screen.dart):

```dart
Widget _buildPuzzleWidget() {
  switch (widget.puzzle.type) {
    case PuzzleType.sequenceCompletion:
      return SequencePuzzleWidget(puzzle: widget.puzzle);
    case PuzzleType.yourNewType:
      return YourPuzzleWidget(puzzle: widget.puzzle);
    default:
      return SequencePuzzleWidget(puzzle: widget.puzzle);
  }
}
```

## Feature Implementation Guide

### Adding Sound Effects

1. **Install package**:
   ```yaml
   # pubspec.yaml
   dependencies:
     audioplayers: ^5.2.1
   ```

2. **Create audio service**:
   ```dart
   // lib/services/audio_service.dart
   import 'package:audioplayers/audioplayers.dart';

   class AudioService {
     final AudioPlayer _player = AudioPlayer();
     bool _isMuted = false;

     Future<void> playSuccess() async {
       if (!_isMuted) {
         await _player.play(AssetSource('sounds/success.mp3'));
       }
     }

     Future<void> playHint() async {
       if (!_isMuted) {
         await _player.play(AssetSource('sounds/hint.mp3'));
       }
     }
   }
   ```

3. **Add sound files to assets**:
   ```
   assets/
     sounds/
       success.mp3
       hint.mp3
       background.mp3
   ```

### Adding Animations

1. **Install package**:
   ```yaml
   dependencies:
     lottie: ^3.0.0
   ```

2. **Use in widgets**:
   ```dart
   import 'package:lottie/lottie.dart';

   Lottie.asset(
     'assets/animations/success.json',
     width: 200,
     height: 200,
   )
   ```

### Implementing Achievements

1. **Create achievement model**:
   ```dart
   // lib/models/achievement.dart
   class Achievement {
     final String id;
     final String title;
     final String description;
     final IconData icon;
     final int requiredCount;

     const Achievement({...});
   }
   ```

2. **Track in user progress**:
   ```dart
   // Add to UserProgress model
   final Map<String, int> achievementProgress;
   final List<String> unlockedAchievements;
   ```

3. **Check and unlock**:
   ```dart
   void checkAchievements() {
     // Check if conditions met
     // Unlock and show notification
   }
   ```

### Adding Backend Integration

1. **Install packages**:
   ```yaml
   dependencies:
     http: ^1.1.2
     dio: ^5.4.0  # Alternative HTTP client
   ```

2. **Create API service**:
   ```dart
   // lib/services/api_service.dart
   import 'package:http/http.dart' as http;
   import 'dart:convert';

   class ApiService {
     static const baseUrl = 'https://api.cipheracademy.com';

     Future<void> syncProgress(UserProgress progress) async {
       final response = await http.post(
         Uri.parse('$baseUrl/progress'),
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode(progress.toJson()),
       );

       if (response.statusCode != 200) {
         throw Exception('Failed to sync progress');
       }
     }

     Future<List<Puzzle>> fetchNewPuzzles() async {
       final response = await http.get(
         Uri.parse('$baseUrl/puzzles'),
       );

       if (response.statusCode == 200) {
         final List<dynamic> data = jsonDecode(response.body);
         return data.map((json) => Puzzle.fromJson(json)).toList();
       }

       throw Exception('Failed to fetch puzzles');
     }
   }
   ```

### Implementing In-App Purchases

1. **Install package**:
   ```yaml
   dependencies:
     in_app_purchase: ^3.1.13
   ```

2. **Create purchase service**:
   ```dart
   // lib/services/purchase_service.dart
   import 'package:in_app_purchase/in_app_purchase.dart';

   class PurchaseService {
     final InAppPurchase _iap = InAppPurchase.instance;

     static const String premiumMonthly = 'premium_monthly';
     static const String premiumYearly = 'premium_yearly';

     Future<void> initializeStore() async {
       final available = await _iap.isAvailable();
       if (!available) return;

       const Set<String> productIds = {
         premiumMonthly,
         premiumYearly,
       };

       final response = await _iap.queryProductDetails(productIds);
       // Handle products
     }

     Future<void> purchasePremium(String productId) async {
       final ProductDetailsResponse response =
         await _iap.queryProductDetails({productId});

       if (response.productDetails.isEmpty) return;

       final PurchaseParam purchaseParam = PurchaseParam(
         productDetails: response.productDetails.first,
       );

       await _iap.buyNonConsumable(purchaseParam: purchaseParam);
     }
   }
   ```

### Adding Analytics

1. **Install Firebase**:
   ```yaml
   dependencies:
     firebase_core: ^2.24.2
     firebase_analytics: ^10.8.0
   ```

2. **Track events**:
   ```dart
   // lib/services/analytics_service.dart
   import 'package:firebase_analytics/firebase_analytics.dart';

   class AnalyticsService {
     final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

     Future<void> logPuzzleCompleted(String puzzleId, int timeSeconds) async {
       await _analytics.logEvent(
         name: 'puzzle_completed',
         parameters: {
           'puzzle_id': puzzleId,
           'time_seconds': timeSeconds,
         },
       );
     }

     Future<void> logHintUsed(String puzzleId) async {
       await _analytics.logEvent(
         name: 'hint_used',
         parameters: {'puzzle_id': puzzleId},
       );
     }
   }
   ```

## Advanced Features

### Multiplayer Mode

1. **Use Firebase Realtime Database** or **Cloud Firestore**
2. **Implement room system**:
   - Create/join rooms
   - Share puzzle state
   - Real-time updates
   - Chat functionality

### AI-Generated Puzzles

1. **Use OpenAI API** or similar
2. **Generate puzzle variations**:
   ```dart
   Future<Puzzle> generateSimilarPuzzle(Puzzle template) async {
     // Call AI API with template
     // Parse response
     // Return new puzzle
   }
   ```

### Leaderboards

1. **Firebase or custom backend**
2. **Track scores**:
   - Total points
   - Fastest solve times
   - Streak days
   - Hints efficiency

### Offline Support

1. **Use sqflite** for local database:
   ```yaml
   dependencies:
     sqflite: ^2.3.0
   ```

2. **Sync when online**:
   ```dart
   Future<void> syncWhenOnline() async {
     final hasConnection = await checkConnection();
     if (hasConnection) {
       await syncLocalToRemote();
       await syncRemoteToLocal();
     }
   }
   ```

## Testing Strategy

### Unit Tests

```dart
// test/models/puzzle_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cipher_academy/models/puzzle.dart';

void main() {
  group('Puzzle', () {
    test('should serialize to JSON correctly', () {
      final puzzle = Puzzle(
        id: 'test_1',
        title: 'Test Puzzle',
        // ... other required fields
      );

      final json = puzzle.toJson();
      final deserializedPuzzle = Puzzle.fromJson(json);

      expect(deserializedPuzzle.id, puzzle.id);
      expect(deserializedPuzzle.title, puzzle.title);
    });
  });
}
```

### Widget Tests

```dart
// test/widgets/stats_card_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cipher_academy/widgets/stats_card.dart';

void main() {
  testWidgets('StatsCard displays user stats', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatsCard(),
        ),
      ),
    );

    expect(find.text('Your Progress'), findsOneWidget);
  });
}
```

### Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cipher_academy/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete puzzle flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to puzzle
    await tester.tap(find.text('Chapter 1'));
    await tester.pumpAndSettle();

    // Solve puzzle
    // ...
  });
}
```

## Performance Optimization

### Image Optimization
- Use WebP format
- Compress images
- Lazy load images

### Code Splitting
- Split by features
- Lazy load screens
- Use deferred imports

### State Management
- Minimize rebuilds
- Use `const` constructors
- Implement `shouldRebuild` checks

## Deployment Checklist

### iOS App Store
- [ ] Configure bundle identifier
- [ ] Set up App Store Connect
- [ ] Create app icons
- [ ] Add screenshots
- [ ] Write app description
- [ ] Set up TestFlight
- [ ] Submit for review

### Google Play Store
- [ ] Configure package name
- [ ] Create Play Console account
- [ ] Generate signing key
- [ ] Create app icons
- [ ] Add screenshots
- [ ] Write app description
- [ ] Submit for review

### Web Deployment
- [ ] Build for web
- [ ] Configure hosting (Firebase, Netlify)
- [ ] Set up domain
- [ ] Add SEO tags
- [ ] Deploy

## Resources

- [Flutter Samples](https://flutter.github.io/samples/)
- [Pub.dev Packages](https://pub.dev/)
- [Flutter Community](https://flutter.dev/community)
- [Game Dev Resources](https://docs.flame-engine.org/)

---

Ready to build the next great puzzle game! 🎮
