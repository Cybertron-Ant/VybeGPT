import 'package:flutter/material.dart';
import 'package:towers/components/ai_tool/core/constants/api_constants.dart';  // import the material package for building UI elements


class ChatInputField extends StatelessWidget {
  // declare final variables for text editing controller and send button callback
  final TextEditingController controller;
  final VoidCallback onSend;

  // constructor for the widget, requiring 'controller' & 'onSend' parameters
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  }); // end of constructor

  @override
  Widget build(BuildContext context) {
    // build method to describe the part of the UI represented by this widget
    return LayoutBuilder(
      builder: (context, constraints) {
        // define a builder function to get the constraints and build accordingly

        double inputWidth;  // store the calculated width for the input field

        if (constraints.maxWidth > 900) {
          // if screen width is greater than 900 pixels, consider it a desktop screen
          inputWidth = constraints.maxWidth * 0.60;
        } else if (constraints.maxWidth > 600) {
          // if screen width is greater than 600 pixels, consider it a tablet screen
          inputWidth = constraints.maxWidth * 0.70;
        } else {
          // if screen width is 600 pixels or less, consider it a smartphone screen
          inputWidth = constraints.maxWidth * 0.90; // change to 90% for smartphone screens
        } // end of width calculation based on screen size

        return Container(
          width: inputWidth, // set the calculated width for the container
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // add horizontal padding

          decoration: BoxDecoration(
            color: Colors.grey[200],  // set the background color of the container
            borderRadius: BorderRadius.circular(30), // round the corners of the container

            boxShadow: const [
              BoxShadow(
                color: Colors.black26, // set the shadow color
                blurRadius: 4.0, // set the blur radius for the shadow
                offset: Offset(0, 2), // set the offset for the shadow
              ),
            ], // end of box shadow list

          ), //

          child: Row(
            // row to arrange the text field and send button horizontally
            children: [

              Expanded(
                child: TextField(
                  controller: controller, // bind the text field to the controller

                  decoration: const InputDecoration(
                    border: InputBorder.none,  // remove the default border
                    hintText: messageGazaGpt,  // set the placeholder text
                    contentPadding: EdgeInsets.only(left: 16.0),  // add left padding to the hint text
                  ), // end of text field decoration

                ), // end of text field
              ), // end of expanded widget

              IconButton(
                icon: Container(
                  width: 36,  // set the width of the icon button container
                  height: 36,  // set the height of the icon button container
                  decoration: const BoxDecoration(
                    color: Colors.black,  // set the background color of the icon button
                    shape: BoxShape.circle,  // make the button circular
                  ), // end of box decoration

                  child: const Icon(Icons.send, color: Colors.white),  // add a send icon to the button
                ), // end of icon button container

                onPressed: onSend,  // set the callback for the send button
                padding: EdgeInsets.zero,  // remove padding around the button
                constraints: const BoxConstraints(),  // remove any size constraints
                iconSize: 20,  // set the icon size
                splashColor: Colors.transparent,  // remove the splash effect
                highlightColor: Colors.transparent,  // remove the highlight effect
              ), // end of icon button

            ], // end of row 'children' list

          ),

        );

      }, // end of 'builder' function

    ); // end of 'layout' builder

  } // end of 'build' method

} // end of 'ChatInputField' class