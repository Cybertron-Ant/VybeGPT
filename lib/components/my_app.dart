import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/google_sign_in/providers/google_user_provider.dart';
import 'package:towers/components/login_system/constants/strings.dart';
import 'package:towers/components/login_system/user_authentication/log_out/providers/log_out_provider.dart';
import 'login_system/user_authentication/login_state/authentication_state.dart';


// 'MyApp' widget, a 'StatelessWidget' representing the root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // Override 'build' method to describe part of user interface represented by this widget
  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        // provide 'LogOutProvider' globally available to the entire app
        ChangeNotifierProvider(create: (_) => LogOutProvider()),

        // provide 'GoogleUserProvider' globally available to the entire app
        ChangeNotifierProvider(create: (_) => GoogleUserProvider()),

      ], // end 'providers' array

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: Strings.brandName,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: const AuthenticationState(),

      ),
    );

  } // end 'build' overridden method

} // end 'MyApp' widget class