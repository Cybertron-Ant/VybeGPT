import 'package:flutter/material.dart';
import 'package:towers/components/facebook_sign_in/models/facebook_user_model.dart';


class FacebookUserProvider with ChangeNotifier {

  /// a private user object to store the current facebook user
  FacebookUserModel? _user;

  /// getter for the current user
  FacebookUserModel? get user => _user;

  /// sets the user and notifies listeners to update the ui
  void setUser(FacebookUserModel user) {
    _user = user;
    notifyListeners(); // notify listeners to update the ui
  }

  /// clears the user and notifies listeners to update the ui
  void clearUser() {
    _user = null;
    notifyListeners(); // notify listeners to update the ui
  }

}