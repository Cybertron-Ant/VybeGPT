// provides an interface for authenticating users & managing their sessions
import 'package:firebase_auth/firebase_auth.dart';


// define a class named 'LogOutService' to encapsulate the sign-out functionality
class LogOutService {

  // initialize an instance of 'FirebaseAuth'
  // this instance will be used to interact with Firebase Authentication services
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // define an asynchronous method named 'signOut' which will handle the sign-out process
  Future<void> signOut() async {

    // call the signOut method on the 'FirebaseAuth' instance to sign out the currently signed-in user
    // will end the user's session & require them to sign in again to access authenticated resources
    await _firebaseAuth.signOut();

  } // end 'signOut' future async method

} // end 'LogOutService' class