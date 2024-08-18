import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:towers/components/facebook_sign_in/constants/constants.dart';
import 'package:towers/components/facebook_sign_in/models/facebook_user_model.dart';
import 'package:towers/components/facebook_sign_in/providers/facebook_user_provider.dart';


class FacebookSignInProvider extends ChangeNotifier {

  /// an instance of [firebaseauth] to interact with firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// an instance of [firestore] to interact with firebase firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// a private user object to store the current authenticated user
  User? _user;

  /// getter for the current user
  User? get user => _user;

  /// signs in the user using facebook sign-in and returns a [user] object
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      // trigger the facebook sign-in authentication flow
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // get facebook oauth credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);

        try {
          // sign in to firebase using the facebook credential & obtain a 'usercredential'
          final UserCredential userCredential = await _auth.signInWithCredential(credential);

          // get the user from firebase
          _user = userCredential.user;

          if (_user != null && context.mounted) {
            // store the user's email and profile photo url in the 'facebookuserprovider'
            Provider.of<FacebookUserProvider>(context, listen: false).setUser(
              FacebookUserModel(
                email: _user!.email!,
                profilePhoto: _user!.photoURL,
                isOnline: true,
                lastOnline: DateTime.now(), // set last online timestamp
              ),
            );

            // save the user's data in firestore
            await _firestore.collection(Constants.usersCollection).doc(_user!.email).set({
              'email': _user!.email!,
              'profilePhoto': _user!.photoURL,
              'lastLogin': DateTime.now(),
              'isOnline': true, // set the user as online
              'lastOnline': DateTime.now(), // save the last online timestamp
            }, SetOptions(merge: true));

            // notify listeners to update the ui
            notifyListeners();
          }

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
              // handle this case in your ui
            }

            // assuming user provides existing credentials
            final UserCredential existingUserCredential = await _auth.signInWithEmailAndPassword(
              email: email,
              password: 'user-provided-password', // replace with actual password
            );

            await existingUserCredential.user!.linkWithCredential(credential);

            _user = existingUserCredential.user;
          } else if (e.code == 'invalid-credential') {
            if (kDebugMode) {
              print('Invalid facebook credential. Please check your token and try again.');
            }
          } else {
            if (kDebugMode) {
              print('Error signing in with facebook: $e');
            }
          }
        }

      } else {
        if (kDebugMode) {
          print('Facebook login failed: ${result.message}');
        }
      }

    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with facebook: $e');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    }
  }

  /// signs out the user from both facebook and firebase
  Future<void> signOut(BuildContext context) async {
    try {
      // sign out from facebook
      await FacebookAuth.instance.logOut();

      // sign out from firebase
      await _auth.signOut();

      if (context.mounted) {
        // clear user data from 'facebookuserprovider'
        Provider.of<FacebookUserProvider>(context, listen: false).clearUser();

        // update the user's status to offline in firestore
        if (_user != null) {
          await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
            'isOnline': false, // set the user as offline
            'lastOnline': DateTime.now(), // update last online timestamp
          });
        }
      }

      // reset the private user object
      _user = null;

      // notify listeners to update the ui
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out from facebook: $e');
      }
    }
  }

  /// updates the last online timestamp in firestore
  Future<void> updateLastOnline() async {
    if (_user != null) {
      await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
        'lastOnline': DateTime.now(), // update last online timestamp
      });
    }
  }

}