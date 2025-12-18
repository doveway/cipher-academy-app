# Sound Effects & Background Music Implementation Guide

## Current Status

❌ **Not Yet Implemented**

The sound effects and background music toggles in Settings are currently UI-only placeholders. They don't play any sounds yet.

## Why Not Implemented?

1. **No Audio Assets**: We don't have sound files yet
2. **Plugin Required**: Need to add audio playback plugin
3. **Asset Organization**: Need to structure audio assets properly
4. **Performance**: Audio requires careful memory management

## Implementation Plan

### Step 1: Add Audio Plugin

Add to `pubspec.yaml`:

```yaml
dependencies:
  audioplayers: ^5.2.0  # Or just_audio: ^0.9.36
```

### Step 2: Create Audio Assets

Create directory structure:
```
assets/
  audio/
    sfx/
      button_tap.mp3
      puzzle_correct.mp3
      puzzle_incorrect.mp3
      hint_reveal.mp3
      level_complete.mp3
      achievement_unlock.mp3
    music/
      theme_main.mp3
      theme_chapter1.mp3
      theme_chapter2.mp3
```

### Step 3: Update pubspec.yaml

```yaml
flutter:
  assets:
    - assets/audio/sfx/
    - assets/audio/music/
```

### Step 4: Create Audio Service

```dart
// lib/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _soundEffectsEnabled = true;
  bool _musicEnabled = false;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEffectsEnabled = prefs.getBool('sound_effects') ?? true;
    _musicEnabled = prefs.getBool('background_music') ?? false;

    // Configure music player
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _musicPlayer.setVolume(0.3);

    // Configure SFX player
    _sfxPlayer.setVolume(0.5);

    if (_musicEnabled) {
      playBackgroundMusic('theme_main.mp3');
    }
  }

  Future<void> playSoundEffect(String fileName) async {
    if (!_soundEffectsEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('audio/sfx/$fileName'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> playBackgroundMusic(String fileName) async {
    if (!_musicEnabled) return;

    try {
      await _musicPlayer.play(AssetSource('audio/music/$fileName'));
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  Future<void> resumeMusic() async {
    await _musicPlayer.resume();
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    _soundEffectsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_effects', enabled);
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('background_music', enabled);

    if (enabled) {
      playBackgroundMusic('theme_main.mp3');
    } else {
      stopMusic();
    }
  }

  void dispose() {
    _sfxPlayer.dispose();
    _musicPlayer.dispose();
  }
}
```

### Step 5: Integrate into App

Update `main.dart`:

```dart
final audioService = AudioService();
await audioService.initialize();

// Provide to widget tree
Provider<AudioService>(
  create: (_) => audioService,
  dispose: (_, service) => service.dispose(),
  child: MyApp(),
)
```

### Step 6: Add Sound Effects to Actions

Example usage in puzzle screen:

```dart
// When answer is correct
context.read<AudioService>().playSoundEffect('puzzle_correct.mp3');

// When answer is wrong
context.read<AudioService>().playSoundEffect('puzzle_incorrect.mp3');

// When hint revealed
context.read<AudioService>().playSoundEffect('hint_reveal.mp3');

// When button tapped
context.read<AudioService>().playSoundEffect('button_tap.mp3');
```

### Step 7: Connect Settings UI

Update [lib/screens/settings_screen.dart](lib/screens/settings_screen.dart):

```dart
// Sound Effects Toggle (currently line 186-196)
ListTile(
  leading: const Icon(Icons.volume_up, color: AppTheme.brass),
  title: const Text('Sound Effects'),
  trailing: Consumer<AudioService>(
    builder: (context, audioService, child) {
      return Switch(
        value: audioService.soundEffectsEnabled,
        onChanged: (value) {
          audioService.setSoundEffectsEnabled(value);
          // Play test sound
          if (value) {
            audioService.playSoundEffect('button_tap.mp3');
          }
        },
        activeColor: AppTheme.brass,
      );
    },
  ),
),

// Background Music Toggle (currently line 197-207)
ListTile(
  leading: const Icon(Icons.music_note, color: AppTheme.brass),
  title: const Text('Background Music'),
  trailing: Consumer<AudioService>(
    builder: (context, audioService, child) {
      return Switch(
        value: audioService.musicEnabled,
        onChanged: (value) {
          audioService.setMusicEnabled(value);
        },
        activeColor: AppTheme.brass,
      );
    },
  ),
),
```

## Where to Get Audio Assets

### Free Sound Effect Sources:
1. **Freesound.org** - Creative Commons sounds
2. **Zapsplat.com** - Free game sound effects
3. **Mixkit.co** - Free sound effects and music
4. **Kenney.nl** - Game assets including sounds

### Music Options:
1. **Incompetech** (Kevin MacLeod) - Royalty-free music
2. **Purple Planet Music** - Free game music
3. **Bensound** - Free music for games
4. **FreeSound** - Creative Commons tracks

### Recommended Sounds for Cipher Academy:

**Sound Effects:**
- Subtle "click" for button taps
- Soft "chime" for correct answers
- Gentle "buzz" for incorrect answers
- Light "whoosh" for revealing hints
- Triumphant "fanfare" for level completion
- Magical "sparkle" for achievements

**Background Music:**
- Mysterious, atmospheric ambient track
- Orchestral mystery theme (low volume)
- Subtle piano with strings
- Should be around 2-3 minutes, loopable

## Audio Best Practices

1. **Keep Files Small**: Use compressed formats (MP3/AAC)
2. **Normalize Volume**: All sounds should have similar volume levels
3. **Short SFX**: Sound effects should be < 2 seconds
4. **Loopable Music**: Background music should loop seamlessly
5. **Respect User Preferences**: Always check if audio is enabled before playing
6. **Graceful Degradation**: App should work fine without audio

## Memory Considerations

- Pre-load frequently used sound effects
- Don't keep multiple audio files in memory
- Dispose of audio players when not needed
- Use compressed formats to save space

## Testing Audio

```bash
# Test on iOS simulator (limited audio support)
flutter run -d simulator

# Test on physical device (full audio support)
flutter run -d <device-id>

# Test different volumes and scenarios
# - Muted device
# - Low volume
# - Other apps playing audio
# - Incoming calls/notifications
```

## Current Settings Screen

The toggles at lines 186-207 in [settings_screen.dart](lib/screens/settings_screen.dart) are currently hardcoded to `true` and `false` values with TODO comments. They need to be connected to a real AudioService once implemented.

---

## Quick Start (Minimal Implementation)

For a basic implementation, you can start with just:

1. Add `audioplayers` package
2. Create simple `AudioService` with on/off toggles
3. Add 3-4 key sound effects:
   - Correct answer
   - Wrong answer
   - Level complete
4. Optional: One ambient background track

This minimal version would make the app feel much more polished without being overwhelming to implement.

---

**Status**: Ready to implement when audio assets are available
**Priority**: Medium (nice-to-have, not critical for MVP)
**Estimated Time**: 2-4 hours with assets ready
