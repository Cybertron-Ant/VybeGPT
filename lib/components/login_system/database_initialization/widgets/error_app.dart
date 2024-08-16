import 'package:flutter/material.dart';


// 'ErrorApp' widget to be run if Firebase initialization fails
class ErrorApp extends StatelessWidget {

  // declare 'errorMessage' variable as a string
  final String errorMessage;

  // Adding a named 'key' parameter
  // Keys help in maintaining the order of widgets, when working with lists or dynamically changing widgets.
  //  when items in a list are reordered or filtered, keys ensure that the correct items are preserved and updated.
  // The key parameter is used by Flutter to uniquely identify widgets
  // Keys help Flutter to correctly match widget instances with their corresponding elements in the widget tree.
  // If you have stateful widgets, using keys is crucial for preserving state across rebuilds
  // Without keys, Flutter might lose track of which widget instances correspond to which pieces of state, leading to unexpected behavior.
  // useful when the widget tree is rebuilt, allowing Flutter to determine which widget instances should be reused or updated.
  ErrorApp({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: Scaffold(

        body: Center(child: Text("Firebase initialization failed: $errorMessage")),

      ),

    );

  } // end 'build' overridden method

} // end 'ErrorApp' widget class