import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart'; // Import EmailSignInProvider
import 'package:towers/components/facebook_sign_in/providers/facebook_sign_in_provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart'; // Import GoogleSignInProvider
import 'package:towers/components/login_system/screens/LoginPage.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    // Add this widget as an observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove this widget as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // The app is in the background or closed
      _updateLastOnline(context);
    }
  }

  Future<void> _updateLastOnline(BuildContext context) async {
    // update 'lastOnline' for email user
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);
    await emailSignInProvider.updateLastOnline();

    // update last online for Facebook user
    final facebookSignInProvider = Provider.of<FacebookSignInProvider>(context, listen: false);
    await facebookSignInProvider.updateLastOnline();

    if (context.mounted) {
      // update last online for Google user
      final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false); // Get GoogleSignInProvider
      await googleSignInProvider.updateLastOnline(); // Update last online timestamp for Google user
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Logged In'),

        actions: <Widget>[

          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              // access 'EmailSignInProvider' & call its 'signOut' method
              await Provider.of<EmailSignInProvider>(context, listen: false).signOut(context);

              // access the 'FacebookSignInProvider' and call its 'signOut' method
              await Provider.of<FacebookSignInProvider>(context, listen: false).signOut(context);

              if (context.mounted) {
                // access the 'GoogleSignInProvider' and call its 'signOut' method
                await Provider.of<GoogleSignInProvider>(context, listen: false).signOut(context);
              }

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