# Mobile Testing Guide for Cipher Academy

## Testing on Physical iPhone

### Prerequisites
- Mac with Xcode installed ✅
- iPhone with USB cable
- iOS 16 or later recommended

### Setup Steps

#### 1. Configure Xcode Command Line Tools
Run these commands in Terminal (requires password):

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```

Verify with:
```bash
xcodebuild -version
```

#### 2. Connect and Trust iPhone

1. **Connect iPhone** to Mac via USB cable
2. **Unlock your iPhone**
3. **Trust popup** will appear - tap "Trust"
4. **Enter iPhone passcode** if prompted

#### 3. Enable Developer Mode (iOS 16+)

On your iPhone:
1. Go to **Settings**
2. Tap **Privacy & Security**
3. Scroll to **Developer Mode**
4. Toggle **ON**
5. **Restart** your iPhone when prompted

#### 4. Verify Connection

```bash
flutter devices
```

You should see output like:
```
iPhone 15 (mobile) • 00008030-XXXXX • ios • iOS 17.0
```

#### 5. Run the App

```bash
cd /Users/dovewaymacm4/Documents/FlutterProjects/CipherAcademy
flutter run
```

Flutter will:
- Build the iOS app
- Install it on your iPhone
- Launch Cipher Academy

### First Time Setup Notes

**On first run, you may see:**
```
Untrusted Developer
This app cannot be opened because the developer cannot be verified
```

**To fix:**
1. On iPhone: **Settings** → **General** → **VPN & Device Management**
2. Find your Apple ID or developer certificate
3. Tap **Trust**
4. Run `flutter run` again

### Troubleshooting

#### iPhone Not Detected

**Problem**: `flutter devices` doesn't show iPhone

**Solutions**:
1. Check cable connection (try different cable/port)
2. Unlock iPhone
3. Trust the computer popup
4. Enable Developer Mode
5. Restart both iPhone and Mac
6. Try: `idevice_id -l` (if installed)

#### "Unable to find utility 'xcodebuild'"

**Solution**:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### Build Failed - "Code Signing Required"

**Solution**:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Go to Signing & Capabilities
4. Select your Apple ID team
5. Try `flutter run` again

Or use automatic signing:
```bash
open ios/Runner.xcworkspace
```
Then enable "Automatically manage signing"

#### "Failed to verify code signature"

**Solution**:
Clean and rebuild:
```bash
flutter clean
cd ios
rm -rf Pods
pod install
cd ..
flutter run
```

#### App Crashes on Launch

**Check console output**:
```bash
flutter run --verbose
```

Common issues:
- Missing permissions in Info.plist
- Deployment target mismatch
- Font loading issues on iOS

---

## Testing on iOS Simulator

If you don't have a physical iPhone, use the simulator:

### 1. Open Simulator

```bash
open -a Simulator
```

Or from Xcode:
**Xcode** → **Open Developer Tool** → **Simulator**

### 2. Choose Device

In Simulator:
**File** → **Open Simulator** → **iOS 17.x** → **iPhone 15**

Recommended for testing:
- **iPhone 15** (latest, most common)
- **iPhone SE** (small screen testing)
- **iPhone 15 Pro Max** (large screen)

### 3. Run the App

```bash
flutter run
```

Flutter will automatically detect the simulator and deploy.

### 4. Test Features

Test both portrait and landscape:
- **Rotate**: Cmd + Arrow keys
- **Home button**: Cmd + Shift + H
- **Screenshot**: Cmd + S
- **Shake**: Ctrl + Cmd + Z

---

## Testing on Android Phone

### Prerequisites
- Android phone with USB debugging enabled
- USB cable

### Setup Steps

#### 1. Enable Developer Options

On your Android phone:
1. **Settings** → **About Phone**
2. Tap **Build Number** 7 times
3. You'll see "You are now a developer!"

#### 2. Enable USB Debugging

1. **Settings** → **System** → **Developer Options**
2. Toggle **USB Debugging** ON
3. Tap **OK** on warning

#### 3. Connect Phone

1. Connect via USB cable
2. **Allow USB debugging** popup - tap OK
3. Check "Always allow from this computer"

#### 4. Verify Connection

```bash
flutter devices
```

Should see:
```
SM G991B (mobile) • XXXXXXXXX • android-arm64 • Android 13
```

#### 5. Run the App

```bash
flutter run
```

### Android Troubleshooting

#### Phone Not Detected

**Solutions**:
1. Check USB cable (use data cable, not charging-only)
2. Try different USB port
3. Enable USB debugging
4. Install Android USB drivers (Windows)
5. Run: `adb devices`

#### "adb: device unauthorized"

**Solution**:
1. Disconnect phone
2. Revoke USB debugging authorizations on phone
3. Reconnect and accept popup

---

## Testing Web Version on Mobile

### Option 1: Local Network Access

**Build and serve**:
```bash
flutter build web --release
cd build/web
python3 -m http.server 8000
```

**Access from phone**:
1. Find Mac's IP: `ifconfig | grep "inet " | grep -v 127.0.0.1`
2. On phone browser: `http://YOUR_MAC_IP:8000`

