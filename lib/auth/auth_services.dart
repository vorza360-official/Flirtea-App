import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // expose the auth stream (used by AuthWrapper)
  Stream<User?> get userStream => _auth.authStateChanges();

  // current user (null if not logged in)
  User? get currentUser => _auth.currentUser;

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // 1. trigger the Google UI
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // user cancelled

      // 2. obtain auth details
      final googleAuth = await googleUser.authentication;

      // 3. create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Google sign-in failed');
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error: $e');
      return null;
    }
  }

  // In AuthService class
  Future<String?> getCurrentUserEmail() async {
    await Future.delayed(Duration(milliseconds: 500)); // Small delay
    return _auth.currentUser?.email;
  }

  /// Sign-out (Google + Firebase)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
