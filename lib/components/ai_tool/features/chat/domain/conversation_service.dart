import 'package:flutter/material.dart';  // for state management
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';


class ConversationService extends ChangeNotifier {  // service for managing conversations

  final ConversationRepository _repository;  // repository instance for data operations

  // constructor initializing the repository
  ConversationService(this._repository);  // initialize with the provided ConversationRepository

  // method to get a stream of conversations for a given user
  Stream<List<Conversation>> getConversationsStream(String userEmail) {

    return _repository.getConversationsStream(userEmail)  // get the stream from the repository
    // map snapshot to list of conversations
        .map((snapshot) => snapshot.docs
    // create Conversation objects from document data
        .map((doc) => Conversation.fromMap(doc.id, doc.data() as Map<String, dynamic>))
    // convert to list
        .toList());

  }  // end of 'getConversationsStream' method

  // method to get a single conversation by ID
  Future<Conversation> getConversation(String userEmail, String conversationId) async {

    // fetch document from repository
    final doc = await _repository.getConversation(userEmail, conversationId);

    // create Conversation object from document data
    return Conversation.fromMap(doc.id, doc.data() as Map<String, dynamic>);

  }  // end of 'getConversation' method

  // method to save a conversation to the repository
  Future<void> saveConversation(String userEmail, Conversation conversation) {

    return _repository.saveConversation(userEmail, conversation);  // save conversation using repository

  }  // end of 'saveConversation' method

  // method to load conversations with pagination
  Future<List<Conversation>> loadConversations(String userEmail, {int offset = 0, int limit = 15}) async {
    final conversations = await _repository.loadConversations(userEmail, offset: offset, limit: limit);  // fetch data from repository
    return conversations;  // return the list of conversations directly
  }  // end of 'loadConversations' method

}  // end of 'ConversationService' class