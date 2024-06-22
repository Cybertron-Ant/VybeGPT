import 'package:flutter/material.dart';

//  'MaterialApp' widget as the root
void main() => runApp(MaterialApp(

  debugShowCheckedModeBanner: false,

  // set 'NinjaCard' widget as the home screen
  // means 'NinjaCard' will be the first screen shown in the app
  home: NinjaCard(),

));// end 'main' function


// Stateless widgets are immutable & do not have state that changes over time
class NinjaCard extends StatelessWidget {
  // Constructor for 'NinjaCard', with a 'key' parameter for widget identification
  const NinjaCard({super.key});

  // Override 'build' method to describe part of user interface represented by this widget
  @override
  Widget build(BuildContext context) {

    // return a Scaffold widget, which is a top-level container for Material design layout
    return Scaffold();

  }// end 'build' override method

}// end 'NinjaCard' class
