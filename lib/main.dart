import 'package:flutter/material.dart';

//  'MaterialApp' widget as the root
void main() => runApp(MaterialApp(

  debugShowCheckedModeBanner: false,

  // set 'StatelessTemplate' widget as the home screen
  // means 'StatelessTemplate' will be the first screen shown in the app
  home: StatelessTemplate(),

));// end 'main' function


// Stateless widgets are immutable & do not have state that changes over time
class StatelessTemplate extends StatelessWidget {
  // Constructor for 'StatelessTemplate', with a 'key' parameter for widget identification
  const StatelessTemplate({super.key});

  // Override 'build' method to describe part of user interface represented by this widget
  @override
  Widget build(BuildContext context) {

    // return a 'Scaffold' widget, which is a top-level container for Material design layout
    return Scaffold(
      body: Center(child: Text("Hello World")),
    );

  }// end 'build' override method

}// end 'StatelessTemplate' class