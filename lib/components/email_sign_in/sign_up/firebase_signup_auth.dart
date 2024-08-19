import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:towers/components/email_sign_in/constants/constants.dart';
import 'package:towers/components/email_sign_in/constants/strings.dart';


class FirebaseSignup {

  static String res = ''; // initialize global variable to store sign-up result

  static Future<void> signUp(String email, String password) async {

    try {

      // register the user with email & password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(

        email: email,
        password: password,

      ); // end 'createUserWithEmailAndPassword'

      // save user data to Firestore database, after user registration is complete
      await FirebaseFirestore.instance.collection(Constants.usersCollection).doc(userCredential.user?.email).set({

        'email': email,
        'created_at': Timestamp.now(),
        'uid': userCredential.user!.uid,

      }); // end firestore 'collection'

      // log to console: successfully signed up
      if (kDebugMode) {
        print(Strings.userSignedUp + '${userCredential.user?.email}');
      }

      res = Strings.signUpSuccess; // set sign-up result to success

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print(Strings.weakPasswordDebug);
        }

        res = Strings.weakPassword; // set sign-up result to weak password

        rethrow; // re-throw the exception to handle in UI

      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print(Strings.emailInUseDebug);
        }

        res = Strings.emailInUse; // set sign-up result to email in use

        rethrow; // re-throw the exception to handle in UI

      } else {
        if (kDebugMode) {
          print(Strings.signUpFailedDebug + '${e.message}');
        }

        res = Strings.signUpFailed; // set sign-up result to failure

        rethrow; // re-throw the exception to handle in UI
      } // end 'else'

    } catch (e) {
      if (kDebugMode) {
        print(Strings.error + '$e');
      }

      res = Strings.signUpFailed; // set sign-up result to failure for other errors

      rethrow; // re-throw the exception to handle in UI
    } // end 'CATCH'

  } // end 'signUp' future static method

} // end 'FirebaseSignup' class