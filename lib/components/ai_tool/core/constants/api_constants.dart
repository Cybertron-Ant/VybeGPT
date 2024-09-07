import 'package:flutter/material.dart';

// declare a constant string for the gemini api key
// which will be used to authenticate requests to the gemini api
const String GEMINI_API_KEY = "AIzaSyCt8-j9AnCObf5a6uCZAIwhUwWo5qjaJwI";  // this is the api key for accessing the gemini api



// declare a constant string for the gemini model 
// which specifies the version of the gemini model to be used 
const String GEMINI_MODEL = "gemini-1.5-flash";  // this is the model version for the gemini api

const String configurationJSON = "assets/config.json";
const String messageGazaGpt = "Message GazaGPT";
const String brandImage = "assets/images/streetvybezgpt.jpg";

// Padding values
const PADDING_ALL_16 = 16.0;
const PADDING_VERTICAL_12 = 12.0;
const PADDING_BOTTOM_16 = 16.0;
const PADDING_ONLY_BOTTOM_16 = 16.0;

// Margin values
const MARGIN_BOTTOM_16 = 16.0;

// Colors
const Color AI_RESPONSE_COLOR = Colors.black;
const Color AI_TEXT_COLOR = Colors.white70;
const Color USER_TEXT_COLOR = Colors.black;

// color for user messages
const Color USER_MESSAGE_COLOR = Color(0xFFf1f1f1); // light-grey color for user messages


// Font style
const String COURIER_FONT_FAMILY = 'Courier';

// SnackBar messages
const String SNACKBAR_COPIED_TO_CLIPBOARD = 'Copied to clipboard';