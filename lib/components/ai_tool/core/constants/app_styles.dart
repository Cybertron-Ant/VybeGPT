// import the flutter material package
// this provides access to the necessary widgets and tools for styling the ui
import 'package:flutter/material.dart';  // importing material package


// define a class named 'AppStyles'
// this class contains static styling properties that can be used throughout the app
class AppStyles {  // class to hold app-wide styles

  // define a static constant textstyle named 'chatTextStyle'
  // this style is used to format text in the chat feature of the app
  static const TextStyle chatTextStyle = TextStyle(  // text style for chat text

    // set the font size to 16 points
    fontSize: 16,  // setting font size

    // set the text color to black
    color: Colors.black,  // setting text color

  );  // end of textstyle block

}  // end of appstyles class