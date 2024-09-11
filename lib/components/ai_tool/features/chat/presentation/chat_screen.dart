import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/core/widgets/chat_tab.dart';
import 'package:towers/components/ai_tool/core/widgets/saved_conversations_tab.dart';
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';  // for conversation repository
import 'package:towers/components/ai_tool/features/chat/data/gemini_repository.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // for conversation service
import 'package:towers/components/ai_tool/features/chat/domain/response_generation_service.dart';  // for response generation service
import 'package:towers/components/ai_tool/features/chat/controllers/chat_controller.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';
import 'package:towers/components/ai_tool/features/options/widgets/user_avatar.dart';  // import the UserAvatar widget


class ChatScreen extends StatefulWidget {  // main chat screen widget extending StatefulWidget

  final Conversation? conversation;  // optional conversation for initializing
  final String userEmail;  // user email required for initializing

  const ChatScreen({super.key, this.conversation, required this.userEmail});  // constructor to initialize the chat screen

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isDrawerOpen = true;  // Track the visibility of the SavedConversationsTab

  @override
  Widget build(BuildContext context) {
    // access 'EmailSignInProvider' or 'GoogleSignInProvider' to get user's email
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false);

    // get & validate the user's email
    String? emailFromProvider = emailSignInProvider.user?.email;
    String? emailFromGoogle = googleSignInProvider.userEmail;
    String currentUserEmail = emailFromProvider ?? emailFromGoogle ?? widget.userEmail;

    debugPrint('Email from EmailSignInProvider: $emailFromProvider');
    debugPrint('Email from GoogleSignInProvider: $emailFromGoogle');
    debugPrint('Current User Email: $currentUserEmail');

    if (currentUserEmail.isEmpty) {  // Check if userEmail is empty
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

    return LayoutBuilder(  // add 'LayoutBuilder' for responsive design
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth >= 600;  // determine if the screen is large

        return ChangeNotifierProvider<ChatController>(  // provide 'ChatController' to the widget tree
          create: (_) {

            final conversationService = ConversationService(ConversationRepository());  // Create 'ConversationService' instance
            final geminiRepository = GeminiRepository();  // create 'GeminiRepository' instance
            final responseGenerationService = ResponseGenerationService(geminiRepository);  // Create 'ResponseGenerationService' instance

            final chatController = ChatController(
              responseGenerationService,  // pass 'ResponseGenerationService' instance
              conversationService,  // pass 'ConversationService' instance
            );

            if (widget.conversation != null) {
              chatController.initializeConversation(widget.conversation!);  // initialize with the existing conversation
            }

            return chatController;
          },  // create 'ChatController'

          child: Scaffold(
            appBar: AppBar(
              title: Text('Chat - $currentUserEmail'),  // AppBar with screen title
              automaticallyImplyLeading: false,  // remove the back navigation arrow

              leading: isLargeScreen  // show the toggle button on large screens
                  ? IconButton(
                icon: Icon(isDrawerOpen ? Icons.arrow_back_ios_rounded : Icons.ad_units_sharp),
                onPressed: () {
                  setState(() {
                    isDrawerOpen = !isDrawerOpen;  // toggle drawer visibility
                  });
                },
              )
                  : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu), // icon for the drawer
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // open the drawer
                  },
                ),
              ),

              actions: [ // actions to show buttons on the right side of the 'AppBar'
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: UserAvatar(email: currentUserEmail), // pass email to 'UserAvatar' widget
                ),
              ],

            ),

            drawer: !isLargeScreen
                ? Drawer(
              child: SavedConversationsTab(userEmail: currentUserEmail), // add 'SavedConversationsTab' as drawer content
            )
                : null,  // conditionally show the drawer on smaller screens

            body: Row(  // use Row to layout the content side by side on large screens

              children: [

                if (isLargeScreen && isDrawerOpen)
                  SizedBox(
                    width: 250,  // set the width for the drawer content on large screens
                    child: SavedConversationsTab(userEmail: currentUserEmail), // add 'SavedConversationsTab' inline for large screens
                  ),

                Expanded(
                  child: ChatTab(userEmail: currentUserEmail),  // main chat content with single 'ChatInputField'
                ),

              ],

            ),

          ),  // end of 'Scaffold' widget

        );  // end of 'ChangeNotifierProvider'
      },
    ); // end of 'LayoutBuilder'
  }  // end 'build' method
}  // end of '_ChatScreenState' class