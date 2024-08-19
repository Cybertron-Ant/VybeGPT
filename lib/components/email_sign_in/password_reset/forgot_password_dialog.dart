import 'package:flutter/material.dart';
import 'package:towers/components/email_sign_in/password_reset/password_reset.dart';


// start of 'ForgotPasswordDialog' class
class ForgotPasswordDialog {

  // static method to show the forgot password dialog
  static void showForgotPasswordDialog(BuildContext context, String email) {

    // controller for the email text field
    TextEditingController emailController = TextEditingController();

    // show dialog
    showDialog(
      context: context,
      builder: (context) {

        // dialog UI
        return AlertDialog(
          title: const Text('Reset Password'), // title of the dialog

          content: Column(
            mainAxisSize: MainAxisSize.min, // ensure the column takes only minimum space

            children: <Widget>[

              // description text
              const Text('Enter your email address to receive a password reset link.'),

              // email input field
              TextFormField(
                controller: emailController, // use the email controller
                decoration: const InputDecoration(hintText: 'Email'), // hint text for the input field
              ),

            ],

          ),

          actions: <Widget>[

            // cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },

              child: const Text('Cancel'), // button text
            ),

            // send button
            ElevatedButton(
              onPressed: () {
                ResetPassword.resetPassword(emailController.text, context); // handle password reset
              },

              child: const Text('Send'), // button text
            ),

          ],

        );
      },
    );
  }

} // end 'ForgotPasswordDialog' class