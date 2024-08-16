import 'package:flutter/material.dart';  // import material design package for flutter
import 'dart:async';  // import dart's asynchronous programming package
import 'package:firebase_auth/firebase_auth.dart';  // import firebase authentication package
import 'package:towers/components/login_system/screens/LoginPage.dart';  // import login page screen from your project
import 'package:towers/components/login_system/user_authentication/signup/firebase_signup_auth.dart';  // import firebase signup authentication logic from your project


class SignUpLogic {  // define signup logic class

  final TextEditingController emailController = TextEditingController();  // controller for email input field
  final TextEditingController passwordController = TextEditingController();  // controller for password input field
  final TextEditingController confirmPasswordController = TextEditingController();  // controller for confirm password input field

  bool isLoading = false;  // boolean to track loading state
  String? errorMessage;  // string to store error messages

  // show loading indicator method
  void showLoading(Function setState) {
    setState(() {
      isLoading = true;  // set loading state to true
    });
  }  // end showLoading method

  // hide loading indicator method
  void hideLoading(Function setState) {
    setState(() {
      isLoading = false;  // set loading state to false
    });
  }  // end hideLoading method

  // asynchronous signup method
  void signUp(BuildContext context, Function setState) async {
    if (passwordController.text == confirmPasswordController.text) {  // check if passwords match
      showLoading(setState);  // show loading indicator

      try {
        await FirebaseSignup.signUp(emailController.text, passwordController.text);  // attempt to sign up using firebase
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();  // send email verification after signup

        setState(() {
          errorMessage = "Sign up successful! Please verify your email.";  // set success message
        });

        Timer(const Duration(seconds: 2), () {  // navigate to login page after 2 seconds
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),  // replace current screen with login page
          );
        });

      } catch (error) {
        hideLoading(setState);  // hide loading indicator
        print('Error signing up: $error');  // print error to console

        setState(() {
          errorMessage = 'Sign up failed. Please try again.';  // set error message
        });

      }

    } else {
      setState(() {
        errorMessage = "Passwords do not match.";  // set error message for password mismatch
      });
    }

  }  // end signUp method

}  // end SignUpLogic class