// import the google generative ai package
// this package provides tools to interact with google's generative ai models
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';  // for generative AI interaction

// import the api constants from the core components
// this file contains constants related to api keys and other configurations
import 'package:towers/components/ai_tool/core/constants/api_constants.dart';

// this package provides functionality for asset loading & other services
// this package is used to decode JSON data into Dart objects
import 'package:flutter/services.dart';  // for loading assets
import 'dart:convert';  // for JSON decoding


// define a class named 'GeminiRepository'
// this class is responsible for interacting with the gemini generative model
class GeminiRepository {  // repository for handling gemini model interactions

  // declare a late final variable for the generative model
  // this will hold the instance of the generative model used for generating content
  GenerativeModel? _model;  // generative model instance, initialized to null

  // a Future that completes when the ai model is initialized
  late final Future<void> _initialization;  // Future to track model initialization

  // constructor for the geminirepository class
  // this initializes the generative model using the api key from the JSON configuration file
  GeminiRepository() {  // constructor to initialize the generative model
    _initialization = _initializeModel();  // start the initialization process
  }  // end of geminirepository constructor

  // method to initialize the generative model
  // this reads the configuration file & sets up the generative model
  Future<void> _initializeModel() async {  // method to initialize the generative model

    try {

      // load the configuration file from assets
      // this reads the JSON file containing API key and other configurations
      final configString = await rootBundle.loadString(configurationJSON);  // load configuration JSON
      final config = jsonDecode(configString);  // decode JSON string into a map

      // get the API key from the JSON configuration
      // this ensures that the correct API key is used for authentication
      final apiKey = config['API_KEY'];  // get API key from JSON or constants

      // initialize the generative model with the specified model version and API key
      // this sets up the model for generating content based on input text
      _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);  // Initialize the generative model

    } catch (e) {
      // handle any errors that occur during the initialization
      if (kDebugMode) {
        print('Error initializing model: $e');

      }  // log the error
    }
  } // end of '_initializeModel' method

  // define an asynchronous method to generate a response from the model
  // this method takes an input text and returns the generated response
  Future<String> generateResponse(String inputText) async {  // Method to generate model response

    // ensure the model is initialized
    await _initialization;  // wait for initialization to complete

    if (_model == null) {
      // return an error message if the model is not initialized
      return 'AI model is not initialized.';
    }

    try {
      // create content for the request using the input text
      // the content is wrapped in a list as required by the model
      final content = [Content.text(inputText)];  // Create content for the model request

      // generate content using the model and the provided input
      // this sends the request to the model and waits for the response
      final response = await _model!.generateContent(content);  // Generate content using the model

      // extract the response text from the model's output
      // if the response is null, return a default message indicating no response
      return response.text ?? 'No response generated.';  // Return the generated response or default message
    } catch (e) {
      // handle any errors that occur during the request
      if (kDebugMode) {
        print('Error generating response: $e');
      }  // log the error
      return 'Error generating response.';  // Return an error message
    }
  }  // end of generateResponse method

  // method to get the response stream from the model
  // this method should interact with the model to get a stream of responses
  Stream<String> getResponseStream() {

    // implement this method to interact with the AI model and return a stream of responses
    throw UnimplementedError();  // placeholder for actual implementation

  } // end 'getResponseStream' method

} // end of 'geminirepository' class