import 'package:flutter/material.dart';
import 'package:towers/components/ai_tool/core/constants/api_constants.dart';  // import the material package for building UI elements


class ChatInputField extends StatefulWidget {
  // declare final variables for text editing controller, send button callback, and chat controller
  final TextEditingController controller;
  final VoidCallback onSend;
  final dynamic chatController;

  // constructor for the widget, requiring 'controller', 'onSend', and 'chatController' parameters
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.chatController,
  }); // end of constructor

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late final ValueNotifier<bool> _isTextEmptyNotifier;

  @override
  void initState() {
    super.initState();
    _isTextEmptyNotifier = ValueNotifier(widget.controller.text.isEmpty);

    // Listen to changes in the text field and update the notifier
    widget.controller.addListener(() {
      _isTextEmptyNotifier.value = widget.controller.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _isTextEmptyNotifier.dispose();
    super.dispose();
  }

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

        return Center(  // center the input field horizontally
          child: Container(
            width: inputWidth, // set the calculated width for the container
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),  // add horizontal and vertical padding

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

            ), // end of box decoration

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,  // align items to the bottom
              children: [

                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150.0,  // set maximum height for the input field
                    ),  // end of box constraints

                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, // enable vertical scrolling
                      reverse: true, // start scrolling from the bottom

                      child: TextField(
                        controller: widget.controller, // bind the text field to the controller
                        maxLines: null, // allow the text field to expand vertically
                        minLines: 1, // set minimum number of lines
                        keyboardType: TextInputType.multiline, // set keyboard type to 'multiline'

                        decoration: const InputDecoration(
                          border: InputBorder.none,  // remove the default border
                          hintText: messageGazaGpt,  // set the placeholder text
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),  // add horizontal padding to the text
                        ), // end of text field decoration

                        onSubmitted: (prompt) {
                          // call 'onUserPromptSubmitted()' method when user submits a prompt
                          widget.chatController.onUserPromptSubmitted(prompt);
                        }, // end 'onSubmitted' callback

                      ), // end of text field
                    ), // end of 'single child scroll view'
                  ),  // end of constrained box
                ),  // end of expanded widget

                const SizedBox(width: 8.0), // add spacing between text field & button

                ValueListenableBuilder<bool>(
                  valueListenable: _isTextEmptyNotifier,
                  builder: (context, isTextEmpty, child) {
                    return GestureDetector(
                      onTap: isTextEmpty ? null : widget.onSend, // set the callback for the send button
                      child: Container(
                        width: 42,  // set the width of the icon button container
                        height: 42,  // set the height of the icon button container

                        decoration: BoxDecoration(
                          color: isTextEmpty ? Colors.grey : Colors.black,  // set the background color of the send button
                          shape: BoxShape.circle,  // make the button circular
                        ), // end of box decoration

                        child: const Icon(Icons.send, color: Colors.white),  // add a send icon to the button
                      ), // end of send button container
                    ); // end of gesture detector
                  },
                ), // end of ValueListenableBuilder

              ], // end of row 'children' list

            ),

          ),
        );

      }, // end of 'builder' function

    ); // end of 'layout' builder

  } // end of 'build' method

} // end of 'ChatInputField' class