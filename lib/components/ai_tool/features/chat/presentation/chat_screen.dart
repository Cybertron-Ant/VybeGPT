import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/core/widgets/chat_tab.dart';
import 'package:towers/components/ai_tool/core/widgets/saved_conversations_tab.dart';
import 'package:towers/components/ai_tool/features/background_color/providers/background_color_provider.dart';
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';  // for conversation repository
import 'package:towers/components/ai_tool/features/chat/data/ai_repository.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // for conversation service
import 'package:towers/components/ai_tool/features/chat/domain/response_generation_service.dart';  // for response generation service
import 'package:towers/components/ai_tool/features/chat/controllers/chat_controller.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';
import 'package:towers/components/ai_tool/features/options/widgets/user_avatar.dart';  // import the UserAvatar widget
import 'package:towers/components/ai_tool/features/loading_animations/shimmer_loading_indicator.dart';  // import shimmer loading indicator


class ChatScreen extends StatefulWidget {  // main chat screen widget extending StatefulWidget

  final Conversation? conversation;  // optional conversation for initializing
  final String userEmail;  // user email required for initializing

  const ChatScreen({super.key, this.conversation, required this.userEmail});  // constructor to initialize the chat screen

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isDrawerOpen = true;  // Track the visibility of the SavedConversationsTab
  late Future<List<Conversation>> _conversationsFuture;  // Future to load conversations

  @override
  void initState() {
    super.initState();
    _conversationsFuture = _loadConversations();  // initialize the future to load conversations
  }

  /// Loads conversations for the current user
  /// Returns an empty list if no user is signed in or if there's an error
  Future<List<Conversation>> _loadConversations() async {
    // Get required providers
    final conversationRepository = Provider.of<ConversationRepository>(context, listen: false);
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
    
    // Try to get user email from either provider
    // Null coalescing operator (??) tries email sign-in first, then Google sign-in
    final String? userEmail = emailSignInProvider.user?.email ?? googleSignInProvider.user?.email;
    
    // Safety check: Return empty list if no user is signed in
    if (userEmail == null) {
      debugPrint('Warning: Attempted to load conversations without signed-in user');
      return [];
    }
    
    // Try to load conversations, return empty list if there's an error
    try {
      return await conversationRepository.loadConversations(userEmail);
    } catch (e) {
      debugPrint('Error loading conversations: $e');
      return [];
    } // end of 'try-catch'
  }// end of '_loadConversations' method

  @override
  Widget build(BuildContext context) {
    // Wrap with Consumers to rebuild when auth state changes
    return Consumer<GoogleSignInProvider>(
      builder: (context, googleSignInProvider, _) {
        return Consumer<EmailSignInProvider>(
          builder: (context, emailSignInProvider, _) {
            final backgroundColorProvider = Provider.of<BackgroundColorProvider>(context, listen: true);

            // access 'EmailSignInProvider' or 'GoogleSignInProvider' to get user's email
            final String? emailFromProvider = emailSignInProvider.user?.email;
            final String? emailFromGoogle = googleSignInProvider.userEmail;
            final String currentUserEmail = emailFromProvider ?? emailFromGoogle ?? widget.userEmail;

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
                    final aiRepository = AIRepository();  // create 'aiRepository' instance
                    final responseGenerationService = ResponseGenerationService(aiRepository);  // Create 'ResponseGenerationService' instance

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
                      backgroundColor: backgroundColorProvider.backgroundColor,
                      title: const Row(
                        mainAxisSize: MainAxisSize.min,  // prevent Row from expanding to fill the space
                        children: [
                          Text(
                            'StreetVybezGPT',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(135, 3, 3, 3),
                            ),
                          ),
                        
                          SizedBox(width: 8.0),  // space between text and image
                        
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/logo4.jpg'),
                            radius: 20,
                          ),
                        ],
                      ),  // AppBar with screen title
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
                            child: FutureBuilder<List<Conversation>>(
                              future: _conversationsFuture,  // pass the future to 'FutureBuilder'
                              
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const ShimmerLoadingIndicator();  // use shimmer loading indicator
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));  // show error if occurred
                                } else if (snapshot.hasData) {
                                  return SavedConversationsTab(
                                    userEmail: currentUserEmail,
                                    conversations: snapshot.data!,  // provide the loaded conversations
                                  );
                                } else {
                                  return const Center(child: Text('No conversations found'));  // show message if no data
                                }
                              },
                            ),
                          )
                        : null,  // conditionally show the drawer on smaller screens

                    body: Row(  // use Row to layout the content side by side on large screens

                      children: [

                        if (isLargeScreen && isDrawerOpen)
                          SizedBox(
                            width: 250,  // set the width for the drawer content on large screens
                            child: FutureBuilder<List<Conversation>>(
                              future: _conversationsFuture,  // pass the future to 'FutureBuilder'
                              
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const ShimmerLoadingIndicator();  // use shimmer loading indicator
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));  // show error if occurred
                                } else if (snapshot.hasData) {
                                  return SavedConversationsTab(
                                    userEmail: currentUserEmail,
                                    conversations: snapshot.data!,  // provide the loaded conversations
                                  );
                                } else {
                                  return const Center(child: Text('No conversations found'));  // show message if no data
                                }
                              },
                            ),
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
          },
        );
      },
    );
  }  // end 'build' method
}  // end of '_ChatScreenState' class