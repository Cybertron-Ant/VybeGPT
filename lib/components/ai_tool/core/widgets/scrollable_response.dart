// import the flutter material package
// this package includes widgets and tools for building material design applications
import 'package:flutter/material.dart';  // provides material design widgets and theming


// define a stateless widget class named 'ScrollableResponse'
// this class represents a scrollable area that displays a response text
class ScrollableResponse extends StatelessWidget {  // custom scrollable response widget definition

  // declare a final string variable for the response text
  // this text will be displayed inside the scrollable area
  final String responseText;  // response text to be displayed

  // constructor for the 'scrollableresponse' class
  // it requires the responsetext parameter and passes the key to the superclass
  ScrollableResponse({super.key, required this.responseText});  // constructor to initialize the scrollable response with text


  // override the build method to define the widget's appearance
  // this method returns a widget tree that describes the scrollable area
  @override
  Widget build(BuildContext context) {  // build method to create the widget tree

    // return an expanded widget
    // the 'expanded' widget allows the child to take up all available space
    return Expanded(  // returning an expanded widget

      // set the child of the expanded widget to a 'singlechildscrollview'
      // this widget allows for scrolling when the content exceeds the available space
      child: SingleChildScrollView(  // scrollable container for the text

        // apply padding around the scrollable content
        // padding adds space inside the container around the text
        padding: const EdgeInsets.all(8.0),  // set padding for the scrollable content

        // set the child of the 'singlechildscrollview 'to a text widget
        // the text widget displays the response text provided
        child: Text(  // text widget to display the response text

          // assign the response text to the text widget
          // this is the actual content that will be displayed
          responseText,  // set the text content

          // apply styling to the text
          // the textstyle sets the font size and other properties
          style: const TextStyle(fontSize: 16),  // set text style with a font size of 16

        ),

      ),

    );  // end of expanded widget

  }  // end of 'build' method

}  // end of 'scrollableresponse' class