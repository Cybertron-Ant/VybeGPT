import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_controller.dart';

class ChatTab extends StatelessWidget {
  final String userEmail;  // user email to be passed to the widget

  const ChatTab({super.key, required this.userEmail});  // constructor with userEmail

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(  // 'Consumer' listens for changes in 'ChatController'

      // builder method to rebuild UI whenever ChatController notifies listeners
      builder: (context, chatController, _) {  // builder method for UI updates

        // return a Padding widget to add spacing around the content
        return Padding(  // add padding around the content

          // specify the amount of padding to apply
          padding: const EdgeInsets.all(16.0),  // padding around the column

          child: Column(  // 'Column' to arrange widgets vertically

            // define the list of child widgets for the column
            children: [  // list of child widgets in the column

              // add a 'TextField' for user input
              // the controller is connected to the 'ChatController' to manage input
              TextField(  // 'TextField' for user to enter prompt

                // connect the controller to manage the input text
                controller: chatController.inputController,  // input controller

                // add input decoration with a label for the text field
                decoration: const InputDecoration(labelText: 'Enter a prompt'),  // input decoration

              ),

              // add a 'SizedBox' to create space between widgets
              const SizedBox(height: 16),  // space between input field and button

              // add an ElevatedButton to trigger response generation
              ElevatedButton(  // button to generate response

                // set the 'onPressed' callback to generate the AI's response
                onPressed: () => chatController.generateResponse(context),  // on press event

                // set the button text
                child: const Text('Generate Response'),  // button label

              ),

              // add another SizedBox to create space between widgets
              const SizedBox(height: 16),  // space between button and response

              // add an 'Expanded' widget to allow the response text to scroll
              Expanded(  // expanded to make the response scrollable

                // wrap the response text in a 'SingleChildScrollView'
                child: SingleChildScrollView(  // scroll view for response text

                  // display the response text using a Text widget
                  child: Column(  // Use Column to display multiple messages
                    crossAxisAlignment: CrossAxisAlignment.start,  // align messages to the start

                    children: [

                      // show existing messages if available
                      ...chatController.messages.map((message) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),  // padding around each message
                        child: Text('$userEmail: $message'),  // Display each message user's email
                      )),

                    ],
                  ),  // end of 'Column' widget

                ),  // end of 'SingleChildScrollView' widget

              ),  // end of 'Expanded' widget

            ],  // end of 'Column' children list

          ),  // end of 'Column' widget

        );  // end of 'Padding' widget

      },  // end of 'builder' method

    );  // end of Consumer widget
  } // end 'build' overridden method

}  // end of ChatTab widget class