import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


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
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({

        'email': email,
        'created_at': Timestamp.now(),
        'uid': userCredential.user!.uid,

      }); // end firestore 'collection'

      // log to console: successfully signed up
      if (kDebugMode) {
        print('User signed up: ${userCredential.user?.email}');
      }

      res = 'success'; // set sign-up result to success

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {

        if (kDebugMode) {
          print('The password provided is too weak.');
        }
        res = 'weak-password'; // set sign-up result to weak password

        rethrow; // re-throw the exception to handle in UI

      } else if (e.code == 'email-already-in-use') {

        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        res = 'email-in-use'; // set sign-up result to email in use

        rethrow; // re-throw the exception to handle in UI

      } else {

        if (kDebugMode) {
          print('Sign up failed: ${e.message}');
        }
        res = 'failure'; // set sign-up result to failure

        rethrow; // re-throw the exception to handle in UI

      } // end 'else'

    } catch (e) {

      if (kDebugMode) {
        print('Error: $e');
      }
      res = 'failure'; // set sign-up result to failure for other errors

      rethrow; // re-throw the exception to handle in UI

    } // end 'CATCH'

  } // end 'signUp' future static method

} // end 'FirebaseSignup' class