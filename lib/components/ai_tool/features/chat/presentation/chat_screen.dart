import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/core/widgets/chat_tab.dart';
import 'package:towers/components/ai_tool/core/widgets/saved_conversations_tab.dart';
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';  // for conversation repository
import 'package:towers/components/ai_tool/features/chat/data/gemini_repository.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // for conversation service
import 'package:towers/components/ai_tool/features/chat/domain/response_generation_service.dart';  // for response generation service
import 'package:towers/components/ai_tool/features/chat/presentation/chat_controller.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';  // for chat controller


class ChatScreen extends StatelessWidget {  // main chat screen widget extending StatelessWidget

  final String userEmail;  // user email address for saving conversations
  final Conversation? conversation;  // optional conversation for initializing

  const ChatScreen({super.key, required this.userEmail, this.conversation});  // constructor to initialize the chat screen

  @override
  Widget build(BuildContext context) {
    if (userEmail.isEmpty) {  // check if userEmail is empty
      // show an error message or handle it accordingly
      return const Scaffold(
        body: Center(child: Text('Error: User email cannot be empty')),
      );
    }

    return ChangeNotifierProvider<ChatController>(  // provide 'ChatController' to the widget tree
      create: (_) {

        final conversationService = ConversationService(ConversationRepository());  // create 'ConversationService' instance
        final geminiRepository = GeminiRepository();  // create 'GeminiRepository' instance
        final responseGenerationService = ResponseGenerationService(geminiRepository);  // create 'ResponseGenerationService' instance

        final chatController = ChatController(
          responseGenerationService,  // pass 'ResponseGenerationService' instance
          conversationService,  // pass 'ConversationService' instance
          userEmail,  // pass userEmail as a parameter
        );

        if (conversation != null) {
          chatController.initializeConversation(conversation!);  // initialize with the existing conversation
        }

        return chatController;
      },  // create 'ChatController'

      child: DefaultTabController(
        length: 2,  // number of tabs

        child: Scaffold(

          appBar: AppBar(
            title: const Text('Chat with AI'),  // AppBar with screen title
            automaticallyImplyLeading: false,  // remove the back navigation arrow

            actions: [  // actions to show buttons on the right side of the 'AppBar'

              IconButton(
                icon: const Icon(Icons.logout),

                onPressed: () async {
                  // access 'EmailSignInProvider' & call its 'signOut' method
                  await Provider.of<EmailSignInProvider>(context, listen: false).signOut(context);

                  if (context.mounted) {
                    // access 'GoogleSignInProvider' and call its 'signOut' method
                    await Provider.of<GoogleSignInProvider>(context, listen: false).signOut(context);
                  }

                  if (context.mounted) {
                    // navigate back to 'LoginPage'
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );  // end 'Navigator' 'pushReplacement'
                  }

                },  // end asynchronous 'onPressed()'
              ),

              IconButton(
                icon: const Icon(Icons.add),  // icon for the button

                onPressed: () {
                  // access 'ChatController' using context.read()
                  final chatController = context.read<ChatController>();

                  // create a new conversation and navigate to it
                  chatController.createNewConversation(context);  // pass context to createNewConversation
                },

              ),

            ],

            bottom: const TabBar(

              tabs: [

                Tab(text: 'Chat'),
                Tab(text: 'Saved Conversations'),

              ],

            ),
          ),

          body: const TabBarView(

            children: [

              ChatTab(),  // tab for the chat interface
              SavedConversationsTab(),  // tab for saved conversations

            ],

          ),
        ),  // end of 'Scaffold' widget
      ),  // end of 'DefaultTabController'
    );  // end of 'ChangeNotifierProvider'
  }  // end 'build' method
}  // end of 'ChatScreen' class