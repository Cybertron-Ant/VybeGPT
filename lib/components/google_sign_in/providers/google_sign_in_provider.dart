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
  String? get userEmail => _user?.email!;

  /// constructor to initialize the observer
  GoogleSignInProvider() {
    WidgetsBinding.instance.addObserver(this);
    _initializeCurrentUser(); // initialize the current user on app startup
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
      await _firestore
          .collection(Constants.usersCollection)
          .doc(_user!.email!)
          .update({
        'isOnline': isOnline, // update 'online' status
        'lastOnline': DateTime.now(), // update last 'online' timestamp
      });
    }
  }

  /// Shows an error message to the user
  void _showErrorMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[300],
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
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
        _showErrorMessage(context, Constants.errorUserCanceled);
        return null;
      }

      // get the authentication details from the Google Sign-In request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // initialize a new authentication credential using the Google authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken!,
        idToken: googleAuth.idToken!,
      ); // end 'credential'

      try {
        // sign in to Firebase using the Google credential & obtain a 'UserCredential'
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // get the user from Firebase
        _user = userCredential.user!;

        if (_user != null && context.mounted) {
          // Initialize user data model
          _userModel = GoogleUserModel(
            email: _user!.email!,
            profilePhoto: _user!.photoURL,
            isOnline: true,
            lastLogin: DateTime.now(),
            displayName: _user!.displayName ?? _user!.email!.split('@')[0],
            uid: _user!.uid,
          );

          Provider.of<GoogleUserProvider>(context, listen: false)
              .setUser(_userModel!);

          // Initialize user document in Firestore with conversations collection
          final userDocRef = _firestore
              .collection(Constants.usersCollection)
              .doc(_user!.email!);

          await userDocRef.set({
            'email': _user!.email!,
            'profilePhoto': _user!.photoURL,
            'displayName': _user!.displayName ?? _user!.email!.split('@')[0],
            'uid': _user!.uid,
            'lastLogin': DateTime.now(),
            'isOnline': true,
            'lastOnline': DateTime.now(),
          }, SetOptions(merge: true));

          // Initialize conversations collection if it doesn't exist
          final conversationsCollectionRef =
              userDocRef.collection('conversations');
          final conversationsSnapshot = await conversationsCollectionRef.get();

          if (conversationsSnapshot.docs.isEmpty) {
            // Create a default conversation document to initialize the collection
            await conversationsCollectionRef.doc('welcome').set({
              'createdAt': DateTime.now(),
              'lastMessage': 'Welcome to the app!',
              'lastMessageTime': DateTime.now(),
            });
          }

          notifyListeners();
        }
        return _user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          _showErrorMessage(context, Constants.errorAccountExists);
          if (kDebugMode) {
            print(
                'Account exists with different credential for email: ${e.email}');
          }
        } else if (e.code == 'invalid-credential') {
          _showErrorMessage(context, Constants.errorInvalidCredential);
        } else {
          _showErrorMessage(
              context, '${Constants.errorGenericSignIn}${e.message}');
        }
      }
    } catch (e) {
      _showErrorMessage(context, '${Constants.errorGenericSignIn}$e');
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
    }

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
        await _firestore
            .collection(Constants.usersCollection)
            .doc(_user!.email!)
            .update({
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
      await _firestore
          .collection(Constants.usersCollection)
          .doc(_user!.email!)
          .update({
        'lastOnline': DateTime.now(), // Update last online timestamp
      });
    }
  } // end 'updateLastOnline' asynchronous method

  /// checks if the user is currently signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }
} // end 'GoogleSignInProvider' class