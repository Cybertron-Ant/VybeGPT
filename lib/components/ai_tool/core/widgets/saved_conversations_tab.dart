import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_controller.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';


class SavedConversationsTab extends StatelessWidget {
  const SavedConversationsTab({super.key});  // constructor with optional key

  @override
  Widget build(BuildContext context) {
    // access 'userEmail' from 'ChatController'
    final userEmail = Provider.of<ChatController>(context, listen: false).userEmail;

    // get the stream of conversations from the repository
    final conversationsStream = Provider.of<ConversationRepository>(context).getConversationsStream(userEmail);

    return StreamBuilder<QuerySnapshot>(  // StreamBuilder to listen to Firestore data changes
      stream: conversationsStream,  // stream of conversation documents
      builder: (context, snapshot) {  // builder method to update UI based on snapshot

        // show a loading spinner while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());  // loading spinner
        }

        // show an error message if there is an error in the snapshot
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));  // error message
        }

        // show a message if there are no conversations
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No saved conversations.'));  // no conversations message
        }

        // convert snapshot documents to Conversation objects
        final conversations = snapshot.data!.docs.map((doc) => Conversation.fromDocument(doc)).toList();

        return ListView.builder(  // 'ListView' to display conversations
          itemCount: conversations.length,  // number of items in the list

          itemBuilder: (context, index) {  // builder method for each list item
            final conversation = conversations[index];  // get conversation at index

            return ListTile(  // 'ListTile' widget to show conversation

              title: Text(

                // display only the first 50 characters & add an ellipsis if needed
                conversation.title.length > 50
                    ? '${conversation.title.substring(0, 50)}...'  // truncate & add ellipsis
                    : conversation.title,  // full title
                overflow: TextOverflow.ellipsis,  // ensure ellipsis if text overflows
                maxLines: 1,  // limit text to one line

              ),

              subtitle: Text(

                // display only the first 50 characters and add an ellipsis if needed
                conversation.lastMessage.length > 50
                    ? '${conversation.lastMessage.substring(0, 50)}...'  // truncate and add ellipsis
                    : conversation.lastMessage,  // full last message
                overflow: TextOverflow.ellipsis,  // ensure ellipsis if text overflows
                maxLines: 1,  // limit text to one line

              ),

              onTap: () {

                // navigate to 'ChatScreen' & pass the conversation data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // pass 'userEmail' & conversation to 'ChatScreen'
                    builder: (context) => ChatScreen(userEmail: userEmail, conversation: conversation),
                  ),
                );

              },

            );
          },
        );
      }, // end 'builder' method
    );
  } // end 'build' overridden method

} // end of 'SavedConversationsTab' widget class