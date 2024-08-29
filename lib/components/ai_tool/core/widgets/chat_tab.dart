import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/core/constants/api_constants.dart';
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

              // check if there are any messages
              if (chatController.messages.isEmpty)  // 'no messages' case
                Expanded(  // expanded to take available space
                  child: Center(  // center the placeholder image
                    child: ClipOval(  // clip the image to be circular
                      child: Image.asset(  // load placeholder image
                        brandImage,  // path to placeholder image
                        width: 100.0,  // set width of the circular image
                        height: 100.0,  // set height of the circular image
                        fit: BoxFit.cover,  // cover the circular bounds
                      ),
                    ),
                  ),
                )

              else  // show messages case
                Expanded(  // expanded to make the response scrollable
                  child: SingleChildScrollView(  // scroll view for response text
                    child: Column(  // Use Column to display multiple messages
                      crossAxisAlignment: CrossAxisAlignment.start,  // align messages to the start

                      children: [

                        // show existing messages if available
                        ...chatController.messages.map((message) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),  // padding around each message
                          child: Text('$userEmail: $message'),  // Display each message with user's email
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
                    chatController: chatController,  // pass the 'chatController'
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