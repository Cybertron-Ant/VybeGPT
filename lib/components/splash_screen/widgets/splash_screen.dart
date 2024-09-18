import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:towers/components/login_system/user_authentication/login_state/authentication_state.dart';  // Replace with the correct import for AuthenticationLogicStateful


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    try {
      if (kDebugMode) {
        print('SplashScreen: Loading splash screen...');
      }

      return AnimatedSplashScreen(
        splash: Image.asset('assets/flying.webp'),  // Add your splash image here
        duration: 2000,  // Duration of the splash screen in milliseconds
        centered: true,  // Whether to center the splash content
        nextScreen: const AuthenticationState(),  // Transition to your AuthenticationState screen
        splashTransition: SplashTransition.decoratedBoxTransition,  // The transition effect
        splashIconSize: 200.0,  // Size of the splash icon
        backgroundColor: Colors.black,  // Background color of the splash screen
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('Error occurred in SplashScreen: $error');
        print(stackTrace);
      }

      // return a fallback UI in case of an error
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }
}// end 'SplashScreen' widget class