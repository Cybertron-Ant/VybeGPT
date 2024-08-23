// import the flutter material package
// this package includes essential widgets and tools for building material design applications
import 'package:flutter/material.dart';  // provides material design widgets and theming


// define a stateless widget class named 'InputField'
// this class represents a text input field with a controller and a hint text
class InputField extends StatelessWidget {  // custom input field widget definition

  // declare a final texteditingcontroller variable to manage the text input
  // this controller will handle the text entered in the input field
  final TextEditingController controller;  // controller for managing text input

  // declare a final string variable for the hint text
  // this hint text will be displayed inside the input field as a placeholder
  final String hintText;  // placeholder text for the input field

  // constructor for the inputfield class
  // it requires the controller and hinttext parameters, and passes the key to the superclass
  InputField({super.key, required this.controller, required this.hintText});  // constructor to initialize the input field with a controller and hint text


  // override the build method to define the widget's appearance
  // this method returns a widget tree that describes the input field's UI
  @override
  Widget build(BuildContext context) {  // build method to create the widget tree

    // return a textfield widget
    // the textfield is a material design widget for text input
    return TextField(  // returning a text field widget

      // assign the controller to the textfield's controller property
      // this binds the text input to the provided controller
      controller: controller,  // set the textfield's controller

      // set the decoration for the textfield
      // the decoration includes the hint text and border style
      decoration: InputDecoration(  // decoration for the textfield

        // set the hint text inside the input field
        // this hint text acts as a placeholder when the field is empty
        hintText: hintText,  // set the hint text for the input field

        // set a border for the textfield
        // this provides a visual boundary for the input area
        border: const OutlineInputBorder(),  // set the border style for the input field

      ),

    );

  }  // end of 'build' method

}  // end of 'inputfield' class