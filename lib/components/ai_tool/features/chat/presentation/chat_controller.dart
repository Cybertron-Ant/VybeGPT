// import the flutter material package
// this provides the necessary widgets and tools to build the ui
import 'package:flutter/material.dart';  // for ui components and change notifier

// import the gemini_service from the chat domain folder
// this service handles the communication with the gemini ai model
import 'package:towers/components/ai_tool/features/chat/domain/gemini_service.dart'; // for gemini model service


// define a class named 'ChatController' which extends 'ChangeNotifier'
// this controller handles the logic for managing chat input and response
class ChatController extends ChangeNotifier {  // controller class for chat management

  // declare a final variable for the gemini service
  // this service will be used to get the generated response from the gemini model
  final GeminiService geminiService;  // service instance for gemini model

  // create a text editing controller to manage the input field
  // this controller handles the user's input text
  TextEditingController inputController = TextEditingController();  // controller for managing text input

  // declare a string variable to store the generated response text
  // this variable holds the response that will be displayed in the ui
  String responseText = '';  // variable to store the response text


  // constructor for the chatcontroller class
  // it initializes the controller with the provided gemini service instance
  ChatController(this.geminiService);  // constructor to initialize the chat controller with a service


  // define an asynchronous method to generate a response from the gemini model
  // this method checks if the input is not empty, then fetches and stores the response
  Future<void> generateResponse() async {  // method to handle response generation

    // check if the input field is not empty
    // only proceed if there is text entered by the user
    if (inputController.text.isNotEmpty) {  // condition to ensure input is not empty

      // get the generated response from the gemini service
      // this sends the input text to the gemini model and receives the response
      responseText = await geminiService.getGeneratedResponse(inputController.text);  // fetch the response from the service

      // clear the input field after generating the response
      // this resets the input field for the next message
      inputController.clear();  // clear the input field

      // notify listeners that the response text has been updated
      // this triggers a ui update to display the new response
      notifyListeners();  // notify listeners of state change

    }  // end of input check condition

  }  // end of generateResponse method

}  // end of chatcontroller class