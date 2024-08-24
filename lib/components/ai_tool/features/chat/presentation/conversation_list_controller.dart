import 'package:flutter/material.dart';  // for state management
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // conversation service


class ConversationListController extends ChangeNotifier {  // controller for managing the list of conversations

  final ConversationService _service;  // service instance
  late Stream<List<Conversation>> _conversationsStream;  // stream of conversations
  List<Conversation> _conversations = [];  // list of conversations
  String? _selectedConversationId;  // ID of the selected conversation

  // constructor initializing the 'ConversationService' service
  ConversationListController(this._service);  // initialize with the provided ConversationService

  // method to get the stream of conversations
  Stream<List<Conversation>> getConversationsStream(String userEmail) {

    _conversationsStream = _service.getConversationsStream(userEmail);  // update stream with user email

    // listen to the stream and update the list of conversations
    _conversationsStream.listen((conversations) {
      _conversations = conversations;  // update the conversations list
      notifyListeners();  // notify listeners about the change
    });

    return _conversationsStream;  // return the updated stream

  } // end 'getConversationsStream' method

  // method to get the list of conversations
  List<Conversation> get conversations => _conversations;  // return the list of conversations

  // method to get the currently selected conversation
  Conversation? get selectedConversation {

    try {
      return _conversations.firstWhere(
            (c) => c.id == _selectedConversationId,  // find the conversation with the matching ID
      );
    } catch (e) {
      return null;  // return null if no match is found
    }

  } // end 'selectedConversation' method

  // method to select a conversation and perform actions
  Future<void> selectConversation(String userEmail, String id) async {
    _selectedConversationId = id;  // update selected conversation ID
    notifyListeners();  // notify listeners about the selection change

    // additional logic (if needed) to handle selected conversation
    // example: fetch detailed information or update UI
  }

}  // end of 'ConversationListController' class