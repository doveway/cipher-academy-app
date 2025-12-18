# Getting Started with Cipher Academy

Welcome! This guide will help you get Cipher Academy up and running quickly.

## 🎯 What You Have

A complete, working MVP of Cipher Academy with:

- **11 Playable Puzzles** across 2 free chapters
- **5 Different Puzzle Types** with custom widgets
- **Full State Management** for user progress tracking
- **Dark Academia UI Theme** (burgundy, navy, forest green, brass)
- **Settings Screen** with premium upgrade simulation
- **Local Progress Storage** that persists between sessions

## ⚡ Quick Start (5 Minutes)

### Step 1: Install Flutter

If you don't have Flutter installed:

```bash
# Option 1: Using Homebrew (recommended for Mac)
brew install --cask flutter

# Option 2: Manual installation
# Download from https://flutter.dev/docs/get-started/install

# Verify installation
flutter doctor
```

### Step 2: Get Dependencies

```bash
cd /Users/dovewaymacm4/Documents/FlutterProjects/CipherAcademy
flutter pub get
```

### Step 3: Run the App

```bash
# For iOS (Mac only)
flutter run -d ios

# For Android
flutter run -d android

# For Web
flutter run -d chrome
```

That's it! The app should launch and you'll see the splash screen followed by the home screen.

## 📱 What to Try First

1. **Explore the Home Screen**
   - View your stats (Level, Solved puzzles, Insight points)
   - Tap on Chapter 1 or Chapter 2

2. **Play a Puzzle**
   - Tap on "The Fibonacci Sequence" (first puzzle)
   - Read the story context
   - Enter the answer: `21`
   - Watch your points increase!

3. **Try the Hint System**
   - Open another puzzle
   - Tap the "Hint" button
   - See how hints affect your score

4. **Test Premium Features**
   - Tap the settings icon (top-right)
   - Tap "View Plans" on the premium banner
   - Select a plan to simulate premium upgrade (no actual purchase)
   - Notice unlimited hints are now available

5. **Check Your Progress**
   - Go back to home screen
   - Your stats card should show updated numbers
   - Completed puzzles have green checkmarks

## 🧩 Available Puzzles

### Chapter 1: The Vanishing Equation (5 puzzles)
1. **Fibonacci Sequence** - Answer: `21`
2. **Geometric Progression** - Answer: `162`
3. **Symbol Arrangement** - Answer: `◇`
4. **Caesar's Message** - Answer: `HELLO`
5. **The Missing Variable** - Answer: `6`

### Chapter 2: Cipher in the Library (6 puzzles)
6. **Substitution Cipher** - Answer: `HELLO WORLD`
7. **Book Code** - Answer: `TJL`
8. **Pattern in Prime Numbers** - Answer: `17`
9. **Venn Diagram Mystery** - Answer: `2,8`
10. **Balance the Scale** - Answer: `6`
11. **The Librarian's Riddle** - Answer: `36`

## 🎨 Customization Ideas

### Add More Puzzles

Edit `lib/services/puzzle_service.dart`:

```dart
_puzzles.add(
  Puzzle(
    id: 'p1_6',
    title: 'Your Puzzle',
    description: 'Solve this challenge',
    type: PuzzleType.sequenceCompletion,
    category: PuzzleCategory.patternRecognition,
    difficulty: Difficulty.beginner,
    level: 6,
    chapterNumber: 1,
    chapterTitle: 'The Vanishing Equation',
    puzzleData: {
      'sequence': [10, 20, 30, '?'],
    },
    solution: '40',
    hints: ['Hint 1', 'Hint 2', 'Hint 3'],
    baseInsightPoints: 100,
  ),
);
```

### Change the Theme Colors

Edit `lib/theme/app_theme.dart`:

```dart
static const Color burgundy = Color(0xFF6B2737);  // Change this
static const Color brass = Color(0xFFB8936D);     // Or this
```

### Modify Point Calculations

Edit `lib/services/game_state_provider.dart` in the `_calculatePointsMultiplier` method.

## 🔧 Project Structure

```
lib/
├── main.dart                  # Entry point
├── models/                    # Data structures
├── screens/                   # UI screens
│   ├── home_screen.dart
│   ├── chapter_screen.dart
│   ├── puzzle_screen.dart
│   └── settings_screen.dart
├── widgets/                   # UI components
└── services/                  # Business logic
```

## 🐛 Troubleshooting

### Issue: "flutter: command not found"
**Solution**: Add Flutter to your PATH or use the full path to Flutter binary.

### Issue: App won't run on iOS
**Solution**:
```bash
cd ios
pod install
cd ..
flutter run
```

### Issue: Dependencies conflict
**Solution**:
```bash
flutter clean
flutter pub get
```

### Issue: Can't see my progress after restart
**Solution**: This is normal - SharedPreferences persists data. To reset:
- Go to Settings → Reset Progress

## 📚 Next Steps

Once you're comfortable with the basics:

1. **Read [DEVELOPMENT.md](DEVELOPMENT.md)** - Learn how to add features
2. **Read [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Understand the full vision
3. **Experiment** - Change puzzles, add sounds, modify the UI
4. **Build** - Create your production APK/IPA

## 🎓 Learning Resources

### Flutter Basics
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

### State Management
- [Provider Package](https://pub.dev/packages/provider)
- [State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)

### Game Development
- [Game Dev with Flutter](https://docs.flame-engine.org/)
- [Animation Guide](https://flutter.dev/docs/development/ui/animations)

## 💡 Pro Tips

1. **Hot Reload is Your Friend**
   - Press `r` in terminal while app is running
   - See changes instantly without restarting

2. **Use VS Code Extensions**
   - Flutter extension
   - Dart extension
   - Flutter Widget Snippets

3. **Test on Real Devices**
   - Simulators are slower
   - Real devices show actual performance

4. **Keep Code Clean**
   - Run `flutter format .` regularly
   - Use `flutter analyze` to find issues

## 🚀 Deployment Checklist

When you're ready to release:

- [ ] Add real app icons (replace placeholders)
- [ ] Create screenshots for App Store/Play Store
- [ ] Write app description
- [ ] Set up actual in-app purchases (if monetizing)
- [ ] Add analytics (Firebase)
- [ ] Test on multiple devices
- [ ] Build release version
- [ ] Submit to stores

## ❓ Common Questions

**Q: Can I monetize this?**
A: Yes! The premium subscription system is designed for it. You'll need to integrate actual payment processing (see DEVELOPMENT.md).

**Q: Can I change the story/theme?**
A: Absolutely! It's your game. Change chapter titles, puzzle contexts, theme colors - whatever you want.

**Q: How do I add sound effects?**
A: See DEVELOPMENT.md section "Adding Sound Effects" for step-by-step guide.

**Q: Can I make this multiplayer?**
A: Yes, but it requires backend work. See DEVELOPMENT.md section "Multiplayer Mode".

## 🎉 You're Ready!

You now have everything you need to:
- ✅ Run the game
- ✅ Play through puzzles
- ✅ Understand the code
- ✅ Make modifications
- ✅ Add new content

Happy coding, and enjoy building Cipher Academy! 🔐📚✨

---

**Need Help?**
- Check the existing documentation files
- Review the code comments
- The Flutter community is incredibly helpful

**Want to Share?**
- Submit to App Store/Play Store
- Share on GitHub
- Show off to friends!
