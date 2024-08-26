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
import 'package:towers/components/login_system/screens/LoginPage.dart';


class ChatScreen extends StatelessWidget {  // main chat screen widget extending StatelessWidget

  final Conversation? conversation;  // optional conversation for initializing
  final String userEmail;  // user email required for initializing

  const ChatScreen({super.key, this.conversation, required this.userEmail});  // constructor to initialize the chat screen

  @override
  Widget build(BuildContext context) {
    // access 'EmailSignInProvider' or 'GoogleSignInProvider' to get user's email
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false);

    final currentUserEmail = emailSignInProvider.user?.email! ?? googleSignInProvider.userEmail ?? userEmail;

    if (currentUserEmail == null || currentUserEmail.isEmpty) {  // Check if userEmail is empty or null
      // navigate to 'LoginPage' if user's email is missing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      });

      // return a loading indicator while navigating
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),  // show loading indicator
      );
    }

    return ChangeNotifierProvider<ChatController>(  // provide 'ChatController' to the widget tree
      create: (_) {

        final conversationService = ConversationService(ConversationRepository());  // Create 'ConversationService' instance
        final geminiRepository = GeminiRepository();  // create 'GeminiRepository' instance
        final responseGenerationService = ResponseGenerationService(geminiRepository);  // Create 'ResponseGenerationService' instance

        final chatController = ChatController(
          responseGenerationService,  // pass 'ResponseGenerationService' instance
          conversationService,  // pass 'ConversationService' instance
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
            title: Text('Chat - $currentUserEmail'),  // AppBar with screen title
            automaticallyImplyLeading: false,  // remove the back navigation arrow

            actions: [  // actions to show buttons on the right side of the 'AppBar'

              IconButton(
                icon: const Icon(Icons.logout),

                onPressed: () async {
                  // access 'EmailSignInProvider' & call its 'signOut' method
                  await emailSignInProvider.signOut(context);

                  if (context.mounted) {
                    // access 'GoogleSignInProvider' and call its 'signOut' method
                    await googleSignInProvider.signOut(context);

                    if (context.mounted) {
                      // navigate back to 'LoginPage'
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );  // end 'Navigator' 'pushReplacement'
                    }
                  }

                },  // end asynchronous 'onPressed()'
              ),

              IconButton(
                icon: const Icon(Icons.add),  // icon for the button

                onPressed: () {
                  // access 'ChatController' using context.read()
                  final chatController = context.read<ChatController>();

                  // create a new conversation and navigate to it
                  chatController.createNewConversation(context);  // Pass context to createNewConversation
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

          body: TabBarView(
            children: [

              ChatTab(userEmail: currentUserEmail),  // pass 'userEmail' to 'ChatTab'
              SavedConversationsTab(userEmail: currentUserEmail),  // pass 'userEmail' to 'SavedConversationsTab'

            ],

          ),
        ),  // end of 'Scaffold' widget
      ),  // end of 'DefaultTabController'
    );  // end of 'ChangeNotifierProvider'
  }  // end 'build' method
}  // end of 'ChatScreen' class