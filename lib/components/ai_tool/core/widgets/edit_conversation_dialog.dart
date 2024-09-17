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

  // Get the screen size
  final Size screenSize = MediaQuery.of(context).size;

  // show a dialog with a text field for editing the title
  return showDialog(
    context: context,
    builder: (BuildContext context) {
    
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
      
        title: const Text(
          'Edit Conversation',
          style: TextStyle(color: Colors.white),
        ),
       
        content: SizedBox(
          width: screenSize.width < 600 ? double.maxFinite : 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,  // controller for the text field
                decoration: const InputDecoration(
                  hintText: 'Enter new title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
          
            ],
          ),
        ),
        
        actions: <Widget>[
         
          // button to cancel editing
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey,  // Text color
            ),
            child: const Text('Cancel'),
           
            onPressed: () {
              Navigator.of(context).pop();  // Close the dialog
            },
          ),
          
          // button to save the edited title
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
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
         
          // Delete button
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,  // Red color for delete
            ),
            child: const Text('Delete'),
            onPressed: () async {
              // Delete the conversation from Firestore
              await Provider.of<ConversationRepository>(context, listen: false)
                  .deleteConversation(userEmail, conversationId);
              if (context.mounted) {
                Navigator.of(context).pop(); // Close the dialog
                // You might want to add navigation logic here
                // to go back to the previous screen after deletion
              }
            },
          ),
        ],
      
      );
    },
  );
} // end 'showEditConversationDialog' function