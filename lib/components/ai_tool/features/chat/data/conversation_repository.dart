import 'package:cloud_firestore/cloud_firestore.dart';  // for Firestore interaction
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // for Flutter widgets
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';  // for conversation model


class ConversationRepository extends ChangeNotifier {  // repository class for managing conversations

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // instance of Firestore

  // method to get all conversations for a user
  // this returns a stream of snapshots from the conversations collection
  Stream<QuerySnapshot> getConversationsStream(String userEmail) {
    return _firestore
        .collection('users')  // Firestore collection for users
        .doc(userEmail)  // document for specific user
        .collection('conversations')  // subcollection for conversations
        .orderBy('lastModified', descending: true)  // order conversations by 'lastModified' in descending order
        .snapshots();  // get conversation collection stream for user

  }  // end of 'getConversationsStream' method

  // method to get a specific conversation by id for a user
  // this returns a future of the document snapshot for the conversation
  Future<DocumentSnapshot> getConversation(String userEmail, String conversationId) {
    return _firestore
        .collection('users')  // Firestore collection for users
        .doc(userEmail)  // document for specific user
        .collection('conversations')  // subcollection for conversations
        .doc(conversationId)  // document for specific conversation
        .get();  // get document by id for user

  }  // end of 'getConversation' method

  // method to create or update a conversation for a user
  // this saves or updates the conversation document in Firestore
  Future<void> saveConversation(String userEmail, Conversation conversation) async {

    // validate inputs
    if (userEmail.isEmpty) {
      throw ArgumentError('User email cannot be empty');  // throw error if user email is empty
    }

    if (conversation.id.isEmpty) {
      throw ArgumentError('Conversation ID cannot be empty');  // throw error if conversation ID is empty
    }

    final path = 'users/$userEmail/conversations/${conversation.id}';  // path to the Firestore document

    if (kDebugMode) {
      print('Saving conversation to path: $path');
    }  // debugging statement

    try {

      await _firestore
          .collection('users')  // Firestore collection for users
          .doc(userEmail)  // document for specific user
          .collection('conversations')  // subcollection for conversations
          .doc(conversation.id)  // document for specific conversation
          .set(
        conversation.toMap()
          ..putIfAbsent('lastModified', () => DateTime.now())  // ensure 'lastModified' is updated
          ..putIfAbsent('createdAt', () => DateTime.now()),  // ensure 'createdAt' is set if not already present
        SetOptions(merge: true),  // merge with existing document

      );  // save conversation for user

    } catch (e) {

      if (kDebugMode) {
        print('Error saving conversation: $e');
      }  // log error if saving fails

      rethrow;  // rethrow exception to be handled by the caller

    } // end 'CATCH'

  }  // end of 'saveConversation' method

  // method to update the title of a specific conversation
  // this updates only the title field of the conversation document in Firestore
  Future<void> updateConversationTitle(String userEmail, String conversationId, String newTitle) async {

    // validate inputs
    if (userEmail.isEmpty) {
      throw ArgumentError('User email cannot be empty');  // throw error if user email is empty
    }

    if (conversationId.isEmpty) {
      throw ArgumentError('Conversation ID cannot be empty');  // throw error if conversation ID is empty
    }

    final path = 'users/$userEmail/conversations/$conversationId';  // path to the Firestore document

    if (kDebugMode) {
      print('Updating conversation title at path: $path');
    }  // debugging statement

    try {

      await _firestore
          .collection('users')  // Firestore collection for users
          .doc(userEmail)  // document for specific user
          .collection('conversations')  // subcollection for conversations
          .doc(conversationId)  // document for specific conversation
          .update(
        {
          'title': newTitle,  // update the title field
          'lastModified': DateTime.now(),  // ensure 'lastModified' is updated
        },
      );  // update conversation title for user

    } catch (e) {

      if (kDebugMode) {
        print('Error updating conversation title: $e');
      }  // log error if updating fails

      rethrow;  // rethrow exception to be handled by the caller

    } // end 'CATCH'

  }  // end of 'updateConversationTitle' method

}  // end of 'ConversationRepository' class