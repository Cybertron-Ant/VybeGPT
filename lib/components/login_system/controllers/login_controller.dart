import 'package:flutter/material.dart';


// encapsulates logic & state related to managing the email & password text fields typically used in a login form
class LoginController {

  // initialize controllers used to manage input text fields in Flutter widgets
  // these controllers allow you to get & set the text in text fields, handle text editing events & manage focus
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // flag used to indicate whether the login process is currently loading or not
  bool isLoading = false;

  // dispose of resources such as controllers when they are no longer needed to avoid memory leaks
  void dispose() {

    // call 'dispose()' on 'emailController' & 'passwordController'
    // to free up their resources when the 'LoginController' instance is disposed
    emailController.dispose();
    passwordController.dispose();

  } // end 'dispose'

} // end 'LoginController' class