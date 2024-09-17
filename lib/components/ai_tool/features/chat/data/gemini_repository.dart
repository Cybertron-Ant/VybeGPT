// Suggested code may be subject to a license. Learn more: ~LicenseLog:1539588814.
// import the google generative ai package
// this package provides tools to interact with google's generative ai models
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // for generative AI interaction
import 'package:cloud_firestore/cloud_firestore.dart'; // for Firestore database
// this package provides functionality for asset loading & other services
// this package is used to decode JSON data into Dart objects
import 'package:flutter/services.dart'; // for loading assets


// define a class named 'GeminiRepository'
// this class is responsible for interacting with the gemini generative model
class GeminiRepository {  // repository for handling gemini model interactions

  // declare a late final variable for the generative model
  // this will hold the instance of the generative model used for generating content
  GenerativeModel? _model;  // generative model instance, initialized to null

  // a Future that completes when the ai model is initialized
  late final Future<void> _initialization;  // Future to track model initialization

  // Firestore instance for fetching the API key and model version
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // constructor for the geminirepository class
  // this initializes the generative model using the api key from Firestore
  GeminiRepository() {  // constructor to initialize the generative model
    _initialization = _initializeModel();  // start the initialization process

    setAISettings("AIzaSyCt8-j9AnCObf5a6uCZAIwhUwWo5qjaJwI", "gemini-1.5-flash");
  } // end of geminirepository constructor

  // method to initialize the generative model
  // fetches the API key & model version from Firestore and sets up the generative model
  Future<void> _initializeModel() async {  // method to initialize the generative model

    try {
      // fetch the API key & model version from Firestore
      final documentSnapshot =
          await _firestore.collection('config').doc('aiSettings').get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();

        // debug statement to check the data fetched from Firestore
        if (kDebugMode) {
          print('Fetched Firestore document data: $data');
          print('Document exists: ${documentSnapshot.exists}');
        }

        // check if the expected fields are present
        if (data != null) {
          final String? apiKey = data['API_KEY'];
          final String? modelVersion = data['MODEL_VERSION'];

          // debug statements to verify API key and model version
          if (kDebugMode) {
            print('API Key: $apiKey');
            print('Model Version: $modelVersion');
          }

          if (apiKey != null && modelVersion != null) {
            // initialize the generative model with the fetched model version and API key
            _model = GenerativeModel(
                model: modelVersion,
                apiKey: apiKey); // Initialize the generative model
          } else {
            if (kDebugMode) {
              print('API_KEY or MODEL_VERSION field is missing or null.');
            }
          }// end ELSE
        } else {
          if (kDebugMode) {
            print('Document data is null.');
          }
        }// end ELSE
      } else {
        // handle missing Firestore document
        if (kDebugMode) {
          print('Firestore document for AI settings not found.');
        }
      }//end ELSE
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

  // method to set the API key and model version in Firestore
  // this method takes the API key and model version as parameters and saves them in Firestore
  Future<void> setAISettings(String apiKey, String modelVersion) async {
    // method to set the AI settings in Firestore

    try {
      // Update or set the API key and model version in Firestore
      await _firestore.collection('config').doc('aiSettings').set({
        'API_KEY': apiKey,
        'MODEL_VERSION': modelVersion,
      });

      if (kDebugMode) {
        print('AI settings updated successfully.');
      }
    } catch (e) {
      // handle any errors that occur during the Firestore update
      if (kDebugMode) {
        print('Error updating AI settings in Firestore: $e');
      } // log the error
    }
  } // end of 'setAISettings' method
} // end of 'GeminiRepository' class