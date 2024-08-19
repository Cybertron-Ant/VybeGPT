class Strings {

  // general app strings
  static const String brandName = 'StreetVybez';
  static const String login = 'Login';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
  static const String confirmPasswordHint = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String haveAccount = "Already have an account?";
  static const String createAccount = 'Create Account';
  static const String orSignInWith = 'or sign in with';
  static const String signUp = 'Sign Up';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String passwordResetSuccess = 'Password reset link sent! Check your email.';

  // sign up related strings
  static const String signUpSuccess = 'Sign up successful! Please verify your email.';
  static const String emailAlreadyInUse = 'The email address is already in use by another account.';
  static const String weakPassword = 'The password is too weak. Please choose a stronger password.';
  static const String invalidEmail = 'The email address is not valid. Please enter a valid email address.';
  static const String signUpFailed = 'Sign up failed. Please try again.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String userNotFoundError = 'No user found with this email.';

  // error handling strings
  static const String emailInUse = 'email-in-use';
  static const String userSignedUp = 'User signed up: ';
  static const String weakPasswordDebug = 'The password provided is too weak.';
  static const String emailInUseDebug = 'The account already exists for that email.';
  static const String signUpFailedDebug = 'Sign up failed: ';
  static const String error = 'Error: ';
  static const String genericError = 'An error occurred. Please try again later.';

  // sign in related strings
  static const String signInError = 'An error occurred. Please try again later.';
  static const String signInErrorDebug = 'Error signing in with email: ';
  static const String noUserFoundDebug = 'No user found for email: ';
  static const String wrongPasswordDebug = 'Wrong password provided for email: ';

  // sign out related strings
  static const String signOutErrorDebug = 'Error signing out from firebase: ';

}