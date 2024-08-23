// import the flutter material package
// this provides access to the necessary widgets and tools for theming the app
import 'package:flutter/material.dart';  // importing material package for theming

// import the app_colors.dart file
// this file contains color constants used throughout the app
import 'app_colors.dart';  // importing app colors


// define a class named 'AppThemes'
// this class contains static theme data used for app-wide theming
class AppThemes {  // class to hold app themes

  // define a static final theme data named 'lightTheme'
  // this represents the light theme of the app and uses colors defined in app_colors
  static final ThemeData lightTheme = ThemeData(  // light theme configuration

    // set the primary color of the theme using the primary color from app_colors
    primaryColor: AppColors.primaryColor,  // primary color for the theme

    // set the hint color of the theme using the accent color from app_colors
    hintColor: AppColors.accentColor,  // hint color for text fields

  );  // end of ThemeData block

}  // end of AppThemes class