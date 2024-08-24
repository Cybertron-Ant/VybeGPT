import 'package:flutter/material.dart';  // for Flutter material design widgets
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';  // for Conversation class
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // for ConversationService
import 'package:towers/components/ai_tool/features/chat/domain/response_generation_service.dart';  // for ResponseGenerationService
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';  // for ChatScreen
import 'package:towers/components/ai_tool/features/chat/utils/title_generator.dart';


// define the 'ChatController' class which extends 'ChangeNotifier'
class ChatController extends ChangeNotifier {

  // dependencies for generating responses & managing conversations
  final ResponseGenerationService _responseGenerationService;  // service for generating responses
  final ConversationService _conversationService;  // service for managing conversations
  final String _userEmail;  // email of the user

  // controller for managing text input from the user
  final TextEditingController inputController = TextEditingController();  // controller for text input

  // internal state for response text & conversation messages
  String _responseText = '';  // stores generated response text
  final List<String> _messages = [];  // list of messages in the conversation
  Conversation? _currentConversation;  // current active conversation

  // constructor for initializing the ChatController with required services & user email
  ChatController(
      this._responseGenerationService,  // initialize response generation service
      this._conversationService,  // initialize conversation service
      this._userEmail,  // initialize user email
      ) {
    if (_userEmail.isEmpty) {
      throw ArgumentError('User email cannot be empty');  // throw error if user email is empty
    }
  }

  // public getter for response text
  String get responseText => _responseText;  // returns the response text

  // public getter for messages
  List<String> get messages => _messages;  // returns the list of messages

  // public getter for user email
  String get userEmail => _userEmail;  // returns the user email

  // public getter for the current conversation
  Conversation? get currentConversation => _currentConversation;  // returns current conversation

  // method to generate a response based on user input
  Future<void> generateResponse() async {
    // Get the input text from the controller
    String inputText = inputController.text;  // user input text

    // add the input text to the messages list
    _messages.add(inputText);  // add input text to messages

    // generate a response from the response generation service
    _responseText = await _responseGenerationService.generateResponse(inputText);  // generate response

    // add the generated response to the messages list
    _messages.add(_responseText);  // add response text to messages

    // auto-generate the title from all messages as a summary
    String title = generateTitleFromMessages(_messages);  // generate title from messages

    if (_currentConversation == null) {

      // initialize a new conversation if none exists
      _currentConversation = Conversation(

        id: DateTime.now().millisecondsSinceEpoch.toString(),  // unique conversation id
        title: title,  // auto-generated title
        messages: _messages,  // add messages to conversation
        createdAt: DateTime.now(),  // set creation time
        lastModified: DateTime.now(),  // initialize last modified time

      );

    } else {

      // update existing conversation with a new instance
      _currentConversation = Conversation(

        id: _currentConversation!.id,  // retain existing conversation id
        title: title,  // update title
        messages: _messages,  // update messages
        createdAt: _currentConversation!.createdAt,  // retain existing creation time
        lastModified: DateTime.now(),  // update last modified time

      );

    }

    if (_userEmail.isNotEmpty) {

      // save the conversation if user email is valid
      await _conversationService.saveConversation(_userEmail, _currentConversation!);  // save conversation
    } else {
      throw ArgumentError('User email cannot be empty');  // throw error if user email is empty
    }

    notifyListeners();  // notify listeners of state changes
  }

  // method to initialize conversation with existing data
  void initializeConversation(Conversation conversation) {

    _currentConversation = conversation;  // set current conversation
    _messages.clear();  // clear existing messages
    _messages.addAll(conversation.messages);  // add messages from the conversation
    notifyListeners();  // notify listeners of state changes

  }

  // method to reset the current conversation
  void resetConversation() {
    _currentConversation = null;  // clear current conversation
    _messages.clear();  // clear messages
    notifyListeners();  // notify listeners of state changes
  }

  // method to create a new conversation and navigate to 'ChatScreen'
  void createNewConversation(BuildContext context) {

    // create a new conversation instance
    final newConversation = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),  // unique conversation id
      title: 'New Conversation',  // default title
      messages: [],  // empty messages list
      createdAt: DateTime.now(),  // set creation time
      lastModified: DateTime.now(),  // initialize last modified time

    );

    initializeConversation(newConversation);  // initialize with the new conversation

    // Navigate to 'ChatScreen' with the new conversation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userEmail: _userEmail,  // pass user email
          conversation: newConversation,  // pass new conversation
        ),
      ),
    );
  }

} // end of 'ChatController' class