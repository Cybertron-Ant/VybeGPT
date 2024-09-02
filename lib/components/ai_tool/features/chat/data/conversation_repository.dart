import 'package:cloud_firestore/cloud_firestore.dart';  // for Firestore interaction
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // for Flutter widgets
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';  // for conversation model


class ConversationRepository extends ChangeNotifier {  // repository class for managing conversations

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // instance of Firestore

  // method to get all conversations for a user
  // this returns a stream of snapshots from the conversations collection
  Stream<QuerySnapshot<Map<String, dynamic>>> getConversationsStream(String userEmail) {
    return _firestore
        .collection('users')  // Firestore collection for users
        .doc(userEmail)  // document for specific user
        .collection('conversations')  // subcollection for conversations
        .orderBy('lastModified', descending: true)  // order conversations by 'lastModified' in descending order
        .snapshots();  // get conversation collection stream for user

  }  // end of 'getConversationsStream' method

  // method to get a specific conversation by id for a user
  // this returns a future of the document snapshot for the conversation
  Future<DocumentSnapshot<Map<String, dynamic>>> getConversation(String userEmail, String conversationId) {
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

  // method to load conversations with pagination
  // this returns a list of conversations for a user with support for pagination
  Future<List<Conversation>> loadConversations(String userEmail, {int offset = 0, int limit = 15}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (offset > 0) {
        final lastDocument = await _getLastDocument(userEmail, offset);
        querySnapshot = await _firestore
            .collection('users')  // Firestore collection for users
            .doc(userEmail)  // document for specific user
            .collection('conversations')  // subcollection for conversations
            .orderBy('lastModified', descending: true)  // order conversations by 'lastModified' in descending order
            .startAfterDocument(lastDocument)  // pagination start
            .limit(limit)  // limit the number of conversations loaded
            .get();  // get conversations for user with pagination
      } else {
        querySnapshot = await _firestore
            .collection('users')  // Firestore collection for users
            .doc(userEmail)  // document for specific user
            .collection('conversations')  // subcollection for conversations
            .orderBy('lastModified', descending: true)  // order conversations by 'lastModified' in descending order
            .limit(limit)  // limit the number of conversations loaded
            .get();  // get conversations for user with pagination
      }

      return querySnapshot.docs.map((doc) => Conversation.fromDocument(doc)).toList();  // map query result to conversation list

    } catch (e) {

      if (kDebugMode) {
        print('Error loading conversations: $e');
      }  // log error if loading fails

      rethrow;  // rethrow exception to be handled by the caller

    } // end 'CATCH'

  }  // end of 'loadConversations' method

  // helper method to get the last document for pagination
  // this method fetches the last document based on offset
  Future<DocumentSnapshot<Map<String, dynamic>>> _getLastDocument(String userEmail, int offset) async {
    final querySnapshot = await _firestore
        .collection('users')  // Firestore collection for users
        .doc(userEmail)  // document for specific user
        .collection('conversations')  // subcollection for conversations
        .orderBy('lastModified', descending: true)  // order conversations by 'lastModified' in descending order
        .limit(offset)  // limit to the offset value
        .get();  // get the last document for pagination

    return querySnapshot.docs.last;  // return the last document snapshot

  }  // end of '_getLastDocument' helper method

  // method to delete a conversation
  Future<void> deleteConversation(String userEmail, String conversationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('conversations')
          .doc(conversationId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting conversation: $e');
      }
      rethrow;
    }
  } // end of 'deleteConversation' helper method

}  // end of 'ConversationRepository' class