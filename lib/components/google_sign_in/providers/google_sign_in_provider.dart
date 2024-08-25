import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/google_sign_in/constants/constants.dart';
import 'package:towers/components/google_sign_in/models/google_user_model.dart';
import 'package:towers/components/google_sign_in/providers/google_user_provider.dart';


/// a provider class for handling Google Sign-In authentication
class GoogleSignInProvider with ChangeNotifier, WidgetsBindingObserver {

  /// an instance of [FirebaseAuth] to interact with Firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// an instance of [FirebaseFirestore] to interact with Firebase Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// an instance of [GoogleSignIn] to handle Google Sign-In operations
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// a private user object to store the current authenticated user
  User? _user;

  /// the currently signed-in user, or null if no user is signed in
  GoogleUserModel? _userModel;

  /// getter to retrieve the current user
  GoogleUserModel? get userModel => _userModel;

  /// getter for the current user
  User? get user => _user;

  /// getter for the user's email
  String? get userEmail => _user?.email;

  /// constructor to initialize the observer
  GoogleSignInProvider() {
    WidgetsBinding.instance.addObserver(this);
    _initializeCurrentUser();  // initialize the current user on app startup
  }

  /// initialize the current user from Firebase Auth
  Future<void> _initializeCurrentUser() async {
    _user = _auth.currentUser;

    if (_user != null) {
      _userModel = GoogleUserModel(
        email: _user!.email!,
        profilePhoto: _user!.photoURL,
        isOnline: true,
      );
      notifyListeners();
    }
  } // end '_initializeCurrentUser' method

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // the app is in the background
      updateOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      // the app is in the foreground
      updateOnlineStatus(true);
    }
  }

  /// updates the 'online' status of the user
  Future<void> updateOnlineStatus(bool isOnline) async {
    if (_user != null) {
      await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
        'isOnline': isOnline, // update 'online' status
        'lastOnline': DateTime.now(), // update last 'online' timestamp
      });
    }
  }

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

      try {

        // sign in to Firebase using the Google credential & obtain a 'UserCredential'
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        // get the user from Firebase
        _user = userCredential.user;

        if (_user != null && context.mounted) {
          // store the user's email and profile photo URL in the 'GoogleUserProvider'
          _userModel = GoogleUserModel(
            email: _user!.email!,
            profilePhoto: _user!.photoURL,
            isOnline: true,
          );
          Provider.of<GoogleUserProvider>(context, listen: false).setUser(_userModel!);

          // save the user's data in Firestore
          await _firestore.collection(Constants.usersCollection).doc(_user!.email).set({
            'email': _user!.email!,
            'profilePhoto': _user!.photoURL,
            'lastLogin': DateTime.now(),
            'isOnline': true, // set the user as 'online'
            'lastOnline': DateTime.now(), // save the last online timestamp
          }, SetOptions(merge: true));

          // notify listeners to update the UI
          notifyListeners();
        }

        // return the 'user' object associated with the sign-in
        return _user;

      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          final String email = e.email!;
          if (kDebugMode) {
            print('Account exists with a different credential for email: $email');
          }

          // fetch sign-in methods for the email
          final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);

          if (signInMethods.contains('password')) {
            if (kDebugMode) {
              print('Account exists with a different credential. Please sign in using the existing provider.');
            }
            // handle this case in the UI
          }

          // assuming user provides existing credentials
          final UserCredential existingUserCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: 'user-provided-password', // Replace with actual password
          );

          await existingUserCredential.user!.linkWithCredential(credential);

          _user = existingUserCredential.user;
        } else if (e.code == 'invalid-credential') {
          if (kDebugMode) {
            print('Invalid Google credential. Please check your token and try again.');
          }
        } else {
          if (kDebugMode) {
            print('Error signing in with Google: $e');
          }
        }
      }

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

    } // end 'CATCH'

    // return null if an exception occurs or the sign-in fails
    return null;

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

      // update the user's status to offline in Firestore after signing out
      if (_user != null) {
        await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
          'isOnline': false, // set the user as offline
          'lastOnline': DateTime.now(), // update last online timestamp
        });
      }

      // Clear user data from 'GoogleUserProvider'
      if (context.mounted) {
        // clear user data from 'GoogleUserProvider'
        Provider.of<GoogleUserProvider>(context, listen: false).clearUser();
      }

      // reset the private user object
      _user = null;

      // notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      // handle any exceptions that occur during the sign-out process
      if (kDebugMode) {
        print('Error signing out from Google: $e');
      }
    }

  } // end 'signOut' asynchronous method

  /// updates the last online timestamp in Firestore
  Future<void> updateLastOnline() async {

    if (_user != null) {
      await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
        'lastOnline': DateTime.now(), // Update last online timestamp
      });
    }

  } // end 'updateLastOnline' asynchronous method

  /// checks if the user is currently signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

} // end 'GoogleSignInProvider' class