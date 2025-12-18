# Cipher Academy - Setup Guide

This guide will help you set up and run Cipher Academy on your development machine.

## Prerequisites

### 1. Install Flutter

#### macOS
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:$HOME/development/flutter/bin"

# Reload shell configuration
source ~/.zshrc  # or source ~/.bash_profile

# Verify installation
flutter doctor
```

#### Alternative: Using Homebrew
```bash
brew install --cask flutter
flutter doctor
```

### 2. Install Xcode (for iOS development on Mac)
1. Download Xcode from the Mac App Store
2. Install Xcode command line tools:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```
3. Accept Xcode license:
   ```bash
   sudo xcodebuild -license accept
   ```

### 3. Install Android Studio (for Android development)
1. Download from [developer.android.com](https://developer.android.com/studio)
2. Install Android SDK
3. Set up Android emulator

### 4. Install VS Code (Recommended IDE)
1. Download from [code.visualstudio.com](https://code.visualstudio.com/)
2. Install Flutter extension
3. Install Dart extension

## Project Setup

### 1. Navigate to Project Directory
```bash
cd /Users/dovewaymacm4/Documents/FlutterProjects/CipherAcademy
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Setup
```bash
flutter doctor -v
```

This command checks:
- Flutter installation
- Connected devices
- Android toolchain
- Xcode setup
- VS Code/Android Studio plugins

## Running the App

### On iOS Simulator (Mac only)
```bash
# List available simulators
flutter devices

# Open iOS simulator
open -a Simulator

# Run the app
flutter run
```

### On Android Emulator
```bash
# Start Android emulator from Android Studio
# Or via command line:
flutter emulators --launch <emulator_id>

# Run the app
flutter run
```

### On Chrome (Web)
```bash
flutter run -d chrome
```

### On Physical Device

#### iOS (requires Apple Developer account)
1. Connect iPhone via USB
2. Trust computer on device
3. Run: `flutter run`

#### Android
1. Enable Developer Mode on Android device
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

## Development Workflow

### Hot Reload
While app is running:
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

### Code Generation
If you add new models with JSON serialization:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting
```bash
flutter analyze
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/puzzle_test.dart

# Run with coverage
flutter test --coverage
```

## Building for Production

### Android APK
```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS (Mac only)
```bash
# Build for iOS
flutter build ios --release

# Then open in Xcode:
open ios/Runner.xcworkspace
```

### Web
```bash
flutter build web --release

# Output: build/web/
```

## Troubleshooting

### Flutter Doctor Issues

**Problem**: Xcode not found
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

**Problem**: Android licenses not accepted
```bash
flutter doctor --android-licenses
```

**Problem**: CocoaPods not installed (iOS)
```bash
sudo gem install cocoapods
pod setup
```

### Build Issues

**Problem**: Dependencies conflict
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

**Problem**: iOS build fails
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

**Problem**: Android build fails
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### Common Errors

**Error**: "Unable to locate Android SDK"
- Set ANDROID_HOME environment variable
- Add to ~/.zshrc or ~/.bash_profile:
  ```bash
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  ```

**Error**: "No devices found"
- Start emulator or connect physical device
- Run `flutter devices` to verify

**Error**: "CocoaPods not installed"
```bash
sudo gem install cocoapods
```

## Project Structure Quick Reference

```
lib/
├── main.dart              # Entry point
├── models/                # Data structures
├── screens/               # UI screens
├── widgets/               # Reusable components
├── services/              # Business logic
├── theme/                 # Styling
└── utils/                 # Helper functions

assets/
├── images/                # Game images
├── fonts/                 # Custom fonts
└── puzzles/              # Puzzle JSON data

test/                      # Unit tests
```

## VS Code Shortcuts

- `Cmd/Ctrl + .` - Quick fixes
- `F5` - Start debugging
- `Shift + F5` - Stop debugging
- `Cmd/Ctrl + Shift + P` - Command palette
- Type "Flutter: " to see Flutter commands

## Useful Commands

```bash
# Create new widget
flutter create --template=package <package_name>

# Format code
flutter format .

# Update dependencies
flutter pub upgrade

# Clean build files
flutter clean

# Check for outdated packages
flutter pub outdated

# Generate app icons (requires flutter_launcher_icons package)
flutter pub run flutter_launcher_icons:main
```

## Next Steps

1. **Run the app**: `flutter run`
2. **Explore the code**: Start with [lib/main.dart](lib/main.dart)
3. **Make changes**: Try modifying the theme in [lib/theme/app_theme.dart](lib/theme/app_theme.dart)
4. **Add puzzles**: Edit [lib/services/puzzle_service.dart](lib/services/puzzle_service.dart)
5. **Test on devices**: Try iOS, Android, and Web

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Material Design 3](https://m3.material.io/)
- [Provider Documentation](https://pub.dev/packages/provider)

## Support

If you encounter issues:
1. Check `flutter doctor` output
2. Review error messages carefully
3. Search for the error on [StackOverflow](https://stackoverflow.com/questions/tagged/flutter)
4. Check [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)

---

Happy coding! 🚀
