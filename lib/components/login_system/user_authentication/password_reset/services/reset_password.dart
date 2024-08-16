import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


// ensure that the 'BuildContext' used is valid and directly connected to the Scaffold
// where the 'SnackBar' should be displayed. This should resolve the assertion error
/// a class to handle password reset functionality using Firebase
/// the 'ResetPassword' class contains a static method to reset a user's password
/// by sending a password reset email. It provides appropriate user feedback
/// through SnackBars based on the success or failure of the operation.
class ResetPassword {

  /// sends a password reset email to the specified email address.
  /// this method attempts to send a password reset email to the provided email address
  /// It shows a success SnackBar if the email was sent successfully, or an error
  /// 'SnackBar' if there was a failure.
  /// @param 'email' - the email address to send the password reset link to
  /// @param 'context' - the current 'build' context, used to display SnackBars
  static void resetPassword(String email, BuildContext context) async {
    if (context == null) {
      debugPrint("Context is null. Unable to show SnackBar.");
      return;
    } // end IF

    // find the nearest 'ScaffoldMessenger' in the widget tree
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    if (scaffoldMessenger == null) {
      debugPrint("No ScaffoldMessenger found in the widget tree.");
      return;
    } // end IF

    try {
      // attempt to send the password reset email using 'FirebaseAuth'
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if(context.mounted) {
        Navigator.of(context).pop(); // Close the dialog after sending the reset email
      }

      // show success 'SnackBar' if possible
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Password reset link sent! Check your email.'),
            backgroundColor: Colors.green[300],
        ),
      ); // end 'showSnackBar'

    } on FirebaseAuthException catch (e) {

      if(context.mounted) {
        Navigator.of(context).pop(); // close the dialog on error
      }

      // determine the appropriate error message based on the exception code
      String errorMessage = 'An error occurred. Try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } // end IF

      // show error 'SnackBar if possible
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red[300],
        ),
      ); // end 'showSnackBar'

    } catch (e) {

      if(context.mounted) {
        Navigator.of(context).pop(); // close the dialog on error
      }

      // show generic error 'SnackBar' if possible
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red[300],
        ),
      ); // end 'showSnackBar'

    } // end 'CATCH'

  } // end 'resetPassword' static method

} // end 'ResetPassword' class