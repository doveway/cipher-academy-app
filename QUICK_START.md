# Quick Start - Deploy Cipher Academy to iPhone

## ✅ Current Status
- iPhone detected: **DoveiPhone17** (iOS 26.1)
- Flutter working
- Just need CocoaPods

## 🚀 Deploy to Your iPhone (3 Steps)

### Step 1: Install CocoaPods
```bash
sudo gem install cocoapods
```
Wait 2-3 minutes for installation.

### Step 2: Install iOS Dependencies
```bash
cd /Users/dovewaymacm4/Documents/FlutterProjects/CipherAcademy
cd ios
pod install
cd ..
```

### Step 3: Run on iPhone
```bash
flutter run -d DoveiPhone17
```

That's it! The app will build and launch on your iPhone.

---

## 🔧 If You See "Code Signing" Errors

On first run, you might need to configure signing:

```bash
open ios/Runner.xcworkspace
```

In Xcode:
1. Select **Runner** in left sidebar
2. Go to **Signing & Capabilities** tab
3. Check **Automatically manage signing**
4. Select your **Team** (your Apple ID)
5. Close Xcode
6. Run `flutter run -d DoveiPhone17` again

---

## 📱 Alternative: Test on Simulator (Faster)

No code signing needed for simulator:

```bash
flutter run -d "iPhone 16e"
```

This launches instantly without any setup!

---

## 🎮 What You'll See

1. **Build process** (first time: 3-5 minutes)
2. **App installs** on your iPhone
3. **Splash screen** with Cipher Academy logo
4. **Home screen** with your progress and chapters
5. **Play puzzles** on your iPhone!

---

## 🐛 Troubleshooting

### "Failed to build iOS app"
```bash
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter run -d DoveiPhone17
```

### "Untrusted Developer" on iPhone
1. iPhone: Settings → General → VPN & Device Management
2. Find your Apple ID
3. Tap Trust
4. Try launching app again

### Build is slow
First build takes 3-5 minutes. Subsequent builds are much faster (30-60 seconds).

---

## 📊 Answers for Testing

### Chapter 1 Puzzles:
1. **Fibonacci**: `21`
2. **Geometric**: `162`
3. **Symbol**: `◇`
4. **Caesar**: `HELLO`
5. **Variable**: `6`

### Chapter 2 Puzzles:
6. **Substitution**: `HELLO WORLD`
7. **Book Code**: `TJL`
8. **Prime Numbers**: `17`
9. **Venn Diagram**: `2,8`
10. **Balance Scale**: `6`
11. **Librarian's Riddle**: `36`

---

## ⚡ Hot Reload

While app is running on iPhone:
- Press **`r`** in terminal for hot reload (instant updates!)
- Press **`R`** for hot restart
- Press **`q`** to quit

Make code changes, press `r`, and see them instantly on your iPhone!

---

**Current Devices Available:**
- ✅ DoveiPhone17 (Physical iPhone - iOS 26.1)
- ✅ iPhone 16e (Simulator)
- ✅ macOS Desktop
- ✅ Chrome Browser

Choose any device with `flutter run -d DEVICE_NAME`
