import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/core/constants/api_constants.dart';
import 'package:towers/components/ai_tool/features/chat/controllers/chat_controller.dart';
import 'package:towers/components/ai_tool/core/widgets/chat_input_field.dart';  // import the new ChatInputField

class ChatTab extends StatelessWidget {
  final String userEmail;  // user email to be passed to the widget

  const ChatTab({super.key, required this.userEmail});  // constructor with userEmail

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(  // 'Consumer' listens for changes in 'ChatController'

      // builder method to rebuild UI whenever ChatController notifies listeners
      builder: (context, chatController, _) {  // builder method for UI updates
        ScrollController _scrollController = ScrollController();  // create a scroll controller

        return Scaffold(
          body: Column(

            children: [

              Expanded(
                child: chatController.messages.isEmpty

                    ? Center(  // center the placeholder image when there are no messages
                  child: ClipOval(
                    child: Image.asset(
                      brandImage,  // path to placeholder image
                      width: 100.0,  // set width of the circular image
                      height: 100.0,  // set height of the circular image
                      fit: BoxFit.cover,  // cover the circular bounds
                    ),
                  ),
                )
                    : Scrollbar(
                  controller: _scrollController,  // associate scrollbar with scroll controller

                  child: SingleChildScrollView(
                    controller: _scrollController,  // associate 'singlechildscrollview' with scroll controller

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),  // padding around the column

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: chatController.messages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final message = entry.value;
                          final isUserMessage = message.isUser;  // check if the message is from the user

                          // split the message into code and non-code parts
                          final codeRegExp = RegExp(r'```(.*?)```', dotAll: true);
                          final matches = codeRegExp.allMatches(message.text);
                          final nonCodeParts = <String>[];
                          final codeParts = <String>[];
                          int lastIndex = 0;

                          for (final match in matches) {

                            if (match.start > lastIndex) {
                              nonCodeParts.add(message.text.substring(lastIndex, match.start));
                            }
                            codeParts.add(match.group(1)!);
                            lastIndex = match.end;
                          } // end FOR

                          if (lastIndex < message.text.length) {
                            nonCodeParts.add(message.text.substring(lastIndex));
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: PADDING_VERTICAL_12),  // vertical padding for more space

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                // show non-code parts in UI
                                for (final part in nonCodeParts)
                                  if (part.isNotEmpty)

                                    Container(
                                      padding: const EdgeInsets.all(PADDING_VERTICAL_12),
                                      margin: const EdgeInsets.only(bottom: PADDING_ONLY_BOTTOM_16),  // increased space between containers

                                      decoration: BoxDecoration(
                                        color: isUserMessage ? USER_MESSAGE_COLOR : AI_RESPONSE_COLOR,  // set background color based on message type(user/AI)
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),

                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      ),

                                      child: Stack(

                                        children: [

                                          Text(
                                            part,
                                            style: TextStyle(
                                              color: isUserMessage ? USER_TEXT_COLOR : AI_TEXT_COLOR,  // set text color based on message type(user/AI)
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),

                                          Positioned(
                                            top: 0.0,  // move 'copy' icon to the top
                                            right: 0.0,  // move 'copy' icon to the right
                                            child: IconButton(
                                              icon: const Icon(Icons.copy, color: Colors.white),

                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(text: part));
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text(SNACKBAR_COPIED_TO_CLIPBOARD)),
                                                );
                                              },
                                            ),
                                          ),

                                        ],

                                      ),
                                    ),

                                // show code parts in UI
                                for (final code in codeParts)
                                  if (code.isNotEmpty)

                                    Container(
                                      padding: const EdgeInsets.all(PADDING_VERTICAL_12),
                                      margin: const EdgeInsets.only(bottom: PADDING_ONLY_BOTTOM_16),  // increased space between containers

                                      decoration: BoxDecoration(
                                        color: isUserMessage ? USER_MESSAGE_COLOR : AI_RESPONSE_COLOR,  // set background color based on message type(user/AI)
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),

                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      ),

                                      child: Stack(
                                        children: [

                                          Text(
                                            code,
                                            style: const TextStyle(
                                              color: AI_TEXT_COLOR,  // set text color to white for code parts
                                              fontFamily: COURIER_FONT_FAMILY,  // use a monospaced font for code
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),

                                          Positioned(
                                            top: 0.0,  // move 'copy' icon to the top
                                            right: 0.0,  // move 'copy' icon to the right
                                            child: IconButton(
                                              icon: const Icon(Icons.copy, color: Colors.white),

                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(text: code));
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text(SNACKBAR_COPIED_TO_CLIPBOARD)),
                                                );
                                              }, // end 'onPressed()'
                                            ),

                                          ),

                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),

              // input field positioned at the bottom of the page
              Padding(
                padding: const EdgeInsets.only(bottom: PADDING_ONLY_BOTTOM_16), // add bottom padding
                child: ChatInputField(
                  controller: chatController.inputController, // pass input controller
                  onSend: () => chatController.generateResponse(context), // pass the 'onSend' callback
                  chatController: chatController,  // pass the 'chatController'
                ),
              ),

            ],  // end of 'Column' children list

          ),  // end of 'Column' widget

        );  // end of 'Padding' widget

      },  // end of 'builder' method

    );  // end of Consumer widget
  } // end 'build' overridden method

}  // end of ChatTab widget class