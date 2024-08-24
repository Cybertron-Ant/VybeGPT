import 'package:flutter/material.dart'; // import material design package
import 'package:provider/provider.dart'; // import provider package
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';
import 'package:towers/components/colors/app_colors.dart';
import 'package:towers/components/email_sign_in/password_reset/forgot_password_dialog.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/facebook_sign_in/widgets/facebook_sign_in_button.dart';
import 'package:towers/components/google_sign_in/widgets/google_sign_in_button.dart';
import 'package:towers/components/login_system/constants/strings.dart';
import 'package:towers/components/login_system/form_validation/form_validator.dart'; // import form validation logic
import 'package:towers/components/login_system/landing_screens/landing_page.dart';
import 'package:towers/components/login_system/screens/SignUpPage.dart'; // import sign up page



class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // constructor for LoginPage

  @override
  _LoginPageState createState() => _LoginPageState(); // create state for LoginPage
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // key for form validation

  @override
  void dispose() {
    super.dispose(); // call super dispose
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.blue, // set background color to blue

      body: Center(
        child: SingleChildScrollView(

          child: LayoutBuilder( // 'LayoutBuilder' to handle responsiveness
            builder: (context, constraints) {
              double cardWidth = constraints.maxWidth < 600
                  ? constraints.maxWidth * 0.9 // 90% width for small screens
                  : 500; // fixed width for larger screens

              return Form(
                key: _formKey, // assign form key

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // center column children

                  children: <Widget>[

                    const Text(
                      Strings.brandName, // login screen title from constants
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.white), // text style
                    ),

                    const SizedBox(height: 20), // add space

                    // Login Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: (constraints.maxWidth - cardWidth) / 2), // padding for card

                      child: Card(
                        elevation: 8, // card elevation
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // card border radius
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(16.0), // padding inside card

                          child: Column(
                            mainAxisSize: MainAxisSize.min, // card size

                            children: <Widget>[

                              TextFormField(
                                controller: Provider.of<EmailSignInProvider>(context, listen: false).emailController, // email controller

                                decoration: InputDecoration(
                                  hintText: Strings.emailHint, // hint text for email
                                  prefixIcon: const Icon(Icons.email), // icon for email
                                  filled: true, // fill the field
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), // border radius
                                  ),
                                ),

                                validator: FormValidator.validateEmail, // email validation

                              ),

                              const SizedBox(height: 10), // add space

                              TextFormField(
                                controller: Provider.of<EmailSignInProvider>(context, listen: false).passwordController, // password controller

                                obscureText: true, // obscure password text
                                decoration: InputDecoration(
                                  hintText: Strings.passwordHint, // hint text for password
                                  prefixIcon: const Icon(Icons.lock), // icon for password
                                  filled: true, // fill the field
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), // border radius
                                  ),
                                ),

                                validator: FormValidator.validatePassword, // password validation

                              ),

                              const SizedBox(height: 10), // add space

                              Align(
                                alignment: Alignment.centerRight, // align to the right

                                child: GestureDetector(
                                  onTap: () {
                                    ForgotPasswordDialog.showForgotPasswordDialog(
                                        context, Provider.of<EmailSignInProvider>(context, listen: false).emailController.text); // show forgot password dialog
                                  },

                                  child: const Text(
                                    Strings.forgotPassword, // text for forgot password
                                    style: TextStyle(
                                      color: AppColors.blue, // blue text color
                                      decoration: TextDecoration.underline, // underline text
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20), // add space

                              SizedBox(
                                width: double.infinity, // make button full width

                                child: ElevatedButton(
                                  onPressed: Provider.of<EmailSignInProvider>(context).isLoading
                                      ? null
                                      : () => _login(context), // handle button press

                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.white, // text color
                                    backgroundColor: AppColors.blue, // background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30), // button border radius
                                    ),
                                  ),

                                  child: Provider.of<EmailSignInProvider>(context).isLoading
                                      ? const CircularProgressIndicator(color: AppColors.white) // show progress indicator if loading
                                      : const Text(Strings.login), // button text
                                ),
                              ),

                              const SizedBox(height: 10), // add space

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpPage(), // navigate to sign up page
                                    ),
                                  );
                                },

                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // center row children

                                  children: <Widget>[
                                    Text(
                                      Strings.dontHaveAccount, // text for no account
                                      style: TextStyle(color: AppColors.black), // text color
                                    ),

                                    Text(
                                      Strings.createAccount, // text for create account
                                      style: TextStyle(
                                        color: AppColors.blue, // blue text color
                                        fontWeight: FontWeight.bold, // bold text
                                        decoration: TextDecoration.underline, // underline text
                                      ),
                                    ),

                                  ],

                                ),
                              ),

                            ],

                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20), // add space

                    // "Sign in with" text
                    const Text(
                      Strings.orSignInWith, // text for sign in options
                      style: TextStyle(color: AppColors.white, fontSize: 16), // text style
                    ),

                    const SizedBox(height: 10), // add space

                    // Google Sign-In Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // padding for button

                      child: GoogleSignInButton(
                        landingPage: const ChatScreen(userEmail: ''), // TODO - replace with actual landing page.
                      ),
                    ),

                    const SizedBox(height: 10), // add space

                    // Facebook Sign-In Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // padding for button

                      child: FacebookSignInButton(
                        landingPage: const LandingPage(), // TODO - replace with actual landing page.
                      ),
                    ),

                  ],

                ),
              );
            },
          ),
        ),
      ),
    );
  } // end 'build'


  Future<void> _login(BuildContext context) async {
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: false);

    await emailSignInProvider.signInWithEmail(
      context,
      emailSignInProvider.emailController.text,
      emailSignInProvider.passwordController.text,
    ); // perform login operation

  } // end '_login' method

} // end 'LoginPage' widget class