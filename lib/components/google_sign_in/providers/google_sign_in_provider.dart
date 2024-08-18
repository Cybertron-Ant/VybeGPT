import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/google_sign_in/models/google_user_model.dart';
import 'package:towers/components/google_sign_in/providers/google_user_provider.dart';


/// a provider class for handling Google Sign-In authentication
class GoogleSignInProvider {

  /// an instance of [FirebaseAuth] to interact with Firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// an instance of [GoogleSignIn] to handle Google Sign-In operations
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// signs in the user using Google Sign-In and returns a [User] object
  /// triggers the Google Sign-In flow, obtains the authentication details,
  /// creates a credential, and uses it to sign in to Firebase. If the user
  /// cancels the sign-in or an error occurs, it returns null
  /// [context] is used to show error messages if sign-in fails
  Future<User?> signInWithGoogle(BuildContext context) async {

    try {

      // trigger the Google Sign-In authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // the user canceled the sign-in, return null
        return null;
      } // end IF

      // get the authentication details from the Google Sign-In request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // initialize a new authentication credential using the Google authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ); // end 'credential'

      // sign in to Firebase using the Google credential & obtain a 'UserCredential'
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // get the user from Firebase
      final User? user = userCredential.user;

      if (user != null && context.mounted) {
        // store the user's email and profile photo URL in the 'GoogleUserProvider'
        Provider.of<GoogleUserProvider>(context, listen: false).setUser(
          GoogleUserModel(
            email: user.email!,
            profilePhoto: user.photoURL,
          ),
        );
      }

      // return the 'user' object associated with the sign-in
      return user;

    } catch (e) {

      // print the error to the console
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }

      if (context.mounted) {
        // show an error message to the user if sign-in fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in with Google: $e'),
            backgroundColor: Colors.red[300],
          ),
        ); // end 'showSnackBar'
      }

      // return null if an error occurs during sign-in
      return null;

    } // end 'CATCH'

  } // end 'signInWithGoogle' asynchronous method

  /// signs out the user from both Google and Firebase
  /// calls sign-out methods for both 'GoogleSignIn' & 'FirebaseAuth' instances
  /// to ensure the user is fully signed out
  Future<void> signOut(BuildContext context) async {

    try {

      // sign out from Google account
      await _googleSignIn.signOut();

      // sign out from Firebase
      await _auth.signOut();

      if (context.mounted) {
        // clear user data from 'GoogleUserProvider'
        Provider.of<GoogleUserProvider>(context, listen: false).clearUser();
      }
    } catch (e) {

      // handle any exceptions that occur during the sign-out process
      if (kDebugMode) {
        print('Error signing out from Google: $e');
      }
    }

  } // end 'signOut' asynchronous method

} // end 'GoogleSignInProvider' class