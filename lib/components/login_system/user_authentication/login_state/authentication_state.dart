import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';


// responsible for dynamically switching between different pages
/// (LoginPage & ChatScreen) based on the user's authentication state.
/// it uses Firebase Authentication's stream to monitor changes in the authentication state.
class AuthenticationState extends StatefulWidget {
  const AuthenticationState({super.key});

  @override
  State<AuthenticationState> createState() => _AuthenticationStateState();
}

class _AuthenticationStateState extends State<AuthenticationState> {
  @override
  Widget build(BuildContext context) {
    // access the 'GoogleSignInProvider' & 'EmailSignInProvider' instances
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context);

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
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          // if there is a user logged in, check if it's via Google or Email
          final user = snapshot.data;

          final isGoogleSignIn = googleSignInProvider.isSignedIn() && googleSignInProvider.userEmail != null;
          final isEmailSignIn = emailSignInProvider.isSignedIn() && emailSignInProvider.user?.email != null;

          // forcefully navigate to 'ChatScreen'
          if (isGoogleSignIn || isEmailSignIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    userEmail: isGoogleSignIn ? googleSignInProvider.userEmail! : emailSignInProvider.user!.email!,
                  ),
                ),
              );
            });
            return const SizedBox.shrink(); // return an empty widget while navigating
          } else {
            // if user is signed in but not via Google or Email (or not signed in correctly)
            return const LoginPage();
          }
        } else {
          // else if the 'snapshot' does not have data, it means the user is not logged in

          // user is not logged in, navigate to 'LoginPage'
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          });
          return const SizedBox.shrink();
        } // end ELSE
      }, // end 'builder'

    );

  } // end '_AuthenticationStateState' state object
} // end 'AuthenticationState' widget class