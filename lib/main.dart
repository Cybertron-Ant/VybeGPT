import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'components/login_system/database_initialization/firebase_init.dart';
import 'components/login_system/database_initialization/widgets/error_app.dart';
import 'components/my_app.dart';


// 'MaterialApp' widget as the root
// the 'Firebase' initialization should be completed before running the app
void main() async {

  // ensure Flutter binding is initialized before any asynchronous code
  WidgetsFlutterBinding.ensureInitialized(); // ensure binding before Firebase initialization

  // try to initialize 'Firebase' with the default options for the current platform
  try {

    // wait for Firebase to be initialized before executing other code
    // initialize Firebase using the FirebaseInitializer class
    FirebaseApp firebaseApp = await FirebaseInitializer.initializeFirebase();

    // print initialization status
    if (kDebugMode) {
      print("Firebase initialized successfully yay! :-) : $firebaseApp");
    }

    // run the Flutter application with 'MaterialApp' as the root widget
    runApp(const MyApp());

  } catch (e) {

    // if Firebase initialization fails, print error and run the error app
    if (kDebugMode) {
      print("Error initializing Firebase: $e");
    }

    runApp(ErrorApp(errorMessage: e.toString()));

  } // end 'CATCH'

} // end 'main' asynchronous function