### Option 2: Deploy to Firebase Hosting

**Quick deploy** (free):
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Build and deploy
flutter build web --release
firebase deploy --only hosting
```

Access from phone at: `https://your-app.web.app`

### Option 3: GitHub Pages

**Deploy to GitHub Pages**:
```bash
flutter build web --release --base-href "/CipherAcademy/"

# Push to gh-pages branch
cd build/web
git init
git add .
git commit -m "Deploy"
git branch -M gh-pages
git remote add origin YOUR_REPO_URL
git push -f origin gh-pages
```

Access at: `https://username.github.io/CipherAcademy/`

---

## Performance Testing on Mobile

### Key Metrics to Check

1. **Splash Screen Load Time** - Should be < 3 seconds
2. **Puzzle Load Time** - Should be instant
3. **Hint System Response** - Should be instant
4. **Navigation Speed** - Should be smooth
5. **Memory Usage** - Monitor for leaks

### Tools

**Flutter DevTools**:
```bash
flutter run --profile
```
Then open DevTools in browser

**Performance Overlay**:
Add to app during testing:
```dart
MaterialApp(
  showPerformanceOverlay: true,
  // ...
)
```

---

## Quick Testing Checklist

### ✅ Core Features
- [ ] Splash screen displays correctly
- [ ] Home screen loads with stats
- [ ] Chapter cards clickable
- [ ] Puzzle opens and displays
- [ ] Answer input works
- [ ] Correct answer shows success
- [ ] Incorrect answer shows error
- [ ] Hint system works
- [ ] Timer counts up
- [ ] Settings screen opens
- [ ] Premium dialog displays

### ✅ Mobile-Specific
- [ ] Touch gestures work smoothly
- [ ] Keyboard appears for text input
- [ ] Keyboard doesn't cover input field
- [ ] Navigation buttons work
- [ ] Back button returns to previous screen
- [ ] Portrait mode looks good
- [ ] Landscape mode (if supported)
- [ ] Safe areas respected (notch, home indicator)

### ✅ Visual
- [ ] Text is readable (not too small)
- [ ] Buttons are tap-friendly (min 44px)
- [ ] Colors look good on phone screen
- [ ] No UI overflow or clipping
- [ ] Scrolling is smooth
- [ ] Dark Academia theme looks good

### ✅ Performance
- [ ] No lag when navigating
- [ ] Animations are smooth (60fps)
- [ ] No memory leaks (long session)
- [ ] App doesn't crash
- [ ] Loads quickly after install

---

## Current Status

**What's Working:**
✅ Chrome web version running
✅ All 11 puzzles functional
✅ Progress tracking
✅ Settings and premium

**Next Steps:**
1. Configure Xcode command line tools
2. Connect iPhone or launch simulator
3. Run `flutter run`
4. Test on mobile!

---

**Need Help?**
- Check `flutter doctor` for issues
- See error logs: `flutter run --verbose`
- iOS logs: Console.app (filter by device)
- Android logs: `adb logcat`
