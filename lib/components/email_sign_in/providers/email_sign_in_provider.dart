import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // for 'WidgetsBindingObserver'
import 'package:provider/provider.dart';
import 'package:towers/components/email_sign_in/constants/constants.dart';
import 'package:towers/components/email_sign_in/constants/strings.dart';
import 'package:towers/components/email_sign_in/models/email_user_model.dart';
import 'package:towers/components/email_sign_in/providers/email_user_provider.dart';


class EmailSignInProvider extends ChangeNotifier with WidgetsBindingObserver {

  /// an instance of [firebaseauth] to interact with firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// an instance of [firestore] to interact with firebase firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// a private user object to store the current authenticated user
  User? _user;

  /// getter for the current user
  User? get user => _user;

  /// a text editing controller for email input
  final TextEditingController emailController = TextEditingController();

  /// a text editing controller for password input
  final TextEditingController passwordController = TextEditingController();

  /// a private loading state to show a loading indicator
  bool _isLoading = false;

  /// getter for the loading state
  bool get isLoading => _isLoading;

  /// constructor to initialize the WidgetsBindingObserver
  EmailSignInProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// dispose method to remove the observer when the provider is disposed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_user != null) {
      if (state == AppLifecycleState.paused) {
        _updateUserStatus(false); // set the user as offline
      } else if (state == AppLifecycleState.resumed) {
        _updateUserStatus(true); // set the user as online
      }
    }
  }

  /// sign in the user using email and password and returns a [user] object
  Future<void> signInWithEmail(BuildContext context, String email, String password) async {
    try {
      _setLoading(true); // set loading to true

      // sign in to firebase using email and password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // get the user from firebase
      _user = userCredential.user;

      if (_user != null && context.mounted) {
        // store the user's email and profile photo url in the 'emailuserprovider'
        Provider.of<EmailUserProvider>(context, listen: false).setUser(
          EmailUserModel(
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
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('${Strings.noUserFoundDebug} $email');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('${Strings.wrongPasswordDebug} $email');
        }
      } else {
        if (kDebugMode) {
          print('${Strings.signInErrorDebug} $e');
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.signInError),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('${Strings.error} $e');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.signInError),
          ),
        );
      }
    } finally {
      _setLoading(false); // set loading to false
    }
  }

  /// sign out the user from firebase
  Future<void> signOut(BuildContext context) async {
    try {
      if (_user != null) {
        // update the user's status to offline in firestore
        await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
          'isOnline': false, // set the user as 'offline'
          'lastOnline': DateTime.now(), // update last online timestamp
        });
      }

      // sign out from firebase
      await _auth.signOut();

      if (context.mounted) {
        // clear user data from 'emailuserprovider'
        Provider.of<EmailUserProvider>(context, listen: false).clearUser();
      }

      // reset the private user object
      _user = null;

      // notify listeners to update the ui
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('${Strings.signOutErrorDebug} $e');
      }
    }
  }

  /// update the last online timestamp in firestore
  Future<void> updateLastOnline() async {
    if (_user != null) {
      await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
        'lastOnline': DateTime.now(), // update last online timestamp
      });
    }
  }

  /// update the user's online status in firestore
  Future<void> _updateUserStatus(bool isOnline) async {
    if (_user != null) {
      await _firestore.collection(Constants.usersCollection).doc(_user!.email).update({
        'isOnline': isOnline, // update online status
        'lastOnline': DateTime.now(), // update last online timestamp
      });
    }
  }

  /// sets the loading state
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

} // end 'EmailSignInProvider' class