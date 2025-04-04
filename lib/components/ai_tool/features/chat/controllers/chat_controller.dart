import 'package:flutter/material.dart';  // for Flutter material design widgets
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';  // for Conversation class
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // for ConversationService
import 'package:towers/components/ai_tool/features/chat/domain/message.dart';
import 'package:towers/components/ai_tool/features/chat/domain/response_generation_service.dart';  // for ResponseGenerationService
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';  // for ChatScreen
import 'package:towers/components/ai_tool/features/chat/utils/title_generator.dart';  // for title generator
import 'package:provider/provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';  // for GoogleSignInProvider
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';  // for EmailSignInProvider


// define the 'ChatController' class which extends 'ChangeNotifier'
class ChatController extends ChangeNotifier {

  // dependencies for generating responses & managing conversations
  final ResponseGenerationService _responseGenerationService;  // service for generating responses
  final ConversationService _conversationService;  // service for managing conversations

  // controller for managing text input from the user
  final TextEditingController inputController = TextEditingController();  // controller for text input

  // internal state for response text & conversation messages
  String _responseText = '';  // stores generated response text
  final List<Message> _messages = [];  // list of messages in the conversation
  Conversation? _currentConversation;  // current active conversation
  bool isConversationActive = false;  // track if a conversation is active

  // constructor for initializing the ChatController with required services
  ChatController(
      this._responseGenerationService,  // initialize response generation service
      this._conversationService,  // initialize conversation service
      ) {
    // no need to check for 'userEmail' in constructor
  }

  // public getter for response text
  String get responseText => _responseText;  // returns the response text

  // public getter for messages
  List<Message> get messages => _messages;  // returns the list of messages

  // public getter for the current conversation
  Conversation? get currentConversation => _currentConversation;  // returns current conversation

  // method to generate a response based on user input
  Future<void> generateResponse(BuildContext context) async {
    // Get the input text from the controller
    String inputText = inputController.text;  // user input text

    // add the input text as a user message
    _messages.add(Message(text: inputText, isUser: true));  // add input text as a user message

    // generate a response from the response generation service
    _responseText = await _responseGenerationService.generateResponse(inputText);  // generate response

    // add the generated response as an AI message
    _messages.add(Message(text: _responseText, isUser: false));  // add response text as AI message

    // auto-generate the title from all messages as a summary
    String title = generateTitleFromMessages(_messages.map((m) => m.text).toList());  // generate title from messages

    if (context.mounted) {
      // fetch user email from 'GoogleSignInProvider'
      final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
      final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);
      final userEmail = googleSignInProvider.userEmail ?? emailSignInProvider.user!.email!;

      if (_currentConversation == null && context.mounted) {

        // initialize a new conversation if none exists
        _currentConversation = Conversation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),  // unique conversation id
          title: title,  // auto-generated title
          messages: _messages.map((m) => m.text).toList(),  // add messages to conversation
          createdAt: DateTime.now(),  // set creation time
          lastModified: DateTime.now(),  // initialize last modified time
        );

      } else {

        // update existing conversation with a new instance
        _currentConversation = Conversation(

          id: _currentConversation!.id,  // retain existing conversation id
          title: title,  // update title
          messages: _messages.map((m) => m.text).toList(),  // update messages
          createdAt: _currentConversation!.createdAt,  // retain existing creation time
          lastModified: DateTime.now(),  // update last modified time
        );

      }

      if (userEmail != null && userEmail.isNotEmpty && context.mounted) {

        // save the conversation if user email is valid
        await _conversationService.saveConversation(userEmail, _currentConversation!);  // save conversation
      } else {
        throw ArgumentError('User email cannot be empty');  // throw error if user email is empty
      }

      isConversationActive = true;  // set active when a conversation is started
      notifyListeners();  // notify listeners of state changes
    }
  }

  // method to initialize conversation with existing data
  void initializeConversation(Conversation conversation) {

    _currentConversation = conversation;  // set current conversation
    _messages.clear();  // clear existing messages
    _messages.addAll(conversation.messages.map((text) {
      // debug to check message state
      print('Loading message: $text');
      return Message(text: text, isUser: false);
    }));  // add messages from the conversation
    isConversationActive = true;  // set active when a conversation is initialized
    notifyListeners();  // notify listeners of state changes

  }

  // method to reset the current conversation
  void resetConversation() {
    _currentConversation = null;  // clear current conversation
    _messages.clear();  // clear messages
    isConversationActive = false;  // set inactive when the conversation is reset
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

    // fetch user email from 'GoogleSignInProvider' or 'EmailSignInProvider'
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);
    final userEmail = googleSignInProvider.userEmail ?? emailSignInProvider.user!.email!;

    isConversationActive = true;  // set active when a new conversation is created
    notifyListeners();  // notify listeners of state changes

    // Navigate to 'ChatScreen' with the new conversation and user email
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          conversation: newConversation,  // pass new conversation
          userEmail: userEmail ?? '',  // pass user email (default to empty string if null)
        ),
      ),
    );
  }

} // end of 'ChatController' class