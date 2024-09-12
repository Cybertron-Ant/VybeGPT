import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/features/background_color/constants/constants_colors.dart';
import 'package:towers/components/ai_tool/features/background_color/providers/background_color_provider.dart';
import 'package:towers/components/ai_tool/features/options/constants/constants.dart';
import 'package:towers/components/email_sign_in/providers/email_sign_in_provider.dart';
import 'package:towers/components/google_sign_in/providers/google_sign_in_provider.dart';
import 'package:towers/components/login_system/screens/LoginPage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; 


class UserOptionsPage extends StatefulWidget {
  const UserOptionsPage({super.key});

  @override
  State<UserOptionsPage> createState() => _UserOptionsPageState();
}

class _UserOptionsPageState extends State<UserOptionsPage> {
  @override
  Widget build(BuildContext context) {

    // get instances of email & google sign-in providers
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context, listen: true);
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context, listen: true);
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(context, listen: true);

    // reference user's email, falling back to GoogleSignInProvider if needed
    final currentUserEmail = emailSignInProvider.user?.email ?? googleSignInProvider.userEmail ?? 'User';

    return Scaffold(

      appBar: AppBar(
        title: const Text(Constants.optionsPageTitle),
        backgroundColor: backgroundColorProvider.backgroundColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(

          children: <Widget>[

            const SizedBox(height: 20),

            // display a circular avatar with a person icon
            const CircleAvatar(
              backgroundColor: Constants.avatarBackgroundColor,
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // display a welcome message with the user's email
            Text(
              Constants.welcomeMessage + '$currentUserEmail!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // create a list view for user options
            Expanded(
              child: ListView(

                children: <Widget>[

                  // option to change background color
                  ListTile(
                    title: const Text(ConstantsColors.backgroundColorPageTitle),
                    leading: const Icon(Icons.color_lens),
                    trailing: const Icon(Icons.arrow_forward),
                    tileColor: ConstantsColors.colorPickerButtonColor,
                    onTap: () async {
                      final newColor = await showDialog<Color>(
                        context: context,
                        builder: (BuildContext context) {
                          
                          return AlertDialog(
                            title: const Text(ConstantsColors.colorPickerLabel), // dialog title
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: backgroundColorProvider.backgroundColor,
                                onColorChanged: (color) {
                                  Navigator.of(context).pop(color);
                                },
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                          );
                        },
                      );
                     
                      if (newColor != null && context.mounted) {
                        backgroundColorProvider.setBackgroundColor(newColor);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(ConstantsColors.colorUpdateSuccess)),  // success message
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // option to log out
                  ListTile(
                    title: const Text(Constants.logoutOptionTitle),
                    leading: const Icon(Icons.logout, color: Constants.logoutIconColor),
                    trailing: const Icon(Icons.arrow_forward, color:Constants.logoutIconColor),
                    tileColor: Colors.red.withOpacity(0.1),

                    onTap: () async {
                      try {
                        // sign out from email provider
                        await emailSignInProvider.signOut(context);
                        debugPrint(Constants.debugEmailSignOutSuccess);
                      } catch (e) {
                        debugPrint(Constants.debugEmailSignOutError);
                      }

                      // if context is still mounted, sign out from google provider
                      if (context.mounted) {
                        try {
                          await googleSignInProvider.signOut(context);
                          debugPrint(Constants.debugGoogleSignOutSuccess);
                        } catch (e) {
                          debugPrint(Constants.debugGoogleSignOutError);
                        }

                        // if context is still mounted, navigate to the login page
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                          debugPrint(Constants.debugNavigatingToLoginPage);
                        }
                      }
                    },
                  ),
               
                ],

              ),
            ),
        
          ],
       
        ),
      ),
    );
  } // end '_UserOptionsPageState' state object
} // end 'UserOptionsPage' widget class