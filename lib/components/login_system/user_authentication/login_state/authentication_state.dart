import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';


// responsible for dynamically switching between different pages(LoginPage & ChatScreen)
// based on user's authentication state using Firebase Authentication's stream
/// this widget is responsible for dynamically switching between different pages
/// (LoginPage & ChatScreen) based on the user's authentication state
/// it uses Firebase Authentication's stream to monitor changes in the authentication state
class AuthenticationState extends StatelessWidget {
  const AuthenticationState({super.key});


  @override
  Widget build(BuildContext context) {

    // access the 'GoogleSignInProvider' instance
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    // check the user's login state here
    // 'StreamBuilder' widget to listen to changes in the authentication state
    return StreamBuilder<User?>(
      // 'stream' property listens to changes in authentication state
      // 'FirebaseAuth.instance.authStateChanges()' returns a stream of 'User?' objects
      stream: FirebaseAuth.instance.authStateChanges(),

      // 'builder' function is called whenever there is a change in the authentication state
      builder: (context, snapshot) {

        // check the current connection state of the 'StreamBuilder'
        if (snapshot.connectionState == ConnectionState.waiting) {

          // while the authentication state is being determined, show a loading progress circle indicator
          return const Center(
              child: CircularProgressIndicator()
          );

        } else if (googleSignInProvider.isSignedIn() && googleSignInProvider.userEmail != null) {

          // if user is signed in & email is non-null, navigate to 'ChatScreen'
          return ChatScreen(userEmail: googleSignInProvider.userEmail!);

        } else {
          // else if the 'snapshot' does not have data, it means the user is not logged in

          // user is not logged in, navigate to 'LoginPage'
          return const LoginPage();

        } // end ELSE
      }, // end 'builder'

    );

  } // end 'build' overridden method
} // end 'AuthenticationState'