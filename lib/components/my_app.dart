import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // for Flutter material design widgets
import 'package:provider/provider.dart';  // for provider package
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';  // for conversation repository
import 'package:towers/components/ai_tool/features/chat/domain/conversation_service.dart';  // for conversation service
import 'package:towers/components/ai_tool/features/chat/domain/response_generation_service.dart';  // for response generation service
import 'package:towers/components/ai_tool/features/chat/presentation/chat_controller.dart';  // for chat controller
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';  // for email sign-in provider
import 'package:towers/components/email_sign_in/providers/email_user_provider.dart';  // for email user provider
import 'package:towers/components/facebook_sign_in/providers/facebook_sign_in_provider.dart';  // for Facebook sign-in provider
import 'package:towers/components/facebook_sign_in/providers/facebook_user_provider.dart';  // for Facebook user provider
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';  // for Google sign-in provider
import 'package:towers/components/google_sign_in/providers/google_user_provider.dart';  // for Google user provider
import 'package:towers/components/login_system/constants/strings.dart';  // for application strings
import 'package:towers/components/login_system/user_authentication/log_out/providers/log_out_provider.dart';  // for log out provider
import 'login_system/user_authentication/login_state/authentication_state.dart';  // for authentication state


// 'MyApp' widget, a 'StatelessWidget' representing the root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // Override 'build' method to describe part of user interface represented by this widget
  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        // provide 'LogOutProvider' globally available to the entire app
        ChangeNotifierProvider(create: (_) => LogOutProvider()),

        // register 'GoogleSignInProvider' globally to the application
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),

        // provide 'GoogleUserProvider' globally available to the entire app
        ChangeNotifierProvider(create: (_) => GoogleUserProvider()),

        // register 'FacebookSignInProvider' globally to the application
        ChangeNotifierProvider(create: (_) => FacebookSignInProvider()),

        // provide 'FacebookUserProvider' globally available to the entire app
        ChangeNotifierProvider(create: (_) => FacebookUserProvider()),

        // register 'EmailSignInProvider' globally to the application
        ChangeNotifierProvider(create: (_) => EmailSignInProvider()),

        // provide 'EmailUserProvider' globally available to the entire app
        ChangeNotifierProvider(create: (_) => EmailUserProvider()),

        // add providers for conversation management
        ChangeNotifierProvider(create: (_) => ConversationRepository()),

        // Use a ChangeNotifierProvider for ConversationService with ConversationRepository as a dependency
        ChangeNotifierProxyProvider<ConversationRepository, ConversationService>(
          create: (context) => ConversationService(
            context.read<ConversationRepository>(),
          ),
          update: (context, repository, service) => ConversationService(repository),
        ),

        // use 'ChangeNotifierProxyProvider' for ChatController
        ChangeNotifierProxyProvider2<ConversationService, ResponseGenerationService, ChatController>(
          create: (context) {
            final conversationService = context.read<ConversationService>();
            final responseGenerationService = context.read<ResponseGenerationService>();

            if (conversationService == null || responseGenerationService == null) {
              throw StateError('Dependencies for ChatController are not provided.');
            }

            return ChatController(
              responseGenerationService,
              conversationService,
            );
          },
          update: (context, conversationService, responseGenerationService, chatController) {
            if (chatController == null) {
              if (kDebugMode) {
                print('Initializing ChatController');
              }
              return ChatController(
                responseGenerationService,
                conversationService,
              );
            }

            // if the 'ChatController' already exists, create a new instance with updated dependencies
            return ChatController(
              responseGenerationService,
              conversationService,
            );
          },
        ),

      ], // end 'providers' array

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: Strings.brandName,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: const AuthenticationState(),

      ),
    );

  } // end 'build' overridden method

} // end 'MyApp' widget class