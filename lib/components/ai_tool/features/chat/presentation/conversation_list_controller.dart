import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // for state management
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // conversation service


class ConversationListController extends ChangeNotifier {  // controller for managing the list of conversations

  final ConversationService _service;  // service instance
  late Stream<List<Conversation>> _conversationsStream;  // stream of conversations
  List<Conversation> _conversations = [];  // list of conversations
  String? _selectedConversationId;  // ID of the selected conversation
  bool _isLoading = false;  // loading state
  bool _hasMore = true;  // flag to check if more data is available
  int _offset = 0;  // current offset for pagination
  final int _limit = 15;  // number of conversations to load per request

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

  // method to load more conversations with pagination
  Future<void> loadMoreConversations(String userEmail) async {

    if (_isLoading || !_hasMore) return;  // return if already loading or no more data

    _isLoading = true;  // set loading state
    notifyListeners();  // notify listeners about the loading state change

    try {

      final newConversations = await _service.loadConversations(
        userEmail,
        offset: _offset,
        limit: _limit,
      );

      if (newConversations.isEmpty) {
        _hasMore = false;  // no more data available
      } else {
        _offset += newConversations.length;  // update offset
        _conversations.addAll(newConversations);  // add new conversations to the list
      } // end ELSE

    } catch (e) {
      // handle error (if needed)
      if (kDebugMode) {
        print(e);
      }

    } finally {
      _isLoading = false;  // reset loading state
      notifyListeners();  // notify listeners about the loading state change
    } // end 'FINALLY'

  } // end 'loadMoreConversations' method

}  // end of 'ConversationListController' class