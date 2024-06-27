import 'package:flutter/material.dart';
import 'stateless_template.dart'; // import the 'StatelessTemplate' widget


class MyApp extends StatelessWidget {
  // constructor for 'MyApp', with a 'key' parameter for widget identification
  const MyApp({super.key});

  // Override 'build' method to describe part of user interface represented by this widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      // set 'StatelessTemplate' widget as the home screen
      // means 'StatelessTemplate' will be the first screen shown in the app
      home: StatelessTemplate(),

    );
  } // end 'build' overridden method

} // end 'MyApp' class