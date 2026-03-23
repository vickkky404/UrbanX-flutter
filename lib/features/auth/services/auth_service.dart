import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late SharedPreferences _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      // Ignore initialization error
    }
  }

  // Get current user
  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  // Get current user stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      
      // Update display name
      await user.updateDisplayName(displayName);
      await user.reload();

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoURL: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      // Save to local storage
      await _saveUserLocally(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoURL: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      // Save to local storage
      await _saveUserLocally(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoURL: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      // Save to local storage
      await _saveUserLocally(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      try {
        await _prefs.remove('user_data');
      } catch (_) {
        // Ignore if prefs not initialized
      }
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Get saved user from local storage
  UserModel? getSavedUser() {
    try {
      final userJson = _prefs.getString('user_data');
      if (userJson != null) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(userJson as Map),
        );
      }
    } catch (e) {
      // Error retrieving saved user
    }
    return null;
  }

  // Save user to local storage
  Future<void> _saveUserLocally(UserModel user) async {
    try {
      await _prefs.setString('user_data', user.toJson().toString());
    } catch (e) {
      // Error saving user locally
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-credential':
        return 'Invalid credentials provided.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}

