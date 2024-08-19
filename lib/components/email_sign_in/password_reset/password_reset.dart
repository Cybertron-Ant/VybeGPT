import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towers/components/email_sign_in/constants/strings.dart';


class ResetPassword {

  /// sends a password reset email to the specified email address.
  /// this method attempts to send a password reset email to the provided email address
  /// It shows a success SnackBar if the email was sent successfully, or an error
  /// SnackBar if there was a failure.
  /// @param 'email' - the email address to send the password reset link to
  /// @param 'context' - the current build context, used to display SnackBars
  static Future<void> resetPassword(String email, BuildContext context) async {

    if (context == null) {
      debugPrint("Context is null. Unable to show SnackBar.");
      return;
    }

    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {

      // attempt to send the password reset email using 'FirebaseAuth'
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close the dialog after sending the reset email
      }

      // show success 'SnackBar' if possible
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text(Strings.passwordResetSuccess), // Use Strings class
          backgroundColor: Colors.green[300],
        ),
      );

    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // close the dialog on error
      }

      // determine the appropriate error message based on the exception code
      String errorMessage = Strings.genericError; // Use Strings class
      if (e.code == 'user-not-found') {
        errorMessage = Strings.userNotFoundError; // Use Strings class
      }

      // show error 'SnackBar' if possible
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red[300],
        ),
      );

    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // close the dialog on error
      }

      // show generic error 'SnackBar' if possible
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text(Strings.genericError), // Use Strings class
          backgroundColor: Colors.red[300],
        ),
      );
    }
  }

} // end 'ResetPassword' class