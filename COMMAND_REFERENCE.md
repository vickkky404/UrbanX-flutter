# 🚀 Quick Command Reference

## Essential Commands

### Initial Setup
```bash
# Navigate to project
cd D:\B-PLAN\Android

# Clean and get dependencies
flutter clean
flutter pub get

# Verify no errors
flutter analyze
```

### Running the App
```bash
# Run on emulator/device
flutter run

# Run in release mode
flutter run --release

# Run with verbose output
flutter run -v
```

### Building
```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build app bundle (for Google Play)
flutter build appbundle --release
```

### Debugging
```bash
# View logs
flutter logs

# Attach to running app
flutter attach

# Hot reload (after making changes)
# Press 'r' in terminal while app is running
```

### Useful Tools
```bash
# Check for deprecated APIs
flutter doctor

# Get Android build info
gradlew.bat signingReport

# Format code
dart format lib/

# Fix common issues
dart fix --apply
```

---

## Firebase Commands

### Authentication
```bash
# Test Firebase setup
flutter run

# Check Firebase initialization in logs
# Look for "Firebase initialized successfully"
```

---

## Location & Map Commands

### Get SHA-1 Fingerprint (for Google Maps)
```bash
# In Android folder
cd android
gradlew.bat signingReport
cd ..

# Look for:
# SHA1: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

### Test Location
```bash
# Enable mock location on emulator
# Go to: Settings > About phone > tap Build number 7 times
# Settings > Developer options > Mock location app
# Select your app

# Or use command
adb shell content insert --uri content://settings/secure --bind name:s:allow_mock_location --bind value:i:1
```

---

## Project File Locations

### Important Files
```
D:\B-PLAN\Android\
├── pubspec.yaml                    # Dependencies
├── lib/main.dart                   # Entry point
├── lib/core/router/app_route.dart  # Routes
├── android/app/src/main/AndroidManifest.xml  # Manifest
└── lib/features/dashboard/screens/home_screen.dart  # Home
```

### Documentation
```
D:\B-PLAN\Android\
├── START_HERE.md                   # 👈 Start here!
├── GOOGLE_MAPS_SETUP.md           # API key setup
├── QUICK_START_MAP.md             # Quick reference
├── MAP_IMPLEMENTATION.md          # Technical details
├── CODE_STRUCTURE.md              # Architecture
├── CODE_SNIPPETS_REFERENCE.md     # Code examples
├── FINAL_CHECKLIST.md             # Testing checklist
└── IMPLEMENTATION_STATUS.md       # Status report
```

---

## Troubleshooting Commands

### App Won't Start
```bash
flutter clean
flutter pub get
flutter run
```

### API Connection Issues
```bash
# Check internet connectivity
# Restart emulator or device
# Check Firebase configuration
```

### Location Not Working
```bash
# On emulator: Enable mock location
# On device: Check Settings > Privacy > Location
# Restart app
flutter run
```

### Build Errors
```bash
# Full rebuild
flutter clean
flutter pub get
flutter pub upgrade

# Rebuild Android
cd android
gradlew.bat clean
cd ..
flutter run
```

### Map Not Displaying
```bash
# Verify API key in AndroidManifest.xml
# Check internet connectivity
# Verify SHA-1 matches in Google Cloud Console
# Restart app: flutter run
```

---

## Useful ADB Commands

```bash
# List connected devices
adb devices

# View logcat
adb logcat

# Clear app data
adb shell pm clear com.apl.urbanx.urban_x

# Take screenshot
adb shell screencap -p /sdcard/screenshot.png

# Install APK
adb install path/to/app.apk

# Uninstall app
adb uninstall com.apl.urbanx.urban_x
```

---

## Git Commands (if using version control)

```bash
# Check status
git status

# Add changes
git add .

# Commit
git commit -m "Map implementation complete"

# Push
git push origin main
```

---

## Environment Variables

### Windows PowerShell Setup
```bash
# If Flutter not recognized:
# Add to PATH:
# C:\Users\[YourUsername]\AppData\Local\Pub\Cache\bin
# C:\Program Files\Android\android-sdk\cmdline-tools\latest\bin

