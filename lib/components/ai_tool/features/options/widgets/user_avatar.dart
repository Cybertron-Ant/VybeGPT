import 'package:flutter/material.dart';
import 'package:towers/components/ai_tool/features/options/constants/constants.dart';
import 'dart:math';
import 'package:towers/components/ai_tool/features/options/presentation/user_options_page.dart';


class UserAvatar extends StatefulWidget {
  final String email;

  // constructor for UserAvatar
  UserAvatar({super.key, required this.email});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {

    // extract the first letter of the email address
    final initial = widget.email.isNotEmpty ? widget.email[0].toUpperCase() : '';

    // generate a random color gradient
    final random = Random();
    final color1 = Colors.primaries[random.nextInt(Colors.primaries.length)];
    final color2 = Colors.primaries[random.nextInt(Colors.primaries.length)];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserOptionsPage(),
          ),
        );
      },
     
      child: Container(
        width: 50,
        height: 50,
        
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Center(

          child: Text(
            initial,
            style: const TextStyle(
              color: Constants.avatarIconColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

        ),
      ),
    );
  }// end '_UserAvatarState' state object
} // end 'UserAvatar' widget class