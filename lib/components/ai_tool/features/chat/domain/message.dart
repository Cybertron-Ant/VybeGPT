import 'package:flutter/foundation.dart';

class Message {

  final String text;  // the content of the message
  final bool isUser;  // flag to indicate if the message is from the user

  Message({
    required this.text,
    required this.isUser,
  });

} // end 'Message' class