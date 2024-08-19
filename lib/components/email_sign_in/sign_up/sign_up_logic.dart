import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // import dart's asynchronous programming package
import 'package:firebase_auth/firebase_auth.dart'; // import firebase authentication package
import 'package:towers/components/email_sign_in/constants/strings.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';
import 'package:towers/components/email_sign_in/sign_up/firebase_signup_auth.dart'; // import firebase signup authentication logic


class SignUpLogic { // define signup logic class

  final TextEditingController emailController = TextEditingController(); // controller for email input field
  final TextEditingController passwordController = TextEditingController(); // controller for password input field
  final TextEditingController confirmPasswordController = TextEditingController(); // controller for confirm password input field

  bool isLoading = false; // boolean to track loading state
  String? errorMessage; // string to store error messages

  // show loading indicator method
  void showLoading(Function setState) {

    setState(() {
      isLoading = true; // set loading state to true
    });

  } // end 'showLoading' method

  // hide loading indicator method
  void hideLoading(Function setState) {

    setState(() {
      isLoading = false; // set loading state to false
    });

  } // end 'hideLoading' method

  // asynchronous 'signup' method
  void signUp(BuildContext context, Function setState) async {

    if (passwordController.text == confirmPasswordController.text) { // check if passwords match
      showLoading(setState); // show loading indicator

      try {
        await FirebaseSignup.signUp(emailController.text, passwordController.text); // attempt to sign up using firebase
        await FirebaseAuth.instance.currentUser?.sendEmailVerification(); // send email verification after signup

        setState(() {
          errorMessage = Strings.signUpSuccess; // set success message
        });

        Timer(const Duration(seconds: 2), () { // navigate to login page after 2 seconds
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()), // replace current screen with login page
          );
        });

      } catch (error) {

        hideLoading(setState); // hide loading indicator

        if (error is FirebaseAuthException) {

          if (error.code == 'email-already-in-use') { // check if email is already in use
            setState(() {
              errorMessage = Strings.emailAlreadyInUse; // specific error message for email already in use
            });
          } else if (error.code == 'weak-password') { // check if password is weak
            setState(() {
              errorMessage = Strings.weakPassword; // specific error message for weak password
            });
          } else if (error.code == 'invalid-email') { // check if email is invalid
            setState(() {
              errorMessage = Strings.invalidEmail; // specific error message for invalid email
            });
          } else { // handle other FirebaseAuth exceptions
            setState(() {
              errorMessage = Strings.signUpFailed; // generic error message for other sign-up failures
            });
          }
        } else { // handle non-FirebaseAuth errors

          setState(() {
            errorMessage = Strings.signUpFailed; // generic error message for non-FirebaseAuth errors
          });

        }

        if (kDebugMode) {
          print('Error signing up: $error'); // print error to console
        }

      }

    } else {

      setState(() {
        errorMessage = Strings.passwordMismatch; // set error message for password mismatch
      });

    }
  } // end 'signUp' method

} // end 'SignUpLogic' class