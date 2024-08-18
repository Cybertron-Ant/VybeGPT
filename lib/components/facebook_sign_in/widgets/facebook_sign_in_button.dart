import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/facebook_sign_in/providers/facebook_sign_in_provider.dart';
import 'package:towers/components/login_system/constants/assets.dart';
import 'package:towers/components/login_system/landing_screens/landing_page.dart';


// defining a stateless widget for the facebook sign-in button
class FacebookSignInButton extends StatelessWidget {

  // constructor for the widget, with a super key to handle widget key
  FacebookSignInButton({super.key, required LandingPage landingPage}); // constructor

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      onPressed: () => _signInWithFacebook(context), // on tap, trigger sign-in function

      color: Colors.white, // Background color for the button.
      elevation: 5.0, // Elevation for a shadow effect.
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Padding inside the button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners for the button
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[

          Image.asset(
            Assets.facebookLogo, // facebook logo asset
            height: 24, // google logo height
          ),

          const SizedBox(width: 10.0), // space between the logo & text

          const Text(
            'Sign in with Facebook',

            style: TextStyle(
              fontSize: 16.0, // Font size for the text
              color: Colors.black54, // Text color
            ),
          ),

        ],

      ),
    );

  } // build method

  // private async function to handle the facebook sign-in process
  void _signInWithFacebook(BuildContext context) async {

    // obtaining the instance of the facebook sign-in provider
    final provider = Provider.of<FacebookSignInProvider>(context, listen: false); // provider instance

    // attempting to sign in with facebook
    await provider.signInWithFacebook(context); // sign-in attempt

    // if the user is successfully signed in and the context is still mounted, navigate to the landing page
    if (provider.user != null && context.mounted) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LandingPage(), // navigating to landing page
        ), // material page route
      ); // navigator push replacement
    }

  } // end '_signInWithFacebook' async method

} // FacebookSignInButton class