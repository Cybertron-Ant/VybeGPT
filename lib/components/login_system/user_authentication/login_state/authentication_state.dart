import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';
import 'package:towers/components/login_system/landing_screens/landing_page.dart';


// responsible for dynamically switching between different pages(LoginPage & landing page)
// based on user's authentication state using Firebase Authentication's stream
/// this widget is responsible for dynamically switching between different pages
/// (LoginPage & CategoryScreen) based on the user's authentication state
/// it uses Firebase Authentication's stream to monitor changes in the authentication state
class AuthenticationState extends StatelessWidget {
  const AuthenticationState({super.key});


  @override
  Widget build(BuildContext context) {

    // check the user's login state here
    // 'StreamBuilder' widget to listen to changes in the authentication state
    return StreamBuilder(

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

        } else if (snapshot.hasData) {
          // else if the 'snapshot' has data, it means the user is logged in

          // user is logged in, go to landing/home page
          return const LandingPage();

        } else {
          // else if the 'snapshot' does not have data, it means the user is not logged in

          // user is not logged in, navigate to 'LoginPage'
          return const LoginPage();

        } // end ELSE
      }, // end 'builder'

    );

  } // end 'build' overridden method
} // end 'AuthenticationState'