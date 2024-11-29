import 'package:cloud_firestore/cloud_firestore.dart';  // for Firestore interaction
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // for Flutter widgets
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';  // for conversation model


class ConversationRepository extends ChangeNotifier {  // repository class for managing conversations

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // instance of Firestore
  late Stream<List<Conversation>> _conversationsStream;

  // constructor to initialize the repository
  ConversationRepository();

  // method to get the conversations stream for a specific user
  Stream<List<Conversation>> getConversationsStream(String userEmail) {
    _conversationsStream = _firestore
        .collection('users')  // Firestore collection for users
        .doc(userEmail)  // document for specific user
        .collection('conversations')  // subcollection for conversations
        .orderBy('lastModified', descending: true)  // order conversations by 'lastModified' in descending order
        .snapshots()  // get conversation collection stream for user
        .handleError((error) {
          if (kDebugMode) {
            print('Error fetching conversations stream: $error');
          }
        })
        .map((snapshot) {
          return snapshot.docs.map((doc) => Conversation.fromDocument(doc)).toList();
        });

    // listen to the stream and notify listeners on changes
    _conversationsStream.listen((_) {
      notifyListeners();  // notify listeners about the change
    });

    return _conversationsStream;  // return the stream
  }  // end of 'getConversationsStream' method

  // method to get a specific conversation by id for a user
  // this returns a future of the document snapshot for the conversation
  Future<DocumentSnapshot<Map<String, dynamic>>> getConversation(String userEmail, String conversationId) {
    return _firestore
        .collection('users')  // Firestore collection for users
        .doc(userEmail)  // document for specific user
        .collection('conversations')  // subcollection for conversations
        .doc(conversationId)  // document for specific conversation
        .get() // get document by id for user
        .catchError((error) {
          if (kDebugMode) {
            print('Error fetching conversation: $error');
          }
        });
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

      notifyListeners();  // notify listeners about the change

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

      notifyListeners();  // notify listeners about the change

    } catch (e) {

      if (kDebugMode) {
        print('Error updating conversation title: $e');
      }  // log error if updating fails

      rethrow;  // rethrow exception to be handled by the caller

    } // end 'CATCH'

  }  // end of 'updateConversationTitle' method

  /// Loads conversations for a given user with pagination support
  /// [userEmail] can be null, in which case an empty list is returned
  /// [offset] determines the starting point for pagination (default: 0)
  /// [limit] determines the maximum number of conversations to load (default: 15)
  /// Returns a List of Conversation objects, or empty list if there's an error
  Future<List<Conversation>> loadConversations(String? userEmail,
      {int offset = 0, int limit = 15}) async {
    try {
      // Safety check: Return empty list if no valid user email
      if (userEmail == null || userEmail.isEmpty) {
        debugPrint('Warning: Attempted to load conversations with null/empty email');
        return [];
      }

      // Ensure limit is positive
      if (limit <= 0) {
        debugPrint('Warning: Invalid limit ($limit). Using default limit of 15');
        limit = 15;
      }

      // Ensure offset is non-negative
      if (offset < 0) {
        debugPrint('Warning: Invalid offset ($offset). Using 0');
        offset = 0;
      }

      QuerySnapshot querySnapshot;
      // Get the last document for pagination
      final lastDocument = await _getLastDocument(userEmail, offset);

      // If we have a last document and offset > 0, start after it for pagination
      if (lastDocument != null && offset > 0) {
        querySnapshot = await _firestore
            .collection('users')  // Firestore collection for users
            .doc(userEmail)  // document for specific user
            .collection('conversations')  // subcollection for conversations
            .orderBy('lastModified', descending: true)  // Most recent conversation(s) first
            .startAfterDocument(lastDocument)  // pagination start
            .limit(limit)  // limit the number of conversations loaded
            .get();  // get conversations for user with pagination
      } else {
        // First page or no previous documents
        querySnapshot = await _firestore
            .collection('users')// collection for users
            .doc(userEmail)  // document for specific user
            .collection('conversations')
            .orderBy('lastModified', descending: true)
            .limit(limit)
            .get();
      }// end 'else'

      try {
        // Convert Firestore documents to Conversation objects
        return querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Conversation.fromMap(doc.id, data);
        }).toList();
      } catch (conversionError) {
        // Log document conversion error and return empty list
        debugPrint('Error converting conversation documents: $conversionError');
        return [];
      }// end 'catch'
    } catch (e) {
      // Log error and return empty list instead of rethrowing
      debugPrint('Error loading conversations: $e');
      return [];
    }// end 'catch'
  } // end of 'loadConversations' method

  // helper method to get the last document for pagination
  // this method fetches the last document based on offset
  Future<DocumentSnapshot<Map<String, dynamic>>?> _getLastDocument(String userEmail, int offset) async {
    // If offset is 0, return null as we don't need a last document for the first page
    if (offset <= 0) {
      return null;
    }

    final querySnapshot = await _firestore
        .collection('users')  // Firestore collection for users
        .doc(userEmail)  // document for specific user
        .collection('conversations')  // subcollection for conversations
        .orderBy('lastModified', descending: true)  // order conversations by 'lastModified' in descending order
        .limit(offset)  // limit to the offset value
        .get();  // get the last document for pagination

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return querySnapshot.docs.last;  // return the last document snapshot
  } // end of '_getLastDocument' helper method

  // method to delete a conversation
  Future<void> deleteConversation(String userEmail, String conversationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('conversations')
          .doc(conversationId)
          .delete();

      notifyListeners();  // notify listeners about the change

    } catch (e) {
      if (kDebugMode) {
        print('Error deleting conversation: $e');
      }
      rethrow;
    }
  } // end of 'deleteConversation' helper method

}  // end of 'ConversationRepository' class