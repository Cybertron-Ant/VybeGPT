// import the flutter material package
// this package contains essential widgets and utilities for building material design apps
import 'package:flutter/material.dart';  // provides material design widgets and theming


// define a stateless widget class named 'CustomButton'
// this class represents a customizable button with text and an onPressed callback
class CustomButton extends StatelessWidget {  // custom button widget definition

  // declare a final string variable to hold the button text
  // this text will be displayed on the button
  final String text;  // text label for the button

  // declare a final voidcallback variable for the button's onPressed event
  // this callback will be triggered when the button is pressed
  final VoidCallback onPressed;  // callback for button press action

  // constructor for the custombutton class
  // it requires the text and onPressed parameters, and passes the key to the superclass
  CustomButton({super.key, required this.text, required this.onPressed});  // constructor to initialize the button text and callback


  // override the build method to define the widget's appearance
  // this method returns a widget tree that describes the button's UI
  @override
  Widget build(BuildContext context) {  // build method to create the widget tree

    // return an elevatedbutton widget
    // the elevatedbutton is a material design button that elevates when pressed
    return ElevatedButton(  // returning an elevated button widget

      // assign the onPressed callback to the button's onPressed property
      // this defines the action to take when the button is pressed
      onPressed: onPressed,  // set the button's onPressed callback


      // set the child of the elevatedbutton to a text widget
      // this text widget displays the button's label
      child: Text(text),  // set the button's label to the provided text

    );  // end of elevatedbutton widget
  }  // end of 'build' method

}  // end of 'custombutton' class