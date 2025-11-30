import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // For iOS, GoogleSignIn will automatically read from GoogleService-Info.plist
  late final GoogleSignIn _googleSignIn;
  
  GoogleAuthService() {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      // On iOS, the clientId is automatically read from GoogleService-Info.plist
      // On Android, it reads from the google-services.json file
    );
  }

  /// Check if Google Sign-In is available on this device
  Future<bool> isGoogleSignInAvailable() async {
    try {
      print('📱 Checking Google Sign-In availability...');
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        print('📱 Running on iOS - checking Google Sign-In configuration');
      }
      return true;
    } catch (e) {
      print('❌ Google Sign-In service not available: $e');
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      print('🔍 Starting Google Sign-In...');
      
      // Try interactive sign-in
      print('🔍 Attempting interactive sign-in...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ Google Sign-In cancelled by user');
        return null;
      }

      print('✅ Google user obtained: ${googleUser.email}');
      print('📱 User ID: ${googleUser.id}');
      print('📱 Display Name: ${googleUser.displayName}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('🔐 Getting authentication tokens...');
      print('   Access Token: ${googleAuth.accessToken != null ? "✅ Present" : "❌ Missing"}');
      print('   ID Token: ${googleAuth.idToken != null ? "✅ Present" : "❌ Missing"}');

      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        print('❌ No authentication tokens received');
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔑 Signing in with Firebase...');
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      print('✅ Google Sign-In successful: ${userCredential.user?.email}');
      return userCredential.user;
    } on Exception catch (e) {
      print('❌ Google Sign-In error: $e');
      print('❌ Error type: ${e.runtimeType}');
      
      String errorMessage = e.toString().toLowerCase();
      
      if (errorMessage.contains('network')) {
        print('❌ Network error - check internet connection');
      } else if (errorMessage.contains('canceled') || errorMessage.contains('cancelled')) {
        print('❌ Sign-in was cancelled');
      } else if (errorMessage.contains('sign_in_failed')) {
        print('❌ Sign-in failed - check GoogleService-Info.plist configuration');
        print('   Make sure CLIENT_ID and REVERSED_CLIENT_ID are correct');
      } else if (errorMessage.contains('configuration') || errorMessage.contains('client id')) {
        print('❌ Configuration error - invalid CLIENT_ID in GoogleService-Info.plist');
        print('   Download the correct file from Firebase Console');
      } else if (errorMessage.contains('missing plugin')) {
        print('❌ Plugin not properly installed');
      } else if (errorMessage.contains('not authorized') || errorMessage.contains('unauthorized')) {
        print('❌ OAuth client not authorized - check Firebase Console');
      }
      
      rethrow; // Re-throw to let UI handle it
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('✅ Successfully signed out');
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }
}
