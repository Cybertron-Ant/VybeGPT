class FacebookUserModel {

  final String? uid;
  final String email;
  final String? profilePhoto;
  final String? displayName;
  final DateTime? lastLogin; // Timestamp of the user's last login
  final bool isOnline;
  final DateTime? lastOnline; // Timestamp of the last time the user was online

  FacebookUserModel({

    this.uid,
    required this.email,
    this.profilePhoto,
    this.displayName,
    this.lastLogin,
    required this.isOnline, // required to explicitly track user's online status
    this.lastOnline,

  });

}