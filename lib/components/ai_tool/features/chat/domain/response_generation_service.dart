import 'package:towers/components/ai_tool/features/chat/data/ai_repository.dart';

class ResponseGenerationService {
  // service class for generating responses

  // declare a final variable for the AI repository
  // this repository instance will be used to interact with the AI model
  final AIRepository repository; // repository instance for AI model

  // constructor for the 'ResponseGenerationService' class
  // it initializes the service with the given repository instance
  ResponseGenerationService(
      this.repository); // constructor to initialize the service with a repository

  // define a method to get the response stream from the repository
  // this method returns a stream of responses from the model
  Stream<String> getResponseStream() {
    // method to fetch the response stream from AI model

    // call the 'getResponseStream' method from the repository
    // this gets a stream of responses from the repository
    return repository
        .getResponseStream(); // return the response stream from the repository
  } // end of 'getResponseStream' method

  // define a method to get the generated response from the repository
  // this method takes an input text and returns the model's generated response
  Future<String> generateResponse(String inputText) {
    // method to fetch the response from AI model

    // call the 'generateResponse' method from the repository
    // this sends the input text to the repository to get the model's response
    return repository.generateResponse(
        inputText); // return the response generated by the repository
  } // end of 'generateResponse' method
}  // end of 'ResponseGenerationService' class