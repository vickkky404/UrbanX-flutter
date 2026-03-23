import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Authentication State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current User Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      isEmailVerified: user.emailVerified,
      createdAt: DateTime.now(),
    );
  }
  return null;
});

// Sign Up Provider
final signUpProvider = FutureProvider.family<UserModel, ({
  String email,
  String password,
  String displayName,
})>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signUpWithEmail(
    email: params.email,
    password: params.password,
    displayName: params.displayName,
  );
});

// Sign In Provider
final signInProvider = FutureProvider.family<UserModel, ({
  String email,
  String password,
})>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signInWithEmail(
    email: params.email,
    password: params.password,
  );
});

// Google Sign In Provider
final googleSignInProvider = FutureProvider<UserModel>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signInWithGoogle();
});

// Sign Out Provider
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signOut();
});

// Password Reset Provider
final passwordResetProvider =
    FutureProvider.family<void, String>((ref, email) async {
  final authService = ref.watch(authServiceProvider);
  return authService.sendPasswordResetEmail(email: email);
});

