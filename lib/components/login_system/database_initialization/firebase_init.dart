import 'package:firebase_core/firebase_core.dart';
import 'package:towers/firebase_options.dart';


// class to handle Firebase initialization
class FirebaseInitializer {

  // asynchronous static method to initialize Firebase
  static Future<FirebaseApp> initializeFirebase() async {

    // initialize Firebase with the default options for the current platform
    return await Firebase.initializeApp(

      options: DefaultFirebaseOptions.currentPlatform,

    ); // end 'initializeApp' method

  } // end 'initializeFirebase' asynchronous static method

} // end 'FirebaseInitializer' class