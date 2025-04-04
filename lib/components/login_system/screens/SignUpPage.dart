import 'package:flutter/material.dart';  // import flutter material design package
import 'package:towers/components/colors/app_colors.dart';
import 'package:towers/components/email_sign_in/constants/assets.dart';
import 'package:towers/components/email_sign_in/constants/strings.dart';
import 'package:towers/components/email_sign_in/sign_up/sign_up_logic.dart';


class SignUpPage extends StatefulWidget {  // define a stateful widget for the signup page
  const SignUpPage({super.key});  // constructor for the signup page

  @override
  _SignUpPageState createState() => _SignUpPageState();  // create the state for this widget
}  // end of SignUpPage widget

class _SignUpPageState extends State<SignUpPage> {  // define the state for the signup page
  final SignUpLogic _signupLogic = SignUpLogic();  // initialize signup logic to handle signup actions

  @override
  Widget build(BuildContext context) {  // build method to describe the widget tree
    return Scaffold(  // return a scaffold to provide a structure for the screen layout

      body: Container(  // container for the page content
        decoration: const BoxDecoration(  // set the background decoration
          gradient: LinearGradient(  // use a linear gradient for the background
            begin: Alignment.topCenter,  // gradient starts at the top center
            end: Alignment.bottomCenter,  // gradient ends at the bottom center
            colors: [AppColors.blue, AppColors.lightBlueAccent],  // colors for the gradient
          ),  // end LinearGradient
        ),  // end BoxDecoration

        child: Center(  // center the content within the container
          child: SingleChildScrollView(  // make the content scrollable if it exceeds the screen height

            child: Column(  // use a column to arrange the children vertically
              mainAxisAlignment: MainAxisAlignment.center,  // center the content vertically

              children: <Widget>[

                const Row(  // create a row for the welcome text and profile image
                  mainAxisAlignment: MainAxisAlignment.center,  // center the row content

                  children: <Widget>[

                    Text(  // welcome text
                      Strings.brandName, // login screen title from constants
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white),  // set the text style to a larger font size with bold and white color
                    ),  // end Text

                    SizedBox(width: 10),  // add horizontal spacing between the text and the image

                    CircleAvatar(  // circle avatar widget for the profile image
                      backgroundColor: AppColors.white,  // set the background color to white
                      radius: 30,  // set the radius of the circle avatar
                      backgroundImage: AssetImage(Assets.profileImage),  // set the image from assets
                    ),  // end CircleAvatar

                  ],

                ),  // end Row

                const SizedBox(height: 20),  // add vertical spacing after the row

                LayoutBuilder(  // use LayoutBuilder to get the constraints for responsive design
                  builder: (context, constraints) {
                    double cardWidth = constraints.maxWidth * 0.90;  // set the card width to 90% of the available width

                    if (constraints.maxWidth > 600) {  // for larger screens
                      cardWidth = 400;  // fixed width for larger screens
                    }

                    return Padding(  // add padding around the card
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),  // symmetric padding horizontally

                      child: Card(  // card widget to contain the signup form fields
                        elevation: 8,  // set elevation to add shadow around the card
                        shape: RoundedRectangleBorder(  // rounded rectangle shape for the card
                          borderRadius: BorderRadius.circular(15),  // set the border radius for rounded corners
                        ),  // end RoundedRectangleBorder

                        child: SizedBox(  // use SizedBox to constrain the width of the card
                          width: cardWidth,  // set the width of the card
                          child: Padding(  // padding inside the card
                            padding: const EdgeInsets.all(16.0),  // padding on all sides of the card content

                            child: Column(  // column to arrange the form fields vertically
                              mainAxisSize: MainAxisSize.min,  // make the column take only the necessary space

                              children: <Widget>[

                                TextField(  // text field for email input
                                  controller: _signupLogic.emailController,  // connect the email controller

                                  decoration: InputDecoration(  // input decoration for the text field
                                    hintText: Strings.emailHint,  // hint text to guide the user
                                    prefixIcon: const Icon(Icons.email, color: AppColors.blue),  // icon before the input text
                                    filled: true,  // fill the background with color
                                    fillColor: AppColors.white,  // set background fill color to white
                                    border: OutlineInputBorder(  // outline border around the text field
                                      borderRadius: BorderRadius.circular(30),  // rounded corners for the text field
                                      borderSide: const BorderSide(color: AppColors.blue),  // set the border color to blue
                                    ),  // end OutlineInputBorder
                                  ),  // end InputDecoration
                                ),  // end TextField

                                const SizedBox(height: 10),  // vertical spacing between text fields

                                TextField(  // text field for password input
                                  controller: _signupLogic.passwordController,  // connect the password controller

                                  obscureText: true,  // obscure the text for password input
                                  decoration: InputDecoration(  // input decoration for the text field
                                    hintText: Strings.passwordHint,  // hint text to guide the user
                                    prefixIcon: const Icon(Icons.lock, color: AppColors.blue),  // icon before the input text
                                    filled: true,  // fill the background with color
                                    fillColor: AppColors.white,  // set background fill color to white
                                    border: OutlineInputBorder(  // outline border around the text field
                                      borderRadius: BorderRadius.circular(30),  // rounded corners for the text field
                                      borderSide: const BorderSide(color: AppColors.blue),  // set the border color to blue
                                    ),  // end OutlineInputBorder
                                  ),  // end InputDecoration

                                ),  // end TextField

                                const SizedBox(height: 10),  // vertical spacing between text fields

                                TextField(  // text field for confirm password input
                                  controller: _signupLogic.confirmPasswordController,  // connect the confirm password controller

                                  obscureText: true,  // obscure the text for password input
                                  decoration: InputDecoration(  // input decoration for the text field
                                    hintText: Strings.confirmPasswordHint,  // hint text to guide the user
                                    prefixIcon: const Icon(Icons.lock, color: AppColors.blue),  // icon before the input text
                                    filled: true,  // fill the background with color
                                    fillColor: AppColors.white,  // set background fill color to white
                                    border: OutlineInputBorder(  // outline border around the text field
                                      borderRadius: BorderRadius.circular(30),  // rounded corners for the text field
                                      borderSide: const BorderSide(color: AppColors.blue),  // set the border color to blue
                                    ),  // end OutlineInputBorder
                                  ),  // end InputDecoration

                                ),  // end TextField

                                const SizedBox(height: 20),  // vertical spacing before the sign-up button

                                SizedBox(  // sized box to constrain the width of the button
                                  width: cardWidth < 500  // check if card width is less than 500
                                      ? cardWidth * 0.7  // button width is 70% of card width for smaller screens
                                      : 350,  // fixed width for larger screens

                                  child: ElevatedButton(  // elevated button for the sign-up action
                                    onPressed: _signupLogic.isLoading ? null : () => _signupLogic.signUp(context, setState),  // disable button if loading, otherwise call sign-up logic

                                    style: ElevatedButton.styleFrom(  // style the button
                                      foregroundColor: AppColors.white,  // set the text color to white
                                      backgroundColor: AppColors.blue[700],  // set the button color to blue
                                      shape: RoundedRectangleBorder(  // rounded corners for the button
                                        borderRadius: BorderRadius.circular(30),  // rounded corners
                                      ),  // end RoundedRectangleBorder
                                    ),  // end ElevatedButton.styleFrom

                                    child: _signupLogic.isLoading  // check if loading
                                        ? const CircularProgressIndicator(  // show loading indicator if in loading state
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),  // set loading indicator color to white
                                    )  // end CircularProgressIndicator
                                        : const Text(Strings.signUp, style: TextStyle(fontSize: 16)),  // display 'Sign Up' text if not loading with larger font size

                                  ),  // end ElevatedButton
                                ),  // end SizedBox

                                if (_signupLogic.errorMessage != null)  // check if there is an error message
                                  Padding(  // add padding around the error message
                                    padding: const EdgeInsets.only(top: 16.0),  // add top padding

                                    child: Text(  // display the error message
                                      _signupLogic.errorMessage!,  // get the error message from the logic

                                      style: const TextStyle(
                                          color: Colors.red,
                                          ),  // set the text color to red
                                    ),  // end Text
                                  ),  // end Padding

                                const SizedBox(height: 5),  // vertical spacing before the login link

                                Row(  // row for the 'already have an account' link
                                  mainAxisAlignment: MainAxisAlignment.center,  // center the link

                                  children: <Widget>[

                                    const Text(  // text for the link
                                      Strings.haveAccount,  // have an account string from constants
                                      style: TextStyle(color: AppColors.black),  // set the text color to white
                                    ),  // end Text

                                    TextButton(  // button to navigate to the login page
                                      onPressed: () => Navigator.of(context).pop(),  // navigate back to the previous screen (login page)

                                      child: const Text(  // text for the button
                                        Strings.login,  // login string from constants

                                        style: TextStyle(
                                          color: AppColors.blue, // blue text color
                                          fontWeight: FontWeight.bold, // bold text
                                          decoration: TextDecoration.underline, // underline text
                                        ),  // set text font & color to white
                                      ),  // end Text
                                    ),  // end TextButton

                                  ],  // end children

                                ),  // end Row

                              ],  // end children

                            ),  // end Column
                          ),  // end Padding

                        ),  // end SizedBox

                      ),  // end Card

                    );  // end Padding
                  },  // end LayoutBuilder

                ),  // end LayoutBuilder

              ],  // end 'children' array of 'Column'

            ),  // end Column
          ),  // end SingleChildScrollView
        ),  // end Center
      ),  // end Container
    );  // end Scaffold
  }  // end 'build' method

}  // end _SignUpPageState class