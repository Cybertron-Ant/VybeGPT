import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Logged In'),

        actions: <Widget>[

          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              // sign out from Firebase
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {

                // navigate back to 'LoginPage'
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                ); // end Navigator 'pushReplacement'
              }

            }, // end asynchronous 'onPressed()'
          ),

        ],

      ),

      body: const Center(
        child: Text('You are logged in!'),
      ),

    );

  } // end 'build'
} // end 'LandingPage' widget class