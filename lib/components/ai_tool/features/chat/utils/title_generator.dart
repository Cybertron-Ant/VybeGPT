
// function to generate a title based on the conversation's messages
String generateTitleFromMessages(List<String> messages) {

  if (messages.isEmpty) {
    return 'New Conversation';  // default title if no messages
  }

  // use the last message as the base title
  String title = messages.last;

  // limit the title to 25 characters to avoid Firestore limits
  if (title.length > 25) {
    title = title.substring(0, 25); 
  }

  return title;

} // end 'generateTitleFromMessages' function