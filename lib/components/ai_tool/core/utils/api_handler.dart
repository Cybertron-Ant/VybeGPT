// import the google generative ai package
// this package provides the functionality to interact with google's generative ai models
import 'package:google_generative_ai/google_generative_ai.dart';  // this is needed for working with generative ai models

// import the dart:io package
// this package is necessary for accessing platform-specific information like environment variables
import 'dart:io';  // used to access platform environment variables

// import the api constants from the specified path
// these constants include api keys and other related settings
import 'package:towers/components/ai_tool/core/constants/api_constants.dart';


// define a class named 'ApiHandler'
// this class will handle interactions with the generative ai model
class ApiHandler {  // class to manage the api interactions

  // declare a late final variable for the generative model
  // this variable will be initialized later, specifically in the constructor
  late final GenerativeModel _model;  // generative model instance

  // constructor for the ApiHandler class
  // this will initialize the generative model with the appropriate api key
  ApiHandler() {  // constructor to initialize the generative model

    // get the api key from environment variables or use the constant value
    // if the api key is not found in the environment, fall back to the gemini api key constant
    final apiKey = Platform.environment['API_KEY'] ?? GEMINI_API_KEY;  // obtain the api key

    // initialize the generative model with the specified model name and api key
    // the model name is 'gemini-1.5-flash', and the api key is used for authentication
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);  // initialize the model

  }  // end of constructor

  // define a method to generate a response based on input text
  // this method is asynchronous and returns a future containing the generated response as a string
  Future<String> generateResponse(String inputText) async {  // method to generate ai response

    // create a list containing the input text
    // this content will be passed to the generative model for generating a response
    final content = [Content.text(inputText)];  // prepare content for the request

    // use the generative model to generate content based on the input
    // this call is asynchronous and waits for the response from the model
    final response = await _model.generateContent(content);  // generate content using the model

    // extract and return the generated text from the response
    // if the response text is null, return a default message
    return response.text ?? 'No response generated.';  // return the generated response or a default message

  }  // end of generateResponse method

}  // end of 'ApiHandler' class