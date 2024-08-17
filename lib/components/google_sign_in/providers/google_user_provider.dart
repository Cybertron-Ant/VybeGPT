import 'package:flutter/material.dart'; // import Flutter material package for UI components
import 'package:towers/components/google_sign_in/models/google_user_model.dart'; // import UserModel class


// 'GoogleUserProvider' class that manages user data and notifies listeners about changes
class GoogleUserProvider with ChangeNotifier {

  // private field to store the current user data
  GoogleUserModel? _user;

  // getter to retrieve the current user data
  GoogleUserModel? get user => _user; // returns the current user, or null if no user is set

  // method to set the user data and notify listeners of the change
  void setUser(GoogleUserModel user) {

    _user = user; // assign the new user data to the private field
    notifyListeners(); // notify all listeners that the user data has changed

  } // end of setUser method

  // method to clear the user data and notify listeners of the change
  void clearUser() {

    _user = null; // set the user data to null
    notifyListeners(); // notify all listeners that the user data has been cleared

  } // end of clearUser method

} // end of 'GoogleUserProvider' class