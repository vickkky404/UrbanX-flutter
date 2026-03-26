# UrbanX Authentication System - Implementation Guide

## Overview
This document provides a comprehensive guide to the authentication system implemented in the UrbanX Flutter application.

## Architecture

### Components Implemented

#### 1. **User Model** (`lib/features/auth/models/user_model.dart`)
- Core data model representing a user in the application
- Properties:
  - `uid`: Unique identifier from Firebase
  - `email`: User's email address
  - `phoneNumber`: Optional phone number
  - `displayName`: User's full name
  - `photoURL`: Profile picture URL
  - `isEmailVerified`: Email verification status
  - `createdAt`: Account creation timestamp

#### 2. **Authentication Service** (`lib/features/auth/services/auth_service.dart`)
- Handles all Firebase authentication operations
- Features:
  - Email/Password sign-up and sign-in
  - Google Sign-In integration
  - Password reset functionality
  - User session management
  - Local storage of user data
  - Comprehensive error handling

#### 3. **Riverpod Providers** (`lib/features/auth/providers/auth_provider.dart`)
- State management using Flutter Riverpod
- Providers:
  - `authServiceProvider`: Main auth service instance
  - `authStateProvider`: Stream of authentication state changes
  - `currentUserProvider`: Current logged-in user data
  - `signUpProvider`: Sign-up operation
  - `signInProvider`: Sign-in operation
  - `googleSignInProvider`: Google authentication
  - `signOutProvider`: Sign-out operation
  - `passwordResetProvider`: Password reset operation

#### 4. **Authentication Widgets** (`lib/features/auth/widgets/auth_widgets.dart`)
- Reusable UI components:
  - `CustomTextFormField`: Text input with validation
  - `CustomButton`: Primary and outlined buttons
  - `SocialAuthButton`: Social login buttons
  - `DividerWithText`: Section divider

#### 5. **Screens**
- **Login Screen** (`lib/features/auth/screens/login_screen.dart`)
  - Email/password authentication
  - Sign-up navigation
  - Password reset link
  - Form validation

- **Sign Up Screen** (`lib/features/auth/screens/signup_screen.dart`)
  - User registration
  - Form validation
  - Password confirmation
  - Account creation

- **Splash Screen** (`lib/features/splash/screens/splash_screen.dart`)
  - App initialization
  - Auto-navigation based on auth state
  - Animated branding

- **Dashboard Screen** (`lib/features/dashboard/screens/dashboard_screen.dart`)
  - Home screen after login
  - Quick actions
  - User welcome message
  - Sign-out functionality

- **Profile Screen** (`lib/features/profile/screens/profile_screen.dart`)
  - Display user information
  - Edit profile placeholder
  - Change password placeholder

## Firebase Setup Instructions

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project for UrbanX
3. Enable Google Sign-In in Firebase Console

### Step 2: Configure Android
1. Add your Android app to the Firebase project
2. Download `google-services.json`
3. Place it in `android/app/`

### Step 3: Configure iOS (if needed)
1. Add your iOS app to the Firebase project
2. Download `GoogleService-Info.plist`
3. Add it to your Xcode project

### Step 4: Update Firebase Options
Update `lib/firebase_options.dart` with your actual Firebase configuration:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  databaseURL: 'YOUR_DATABASE_URL',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);
```

## Google Sign-In Setup

### Android Configuration
1. Open Firebase Console → Settings
2. Copy your Web Client ID
3. In Android Studio, run: `flutterfire configure`
4. This automatically sets up Google Sign-In for Android

### Add Google Sign-In UI (Optional)
- Add Google icon assets in `assets/icons/`
- Uncomment the `SocialAuthButton` in login/signup screens

## Navigation Flow

```
Splash Screen (3 second delay)
    ↓
Auth State Check
    ├─ Not Logged In → Login Screen
    └─ Logged In → Dashboard Screen
    
From Login Screen:
    ├─ Sign In → Dashboard
    └─ Go to Sign Up → Sign Up Screen

From Dashboard:
    ├─ Profile → Profile Screen
    ├─ Book Ride → Coming Soon
    └─ Sign Out → Login Screen
```

## Usage Examples

### Sign Up
```dart
final user = await ref.read(
  signUpProvider(
    (
      email: 'user@example.com',
      password: 'password123',
      displayName: 'John Doe',
    ),
  ).future,
);
```

### Sign In
```dart
final user = await ref.read(
  signInProvider(
    (
      email: 'user@example.com',
      password: 'password123',
    ),
  ).future,
);
```

### Get Current User
```dart
final currentUser = ref.watch(currentUserProvider);
currentUser.whenData((user) {
  if (user != null) {
    print('Logged in as: ${user.displayName}');
  }
});
```

### Sign Out
```dart
await ref.read(signOutProvider.future);
```

## Error Handling

The authentication service provides user-friendly error messages:
- Weak password
- Email already in use
- Invalid email format
- User not found
- Wrong password
- Email verification required

## Testing

Run tests:
```bash
flutter test
```

Run analysis:
```bash
flutter analyze
```

## Dependencies

Key packages used:
- `firebase_auth`: Firebase authentication
- `google_sign_in`: Google Sign-In
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `shared_preferences`: Local storage
- `hive`: Local database (for future use)

## Security Considerations

1. **Password Storage**: Never store passwords locally. Firebase handles this securely.
2. **Token Management**: Firebase automatically manages authentication tokens.
3. **Email Verification**: Optional verification for enhanced security.
4. **Google Sign-In**: Secure OAuth flow with Firebase.
5. **Local Storage**: Sensitive data is not stored locally; only user metadata.

## Future Enhancements

- [ ] Phone number authentication
- [ ] Multi-factor authentication (MFA)
- [ ] Social login with Apple, Facebook
- [ ] Biometric authentication
- [ ] User profile editing
- [ ] Password change functionality
- [ ] Account deletion
- [ ] OAuth token refresh handling

## Troubleshooting

### Firebase Not Initializing
- Ensure `firebase_options.dart` has correct configuration
- Check `google-services.json` is in `android/app/`
- Run `flutterfire configure` again

### Google Sign-In Not Working
- Verify Google Sign-In is enabled in Firebase Console
- Check Web Client ID is correct
- Ensure SHA-1 fingerprint matches in Firebase Console

### Tests Failing
- Clear build: `flutter clean`
- Get dependencies: `flutter pub get`
- Run tests: `flutter test`

## File Structure

```
lib/features/auth/
├── models/
│   └── user_model.dart
├── services/
│   └── auth_service.dart
├── providers/
│   └── auth_provider.dart
├── widgets/
│   └── auth_widgets.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── profile_screen.dart
```

## Next Steps

After authentication is working:
1. **Phase 2**: Implement map integration for ride location selection
2. **Phase 3**: Real-time driver tracking and live updates
3. **Phase 4**: Payment integration
4. **Phase 5**: Rating and review system
5. **Phase 6**: Push notification for rider and driver communication

---

For questions or issues, refer to:
- [Firebase Documentation](https://firebase.flutter.dev/)
- [Flutter Riverpod Docs](https://riverpod.dev/)
- [GoRouter Docs](https://pub.dev/packages/go_router)

