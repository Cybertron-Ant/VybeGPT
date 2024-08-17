import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/login_system/constants/assets.dart';


/// A stateless widget that represents a button for Google Sign-In.
/// This button depends on [GoogleSignInProvider] to work.
class GoogleSignInButton extends StatelessWidget {

  /// An instance of [GoogleSignInProvider] to handle Google Sign-In authentication.
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

  /// The landing page widget to navigate to after a successful sign-in.
  final Widget landingPage;

  /// Creates a [GoogleSignInButton] widget.
  GoogleSignInButton({super.key, required this.landingPage});

  /// Handles the sign-in process when the button is clicked.
  /// Uses the [GoogleSignInProvider] to sign in the user with Google. If the sign-in
  /// is successful and the context is still valid, it navigates to the [landingPage].
  void _signInWithGoogle(BuildContext context) async {

    // attempt to sign in the user with Google.
    User? user = await _googleSignInProvider.signInWithGoogle(context);

    // if the sign-in is successful & the context is valid, navigate to [landingPage].
    if (user != null && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => landingPage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    // build the Google Sign-In button with styling similar to the LoginPage button
    return MaterialButton(
      onPressed: () => _signInWithGoogle(context),

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
            Assets.googleLogo, // google logo asset
            height: 24, // google logo height
          ),

          const SizedBox(width: 10.0), // space between the logo & text

          const Text(
            'Sign in with Google',

            style: TextStyle(
              fontSize: 16.0, // Font size for the text
              color: Colors.black54, // Text color
            ),
          ),

        ],

      ),
    );
  }

} // end 'GoogleSignInButton' widget class