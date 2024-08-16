import 'package:flutter/material.dart';
import '../services/reset_password.dart';


/// a class to handle the display and functionality of a forgot password dialog
/// The 'ForgotPasswordDialog' class contains a static method to show a dialog
/// that prompts the user to enter their email address for password reset purposes
class ForgotPasswordDialog {

  /// shows a forgot password dialog
  /// This method shows a dialog with an input field where the user can enter their email address
  /// Upon submission, it calls the `ResetPassword.resetPassword` method to send a password reset email
  /// @param 'context' - The current build context, used to display the dialog.
  /// @param 'email' - The email address to pre-fill in the email input field (if any)
  static void showForgotPasswordDialog(BuildContext context, String email) {
    // initialize a 'TextEditingController' to manage the email input field
    TextEditingController emailController = TextEditingController();

    // show a dialog to prompt the user for their email address
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          title: Text('Reset Password'),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[

              Text('Enter your email address to receive a password reset link.'),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),

            ],

          ),

          actions: <Widget>[

            // 'Cancel' button to close the dialog without any action
            TextButton(

              onPressed: () {
                Navigator.of(context).pop();
              }, // end 'onPressed' callback

              child: Text('Cancel'),
            ),

            // 'Send' button to initiate the password reset process
            ElevatedButton(

              onPressed: () {
                ResetPassword.resetPassword(emailController.text, context);
              }, // end 'onPressed' callback

              child: Text('Send'),
            ),

          ],
        );

      }, // end 'builder'

    ); // end 'showDialog'

  } // end 'showForgotPasswordDialog' static method

} // end 'ForgotPasswordDialog' widget class