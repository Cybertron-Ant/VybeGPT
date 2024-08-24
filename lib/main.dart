import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/email_sign_in/providers/email_user_provider.dart';
import 'package:towers/components/facebook_sign_in/providers/facebook_sign_in_provider.dart';
import 'package:towers/components/facebook_sign_in/providers/facebook_user_provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/google_sign_in/providers/google_user_provider.dart';
import 'package:towers/components/login_system/user_authentication/log_out/providers/log_out_provider.dart';
import 'components/login_system/database_initialization/firebase_init.dart';
import 'components/login_system/database_initialization/widgets/error_app.dart';
import 'components/my_app.dart';
import 'components/ai_tool/features/chat/domain/response_generation_service.dart';  // Ensure correct import path
import 'components/ai_tool/features/chat/domain/conversation_service.dart';  // Ensure correct import path
import 'components/ai_tool/features/chat/data/gemini_repository.dart';  // Ensure correct import path
import 'components/ai_tool/features/chat/data/conversation_repository.dart';  // Ensure correct import path
import 'components/ai_tool/features/chat/presentation/chat_controller.dart';  // Ensure correct import path

// 'MaterialApp' widget as the root
// the 'Firebase' initialization should be completed before running the app
void main() async {

  // ensure Flutter binding is initialized before any asynchronous code
  WidgetsFlutterBinding.ensureInitialized(); // ensure binding before Firebase initialization

  // try to initialize 'Firebase' with the default options for the current platform
  try {

    // wait for Firebase to be initialized before executing other code
    // initialize Firebase using the FirebaseInitializer class
    FirebaseApp firebaseApp = await FirebaseInitializer.initializeFirebase();

    // print initialization status
    if (kDebugMode) {
      print("Firebase initialized successfully yay! :-) : $firebaseApp");
    }

    // run the Flutter application with 'MaterialApp' as the root widget
    runApp(
      MultiProvider(
        providers: [

          // Provide 'LogOutProvider'
          ChangeNotifierProvider(create: (_) => LogOutProvider()),

          // Provide 'GoogleSignInProvider'
          ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),

          // Provide 'GoogleUserProvider'
          ChangeNotifierProvider(create: (_) => GoogleUserProvider()),

          // Provide 'FacebookSignInProvider'
          ChangeNotifierProvider(create: (_) => FacebookSignInProvider()),

          // Provide 'FacebookUserProvider'
          ChangeNotifierProvider(create: (_) => FacebookUserProvider()),

          // Provide 'EmailSignInProvider'
          ChangeNotifierProvider(create: (_) => EmailSignInProvider()),

          // Provide 'EmailUserProvider'
          ChangeNotifierProvider(create: (_) => EmailUserProvider()),

          // provide 'ResponseGenerationService' as a regular provider
          Provider<ResponseGenerationService>(
            create: (_) => ResponseGenerationService(GeminiRepository()),  // create ResponseGenerationService with GeminiRepository
          ),

          // provide 'ConversationService'
          ChangeNotifierProxyProvider<ConversationRepository, ConversationService>(
            create: (context) => ConversationService(
              context.read<ConversationRepository>(),  // pass the repository here
            ),
            update: (context, repository, service) => ConversationService(repository),  // update ConversationService if repository changes
          ),

          // provide 'ChatController'
          ChangeNotifierProxyProvider<GoogleSignInProvider, ChatController>(
            create: (context) {
              final responseGenerationService = Provider.of<ResponseGenerationService>(context, listen: false);  // get ResponseGenerationService
              final conversationService = Provider.of<ConversationService>(context, listen: false);  // get ConversationService
              final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false);  // get GoogleSignInProvider
              final userEmail = googleSignInProvider.userEmail ?? '';  // get email from GoogleSignInProvider

              return ChatController(
                responseGenerationService,
                conversationService,
                userEmail,
              );
            },
            update: (context, googleSignInProvider, chatController) {
              final responseGenerationService = Provider.of<ResponseGenerationService>(context, listen: false);  // get ResponseGenerationService
              final conversationService = Provider.of<ConversationService>(context, listen: false);  // get ConversationService
              final userEmail = googleSignInProvider.userEmail ?? '';  // get email from GoogleSignInProvider

              return ChatController(
                responseGenerationService,
                conversationService,
                userEmail,
              );
            },
          ),
        ],
        child: const MyApp(),
      ),
    );

  } catch (e) {

    // if Firebase initialization fails, print error and run the error app
    if (kDebugMode) {
      print("Error initializing Firebase: $e");
    }

    runApp(ErrorApp(errorMessage: e.toString()));

  } // end 'CATCH'

} // end 'main' asynchronous function