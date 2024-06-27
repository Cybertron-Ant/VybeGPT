import 'package:flutter/material.dart';


// stateless widgets are immutable & do not have state that changes over time
class StatelessTemplate extends StatelessWidget {
  // constructor for 'StatelessTemplate', with a 'key' parameter for widget identification
  const StatelessTemplate({super.key});

  // Override 'build' method to describe part of user interface represented by this widget
  @override
  Widget build(BuildContext context) {
    // return a 'Scaffold' widget, which is a top-level container for Material design layout
    return Scaffold(

      body: Center(child: Text("Hello World")),

    ); // end Scaffold
  } // end 'build' override method

} // end 'StatelessTemplate' class