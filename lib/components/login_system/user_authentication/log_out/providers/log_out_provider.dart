import 'package:flutter/material.dart';

// this widget represents the login screen of the application
import 'package:towers/components/login_system/screens/LoginPage.dart';

// this service handles the actual sign-out logic by interacting with Firebase Authentication
import 'package:towers/components/login_system/user_authentication/log_out/services/log_out_service.dart';


// define a 'provider' class named 'LogOutProvider' which extends 'ChangeNotifier'
// this class will be used to manage the sign-out state and notify listeners of any changes
class LogOutProvider with ChangeNotifier {

  // initialize an instance of 'LogOutService'
  // this instance will be used to perform the sign-out operation, later
  final LogOutService _authService = LogOutService();

  // define an asynchronous method named 'signOut' which takes a 'BuildContext' as an argument
  // this method will handle the sign-out process & navigate the user to the login screen
  Future<void> signOut(BuildContext context) async {

    // call the 'signOut' method on the 'LogOutService' instance to sign out the currently signed-in user
    await _authService.signOut();

    // check if the 'context' is still mounted to ensure safe navigation
    if (context.mounted) {

      // print a message to the console indicating that the user has been logged out
      print('user logged out');

      // use the 'Navigator' to replace the current route with the login page
      // this will redirect the user to the login screen after signing out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );

    } // end IF context mounted

  } // end 'signOut' future async method

} // end 'LogOutProvider' class