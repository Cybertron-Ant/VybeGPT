// import the flutter material package
// this provides the necessary widgets and tools to build the ui
import 'package:flutter/material.dart';  // for ui components

// import the provider package
// this allows us to use the provider pattern for state management
import 'package:provider/provider.dart';  // for state management

// import the gemini_repository from the chat data folder
// this repository handles interactions with the gemini generative ai model
import 'package:towers/components/ai_tool/features/chat/data/gemini_repository.dart';  // for gemini repository

// import the gemini_service from the chat domain folder
// this service layer handles business logic and interacts with the repository
import 'package:towers/components/ai_tool/features/chat/domain/gemini_service.dart';  // for gemini service

// import the chat_controller from the chat presentation folder
// this controller manages the chat ui logic and handles user interactions
import 'package:towers/components/ai_tool/features/chat/presentation/chat_controller.dart';  // for chat controller


// define a stateless widget named 'ChatScreen'
// this widget represents the main screen for chatting with the ai
class ChatScreen extends StatelessWidget {  // main chat screen widget

  // constructor with a key parameter, using super to pass the key to the parent class
  const ChatScreen({super.key});  // constructor to initialize the chat screen

  // override the build method to define the ui layout of the chat screen
  @override
  Widget build(BuildContext context) {  // build method to define the widget tree

    // return a changenotifierprovider to provide the chatcontroller to the widget tree
    return ChangeNotifierProvider(  // provide chatcontroller to the widget tree

      // create a new instance of chatcontroller using geminiservice and geminirepository
      create: (_) => ChatController(GeminiService(GeminiRepository())),  // create chatcontroller

      // define a scaffold widget to provide the basic visual layout structure
      child: Scaffold(  // scaffold provides the ui structure

        // define the app bar with a title for the chat screen
        appBar: AppBar(title: const Text('Chat with AI')),  // app bar with screen title

        // define the body of the scaffold using a consumer to listen to chatcontroller changes
        body: Consumer<ChatController>(  // consumer listens for changes in chatcontroller

          // builder method to rebuild ui whenever chatcontroller notifies listeners
          builder: (context, chatController, _) {  // builder method for ui updates

            // return a padding widget to add spacing around the content
            return Padding(  // add padding around the content

              // specify the amount of padding to apply
              padding: const EdgeInsets.all(16.0),  // padding around the column

              // define a column widget to arrange child widgets vertically
              child: Column(  // column to arrange widgets vertically

                // define the list of child widgets for the column
                children: [  // list of child widgets in the column

                  // add a text field for user input
                  // the controller is connected to the chatcontroller to manage input
                  TextField(  // text field for user to enter prompt

                    // connect the controller to manage the input text
                    controller: chatController.inputController,  // input controller

                    // add input decoration with a label for the text field
                    decoration: const InputDecoration(labelText: 'Enter a prompt'),  // input decoration

                  ),  // end of textfield widget

                  // add a sizedbox to create space between widgets
                  const SizedBox(height: 16),  // space between input field and button

                  // add an elevatedbutton to trigger response generation
                  ElevatedButton(  // button to generate response

                    // set the onpressed callback to generate the ai response
                    onPressed: () => chatController.generateResponse(),  // on press event

                    // set the button text
                    child: const Text('Generate Response'),  // button label

                  ),  // end of elevatedbutton widget

                  // add another sizedbox to create space between widgets
                  const SizedBox(height: 16),  // space between button and response

                  // add an expanded widget to allow the response text to scroll
                  Expanded(  // expanded to make the response scrollable

                    // wrap the response text in a singlechildscrollview
                    child: SingleChildScrollView(  // scroll view for response text

                      // display the response text using a text widget
                      child: Text(chatController.responseText),  // display response text

                    ),  // end of singlechildscrollview widget

                  ),  // end of expanded widget

                ],  // end of column children list

              ),  // end of column widget

            );  // end of padding widget

          },  // end of builder method

        ),  // end of consumer widget

      ),  // end of scaffold widget

    );  // end of changenotifierprovider

  }  // end of build method

}  // end of chatscreen class