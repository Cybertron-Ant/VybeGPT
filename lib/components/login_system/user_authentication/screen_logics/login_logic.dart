import 'package:firebase_auth/firebase_auth.dart';  // import firebase authentication package
import 'package:flutter/material.dart';  // import flutter material design package
import 'package:provider/provider.dart';  // provider package
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';  // chat screen
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/login_system/user_authentication/login/email/firebase_login_auth.dart';  // firebase login authentication logic
import 'package:towers/components/login_system/controllers/login_controller.dart';  // login controller


class LoginLogic {  // define login logic class

  // perform the login operation
  static Future<void> login(
      BuildContext context,  // build context to interact with the widget tree
      GlobalKey<FormState> formKey,  // form key to validate form fields
      LoginController loginController,  // controller to manage login state
      SignInWithEmailAndPassword signInWithEmailAndPassword) async {  // method for signing in with email and password

    // validate the form fields
    if (formKey.currentState?.validate() ?? false) {  // if form is valid

      // set 'isLoading' to true to show loading indicator
      loginController.isLoading = true;  // start loading indicator

      try {

        // perform login using 'SignInWithEmailAndPassword' method
        UserCredential? userCredential = await signInWithEmailAndPassword
            .signInWithEmailAndPassword(loginController);  // try signing in with email and password

        // check if 'userCredential' is not null & if the widget is still mounted before navigating
        if (userCredential != null && context.mounted) {  // check if login was successful and context is still active

          // set the email in 'EmailSignInProvider'
          final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);
          emailSignInProvider.setEmail(userCredential.user!.email!);  // pass email to provider

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                userEmail: userCredential.user!.email!,  // pass email as 'userEmail'
              ),
            ),
          );  // end Navigator.pushReplacement

        } else {

          // if 'userCredential' is null, show an error 'Snackbar'
          if (context.mounted) {  // check if context is still active
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Check internet connection or login credentials'),  // show error message if login failed
              ),
            );  // end show error 'Snackbar'
          }

        }

      } on FirebaseAuthException catch (e) {

        // handle 'FirebaseAuthException' (e.g., wrong password, user not found)
        String errorMessage = 'An error occurred. Try again.';  // default error message

        if (e.code == 'user-not-found') {  // handle case when no user is found

          errorMessage = 'No user found with this email.';  // specific error message for user not found

        } else if (e.code == 'wrong-password') {  // handle case of wrong password

          errorMessage = 'Wrong password provided for this user.';  // specific error message for wrong password

        }

        if (context.mounted) {  // check if context is still active
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),  // show specific error message
            ),
          );  // end show error 'Snackbar'
        }

      } catch (e) {

        // handle any other unexpected errors
        if (context.mounted) {  // check if context is still active
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again later.'),  // show generic error message
            ),
          );  // end show generic error 'Snackbar'
        }

      } finally {

        // stop the loading indicator
        if (context.mounted) {  // check if context is still active
          loginController.isLoading = false;  // stop loading indicator
        }

      }  // end of try-catch-finally block

    }  // end form validation check

  }  // end login method

}  // end LoginLogic class
