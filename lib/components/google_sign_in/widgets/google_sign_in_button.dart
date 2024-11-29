import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/login_system/constants/assets.dart';

/// A stateful widget that represents a button for Google Sign-In.
/// This button depends on [GoogleSignInProvider] to work.
class GoogleSignInButton extends StatefulWidget {

  /// The landing page widget to navigate to after a successful sign-in.
  final Widget landingPage;

  const GoogleSignInButton({super.key, required this.landingPage});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;

  /// Handles the sign-in process when the button is clicked.
  Future<void> _signInWithGoogle(BuildContext context) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
      User? user = await googleSignInProvider.signInWithGoogle(context);

      if (user != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.landingPage,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // build the Google Sign-In button with styling similar to the LoginPage button
    return MaterialButton(
      onPressed: _isLoading ? null : () => _signInWithGoogle(context),

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

          if (_isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            )
          else
            Image.asset(
              Assets.googleLogo, // google logo asset
              height: 24, // google logo height
            ),

          const SizedBox(width: 10.0), // space between the logo & text

          Text(
            _isLoading ? 'Signing in...' : 'Sign in with Google',

            style: const TextStyle(
              fontSize: 16.0, // Font size for the text
              color: Colors.black54, // Text color
            ),
          ),

        ],

      ),
    );
  }

} // end 'GoogleSignInButton' widget class