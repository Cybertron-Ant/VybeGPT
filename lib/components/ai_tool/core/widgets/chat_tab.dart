import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_controller.dart';
import 'package:towers/components/ai_tool/core/widgets/chat_input_field.dart';  // Import the new ChatInputField

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

              // input field positioned at the bottom of the page
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // add bottom padding

                child: Center(
                  child: ChatInputField(
                    controller: chatController.inputController, // pass input controller
                    onSend: () => chatController.generateResponse(context), // pass the 'onSend' callback
                  ),
                ),
              ),

            ],  // end of 'Column' children list

          ),  // end of 'Column' widget

        );  // end of 'Padding' widget

      },  // end of 'builder' method

    );  // end of Consumer widget
  } // end 'build' overridden method

}  // end of ChatTab widget class