import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';


// function to show a dialog for editing the conversation title
Future<void> showEditConversationDialog({

  required BuildContext context,
  required String userEmail,
  required String conversationId,
  required String initialTitle,

}) async {

  // create a text controller with the initial title
  final TextEditingController titleController = TextEditingController(text: initialTitle);

  // show a dialog with a text field for editing the title
  return showDialog(
    context: context,
    builder: (BuildContext context) {

      return AlertDialog(
        title: const Text('Edit Conversation Title'),  // dialog title

        content: TextField(
          controller: titleController,  // controller for the text field
          decoration: const InputDecoration(hintText: 'Enter new title'),  // hint text for the text field
        ),

        actions: <Widget>[

          // button to cancel editing
          TextButton(
            child: const Text('Cancel'),

            onPressed: () {
              Navigator.of(context).pop();  // close the dialog
            },
          ),

          // button to save the edited title
          TextButton(
            child: const Text('Save'),

            onPressed: () async {
              final newTitle = titleController.text.trim();  // get the new title from the text field

              if (newTitle.isNotEmpty) {

                // update the 'title' in Firestore
                await Provider.of<ConversationRepository>(context, listen: false)
                    .updateConversationTitle(userEmail, conversationId, newTitle);  // provide all 3 arguments

                if (context.mounted) {
                  Navigator.of(context).pop();  // close the dialog
                }

              }
            },
          ),

        ],

      );
    },
  );
} // end 'showEditConversationDialog' function