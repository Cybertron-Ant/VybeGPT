class GoogleUserModel {

  // stores the user's unique ID, which is optional
  final String? uid;

  // stores the user's email address
  final String email;

  // stores the user's profile photo URL, which is optional
  final String? profilePhoto;

  // stores the user's display name, which is optional
  final String? displayName;

  // stores the timestamp of the user's last login, which is optional
  final DateTime? lastLogin;

  // indicates if the user is currently online
  final bool isOnline;

  // stores the timestamp of the last time the user was online, which is optional
  final DateTime? lastOnline;

  // constructor for creating a 'GoogleUserModel' instance
  GoogleUserModel({

    this.uid, // optional parameter for user's unique ID
    required this.email, // required parameter for user's email
    this.profilePhoto, // optional parameter for user's profile photo
    this.displayName, // optional parameter for user's display name
    this.lastLogin, // optional parameter for user's last login timestamp
    required this.isOnline, // required parameter to track user's online status
    this.lastOnline, // optional parameter for last online timestamp

  });

} // end of 'GoogleUserModel' class