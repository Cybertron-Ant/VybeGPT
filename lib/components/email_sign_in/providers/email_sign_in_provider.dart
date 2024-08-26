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

  final FirebaseAuth _auth = FirebaseAuth.instance;  // firebase authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // firestore instance
  User? _user; // current user
  User? get user => _user; // getter for user
  final TextEditingController emailController = TextEditingController();  // email text controller
  final TextEditingController passwordController = TextEditingController();  // password text controller
  bool _isLoading = false; // loading state
  bool get isLoading => _isLoading; // getter for loading state

  /// constructor to initialize the WidgetsBindingObserver
  EmailSignInProvider() {
    WidgetsBinding.instance.addObserver(this);  // add observer to monitor app lifecycle
    _initializeUser(); // initialize user on startup
  }

  /// dispose method to remove the observer when the provider is disposed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // remove observer when disposing
    emailController.dispose();  // dispose email controller
    passwordController.dispose();  // dispose password controller
    super.dispose();  // call superclass dispose
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

  Future<void> _initializeUser() async {
    _user = _auth.currentUser;  // get current user
    if (_user != null) {
      // You might not have access to context here, so you may need to handle this differently
      // For example, you can notify listeners and then handle context-dependent actions in the UI
      notifyListeners();  // notify listeners of user change
    }
  }

  /// sign in the user using email and password and returns a [user] object
  Future<void> signInWithEmail(BuildContext context, String email, String password) async {
    try {
      _setLoading(true); // start loading indicator

      // sign in to firebase using email and password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user!; // get the user from firebase

      if (_user != null) {
        if (context.mounted) {
          // store the user's email and profile photo url in the 'emailuserprovider'
          Provider.of<EmailUserProvider>(context, listen: false).setUser(
            EmailUserModel(
              email: _user!.email!,
              profilePhoto: _user!.photoURL,
              isOnline: true,
              lastOnline: DateTime.now(),
            ),
          );

          // save the user's data in firestore
          await _firestore.collection(Constants.usersCollection).doc(_user!.email!).set({
            'email': _user!.email!,
            'profilePhoto': _user!.photoURL,
            'lastLogin': DateTime.now(),
            'isOnline': true,
            'lastOnline': DateTime.now(),
          }, SetOptions(merge: true));  // update or merge user document

          notifyListeners();  // notify listeners to update the ui
        }
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
        await _firestore.collection(Constants.usersCollection).doc(_user!.email!).update({
          'isOnline': false, // set the user as 'offline'
          'lastOnline': DateTime.now(), // update last
        });
      }

      await _auth.signOut();  // sign out from firebase

      if (context.mounted) {
        Provider.of<EmailUserProvider>(context, listen: false).clearUser();  // clear user in provider
      }

      _user = null;  // reset the private user object
      notifyListeners();  // notify listeners of user change
    } catch (e) {
      if (kDebugMode) {
        print('${Strings.signOutErrorDebug} $e');
      }
    }
  }

  /// update the last online timestamp in firestore
  Future<void> updateLastOnline() async {
    if (_user != null) {
      await _firestore.collection(Constants.usersCollection).doc(_user!.email!).update({
        'lastOnline': DateTime.now(), // update last online timestamp
      });
    }
  }

  /// update the user's online status in firestore
  Future<void> _updateUserStatus(bool isOnline) async {
    if (_user != null) {
      await _firestore.collection(Constants.usersCollection).doc(_user!.email!).update({
        'isOnline': isOnline, // update online status
        'lastOnline': DateTime.now(), // update last online timestamp
      });
    }
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;  // set loading state
    notifyListeners();  // notify listeners of loading state change
  }

  // method to update the email address
  void setEmail(String email) {
    if (_user != null) {
      _user!.updateEmail(email).then((_) {
        // Update Firestore user document with new email
        _firestore.collection(Constants.usersCollection).doc(_user!.email!).update({
          'email': email,
        });
        notifyListeners();  // notify listeners of email change
      }).catchError((error) {
        if (kDebugMode) {
          print('Error updating email: $error');  // debug message for error updating email
        }
      });
    }
  } // end 'setEmail' method

  // method to check if the user is signed in
  bool isSignedIn() {
    return _user != null;  // return 'true' if user is not null, indicating signed in
  } // end 'isSignedIn' method

} // end 'EmailSignInProvider' class