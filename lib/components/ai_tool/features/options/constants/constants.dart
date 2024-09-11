import 'package:flutter/material.dart';


class Constants {

  // AppBar title
  static const String optionsPageTitle = 'Options';

  // Welcome message template
  static const String welcomeMessage = 'Welcome, ';

  // Logout option
  static const String logoutOptionTitle = 'Logout';

  // Logout icon color
  static const Color logoutIconColor = Colors.red;

  // Logout tile color
  //static const Color logoutTileColor = Colors.redwithOpacity(0.1);

  // Avatar background color
  static const Color avatarBackgroundColor = Colors.teal;

  // Avatar icon color
  static const Color avatarIconColor = Colors.white;

  // Debug messages
  static const String debugEmailNotFound = 'No email found, using default user placeholder.';
  static const String debugCurrentUserEmail = 'Current User Email: ';
  static const String debugEmailSignOutSuccess = 'Successfully signed out from email provider';
  static const String debugEmailSignOutError = 'Error signing out from email provider: ';
  static const String debugGoogleSignOutSuccess = 'Successfully signed out from Google provider';
  static const String debugGoogleSignOutError = 'Error signing out from Google provider: ';
  static const String debugNavigatingToLoginPage = 'Navigating to the login page';

}