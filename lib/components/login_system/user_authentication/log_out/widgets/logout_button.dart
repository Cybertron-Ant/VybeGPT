import 'package:flutter/material.dart';

// this package is used for state management
import 'package:provider/provider.dart';

// this provider handles the sign-out logic for the application
import 'package:towers/components/login_system/user_authentication/log_out/providers/log_out_provider.dart';


// define a stateless widget named 'LogoutButton'
// this widget represents a button that allows the user to log out
class LogoutButton extends StatelessWidget {

  // define a constructor for the 'LogoutButton' widget
  // the constructor uses the 'const' keyword to indicate that this widget is immutable
  const LogoutButton({super.key});

  // override the 'build' method to describe how to show the widget
  @override
  Widget build(BuildContext context) {

    // return an 'IconButton' widget
    // this button will show a logout icon & trigger the sign-out process when pressed
    return IconButton(

      // set the 'icon' property to an 'Icon' widget showing the logout icon
      icon: Icon(Icons.logout),

      // set the onPressed property to an anonymous function
      // this function will be executed when the button is pressed
      onPressed: () {

        // use the 'Provider' to access the 'LogOutProvider'
        // call 'signOut' method on the provider to handle the sign-out process
        // the 'listen: false' argument ensures this widget does not rebuild when provider's state changes
        Provider.of<LogOutProvider>(context, listen: false).signOut(context);

      }, // end 'onPressed' property

    );

  } // end 'build' overridden method

} // end 'LogoutButton' widget class