// this class contains static methods for validating email & password inputs
// 'validateEmail' method checks if the email input is null or empty & returns an error message if so
// 'validatePassword' method checks if the password input is null or empty & returns an error message if so
// methods take a single parameter value of type String? (nullable string - can be null)
class FormValidator {

  // method to validate email input
  static String? validateEmail(String? value) {

    // check if value is null or empty
    if (value == null || value.isEmpty) {

      // return error message if email is empty
      return 'please enter your email';

    } // end IF

    // return null if validation passes
    return null;

  } // end 'validateEmail' static method


  // method to validate password input
  static String? validatePassword(String? value) {

    // check if value is null or empty
    if (value == null || value.isEmpty) {

      // return error message if password is empty
      return 'please enter your password';

    } // end IF

    // return null if validation passes
    return null;

  } // end 'validatePassword' static method

} // end 'Validators' class