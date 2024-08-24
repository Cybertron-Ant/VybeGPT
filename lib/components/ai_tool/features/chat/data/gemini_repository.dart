// import the google generative ai package
// this package provides tools to interact with google's generative ai models
import 'package:google_generative_ai/google_generative_ai.dart';  // for generative ai interaction

// import the api constants from the core components
// this file contains constants related to api keys and other configurations
import 'package:towers/components/ai_tool/core/constants/api_constants.dart';

// import the dart io package
// this package provides access to platform-specific functionality like environment variables
import 'dart:io';  // for accessing environment variables


// define a class named 'GeminiRepository'
// this class is responsible for interacting with the gemini generative model
class GeminiRepository {  // repository for handling gemini model interactions

  // declare a late final variable for the generative model
  // this will hold the instance of the generative model used for generating content
  late final GenerativeModel _model;  // generative model instance

  // constructor for the geminirepository class
  // this initializes the generative model using the api key from environment or constants
  GeminiRepository() {  // constructor to initialize the generative model

    // retrieve the api key from the environment or fall back to the constant
    // this ensures that the correct api key is used for authentication
    final apiKey = Platform.environment['API_KEY'] ?? GEMINI_API_KEY;  // get api key from environment or constants

    // initialize the generative model with the specified model version and api key
    // this sets up the model for generating content based on input text
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);  // initialize the generative model

  }  // end of geminirepository constructor


  // define an asynchronous method to generate a response from the model
  // this method takes an input text and returns the generated response
  Future<String> generateResponse(String inputText) async {  // method to generate model response

    // create content for the request using the input text
    // the content is wrapped in a list as required by the model
    final content = [Content.text(inputText)];  // create content for the model request

    // generate content using the model and the provided input
    // this sends the request to the model and waits for the response
    final response = await _model.generateContent(content);  // generate content using the model

    // extract the response text from the model's output
    // if the response is null, return a default message indicating no response
    return response.text ?? 'No response generated.';  // return the generated response or default message

  }  // end of generateResponse method

  // method to get the response stream from the model
  // this method should interact with the model to get a stream of responses
  Stream<String> getResponseStream() {

    // implement this method to interact with the AI model and return a stream of responses
    throw UnimplementedError();  // placeholder for actual implementation

  } // end 'getResponseStream' method

} // end of 'geminirepository' class