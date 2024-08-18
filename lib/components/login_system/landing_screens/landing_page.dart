import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/facebook_sign_in/providers/facebook_sign_in_provider.dart';
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
      _updateLastOnline();
    }
  }

  Future<void> _updateLastOnline() async {
    final facebookSignInProvider = Provider.of<FacebookSignInProvider>(context, listen: false);
    await facebookSignInProvider.updateLastOnline();
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
              // access the 'FacebookSignInProvider' and call its 'signOut' method
              await Provider.of<FacebookSignInProvider>(context, listen: false).signOut(context);

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