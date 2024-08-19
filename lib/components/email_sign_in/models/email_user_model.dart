class EmailUserModel {

  final String email;
  final String? profilePhoto;
  final bool isOnline;
  final DateTime lastOnline;

  EmailUserModel({
    required this.email,
    this.profilePhoto,
    required this.isOnline,
    required this.lastOnline,
  });

}
