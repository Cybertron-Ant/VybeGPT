class GoogleUserModel {

  // this field stores the user's email address
  final String email;

  // this field stores the user's profile photo URL, which is optional
  final String? profilePhoto;

  // constructor for creating a 'UserModel' instance
  GoogleUserModel({

    required this.email, // required parameter for user's email
    this.profilePhoto,  // optional parameter for user's profile photo

  });

} // end of 'UserModel' class