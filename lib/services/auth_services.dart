import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    // Configure Google Sign-In to force account picker
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    // Sign out of any previously signed-in accounts
    await googleSignIn.signOut();

    // Begin interactive sign-in process with account picker
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();

    if (gUser != null) {
      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Check if ID token or access token is available
      if (gAuth.idToken != null || gAuth.accessToken != null) {
        // Create credentials for the user
        final credential = GoogleAuthProvider.credential(
          idToken: gAuth.idToken,
          accessToken: gAuth.accessToken,
        );

        // Sign in with the obtained credentials
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        // Missing ID token and access token
        throw Exception("Failed to obtain ID token or access token.");
      }
    } else {
      // Google sign-in was canceled or failed
      throw Exception("Google sign-in was canceled or failed.");
    }
  }
}
