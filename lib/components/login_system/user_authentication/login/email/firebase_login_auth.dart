import 'package:firebase_auth/firebase_auth.dart';

import '../../../controllers/login_controller.dart';


// encapsulates logic for signing in a user with email & password using Firebase Authentication
// relies on a 'LoginController' instance to fetch the user's email & password input fields
class SignInWithEmailAndPassword {

  // initialize an instance of firebase-auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // takes an instance of 'LoginController' (controller) as a parameter
  Future<UserCredential?> signInWithEmailAndPassword(LoginController controller) async {

    try {

      // if the sign-in is successful (await _auth.signInWithEmailAndPassword), complete without error
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(

        // email & password are fetched from 'controller.emailController.text.trim()'
        // and 'controller.passwordController.text.trim()' respectively
        email: controller.emailController.text.trim(),
        password: controller.passwordController.text.trim(),

      ); // end 'signInWithEmailAndPassword'

      // object containing user information
      return userCredential;

    } catch (e) {

      // handle exceptions or errors here
      print('Login error: $e');
      return null;

    } // end 'CATCH'

  } // end 'signInWithEmailAndPassword' asynchronous method

} // end 'SignInWithEmailAndPassword'