# Verify installation
flutter --version
dart --version
```

---

## File Editing Shortcuts

### Android Manifest
```
File: android/app/src/main/AndroidManifest.xml
Find: YOUR_GOOGLE_MAPS_API_KEY
Replace with: Your actual API key from Google Cloud
```

### pubspec.yaml
```
File: pubspec.yaml
Location: Lines 31-48
Contains: All dependencies
```

### App Routes
```
File: lib/core/router/app_route.dart
Contains: All route definitions
Main route: '/' → SplashScreen
Home route: '/home' → HomeScreen
```

### Home Screen
```
File: lib/features/dashboard/screens/home_screen.dart
Lines: ~500 total
Features: Map, location, ride options
```

---

## Performance Monitoring

### Check App Performance
```bash
# Monitor FPS and memory
flutter run --profile

# Observe performance issues
# Press 'o' to toggle on-screen performance overlay
```

### Memory Usage
```bash
# In DevTools (web: chrome://inspect)
# Memory tab shows heap usage
# Watch for memory leaks
```

---

## Testing Commands

### Unit Tests
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Generate coverage
flutter test --coverage
```

### Widget Tests
```bash
# Run widget tests
flutter test test/

# View test output
flutter test -v
```

---

## Common Error Solutions

| Error | Solution |
|-------|----------|
| "No devices connected" | Connect emulator or device, check `adb devices` |
| "Map not showing" | Add Google Maps API key to AndroidManifest.xml |
| "Location permission denied" | Grant permission in app or device settings |
| "Build failed" | Run `flutter clean && flutter pub get` |
| "Firebase not initialized" | Check firebase_options.dart and internet |
| "API key invalid" | Verify key in Google Cloud Console |
| "Gradle error" | Update Android SDK and gradle |

---

## Development Workflow

### Daily Workflow
```bash
# Start day
flutter clean
flutter pub get
flutter run

# During development
# Press 'r' for hot reload
# Press 'R' for hot restart
# Press 'q' to quit

# End day
git add .
git commit -m "Your message"
git push
```

### Building for Release
```bash
# Prepare
flutter clean
flutter pub get

# Build
flutter build apk --release

# Or for Play Store
flutter build appbundle --release

# Output location:
# APK: build/app/outputs/flutter-apk/app-release.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

---

## Documentation Locations

### In IDE
- Hover over any method/class
- Press Ctrl+/ for documentation
- Cmd+Click to go to definition

### Online
- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Firebase: https://firebase.flutter.dev/
- Google Maps: https://pub.dev/packages/google_maps_flutter

---

## Quick Fixes

### Fix All Warnings
```bash
flutter analyze
dart fix --apply
```

### Update Dependencies
```bash
flutter pub upgrade
flutter pub get
```

### Format Code
```bash
dart format lib/ -r
```

### Check Outdated Packages
```bash
flutter pub outdated
```

---

## Keyboard Shortcuts (flutter run)

| Key | Action |
|-----|--------|
| r | Hot reload |
| R | Hot restart |
| h | Show help |
| w | Toggle widget inspector |
| o | Toggle performance overlay |
| p | Toggle debug painting |
| i | Toggle verbose logging |
| q | Quit |

---

## Final Checklist Before Deployment

```bash
# 1. Clean build
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Verify no errors
flutter analyze

# 4. Run tests
flutter test

# 5. Build
flutter build apk --release

# 6. Verify APK
ls -la build/app/outputs/flutter-apk/

# 7. Deploy!
```

---

## Emergency Commands

```bash
# If everything breaks:
flutter clean
flutter pub get
flutter run

# If still broken:
rm -r .dart_tool
rm pubspec.lock
flutter pub get
flutter run

# If REALLY broken:
# Reinstall Flutter from https://flutter.dev
```

---

## Useful Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Dart Language**: https://dart.dev
- **Firebase Flutter**: https://firebase.flutter.dev
- **Google Maps Flutter**: https://pub.dev/packages/google_maps_flutter
- **Riverpod**: https://riverpod.dev
- **GoRouter**: https://pub.dev/packages/go_router

---

## Support Channels

- **Flutter Issues**: https://github.com/flutter/flutter/issues
- **Firebase Support**: https://stackoverflow.com/questions/tagged/firebase
- **Stack Overflow**: https://stackoverflow.com/questions/tagged/flutter

---

**Last Updated**: March 26, 2026  
**Version**: 1.0.0  

Save this for quick reference! 📌

