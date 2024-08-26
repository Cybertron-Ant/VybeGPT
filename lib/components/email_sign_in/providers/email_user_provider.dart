import 'package:flutter/material.dart';
import 'package:towers/components/email_sign_in/models/email_user_model.dart';
import 'package:towers/components/email_sign_in/password_reset/forgot_password_dialog.dart';
import 'package:towers/components/email_sign_in/password_reset/password_reset.dart';


class EmailUserProvider extends ChangeNotifier {

  /// a private user object to store the current user data
  EmailUserModel? _user;

  /// getter for the current user
  EmailUserModel? get user => _user!;

  /// set the user data
  void setUser(EmailUserModel user) {

    _user = user;
    notifyListeners();

  } // end 'setUser' method

  /// clear the user data
  void clearUser() {

    _user = null;
    notifyListeners();

  } // end 'clearUser' method

  /// show a forgot password dialog to the user
  /// This method uses the ForgotPasswordDialog class to prompt the user to enter their email address
  /// for password reset purposes.
  void showForgotPasswordDialog(BuildContext context) {

    ForgotPasswordDialog.showForgotPasswordDialog(context, '');

  } // end 'showForgotPasswordDialog' method

  /// reset the user's password
  /// This method utilizes the ResetPassword class to send a password reset email to the provided email address
  /// and shows appropriate feedback to the user.
  /// @param 'email' - the email address to send the password reset link to
  /// @param 'context' - the current build context, used to display SnackBars
  Future<void> resetPassword(String email, BuildContext context) async {

    await ResetPassword.resetPassword(email, context);

  } // end 'resetPassword' method

} // end 'EmailUserProvider' class