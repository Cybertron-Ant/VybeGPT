import 'package:cloud_firestore/cloud_firestore.dart';  // for DocumentSnapshot


class Conversation {  // class representing a conversation

  final String id;  // unique identifier of the conversation
  final String title;  // title of the conversation
  late final List<String> messages;  // list of messages in the conversation
  final DateTime createdAt;  // timestamp when the conversation was created
  final DateTime lastModified;  // timestamp when the conversation was last modified

  // constructor for creating a 'Conversation' instance
  Conversation({
    required this.id,  // initialize id
    required this.title,  // initialize title
    required this.messages,  // initialize messages
    required this.createdAt,  // initialize createdAt
    required this.lastModified,  // initialize lastModified
  });

  // convert 'Conversation' object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,  // title of the conversation
      'messages': messages,  // list of messages in the conversation
      'createdAt': createdAt.toIso8601String(),  // creation timestamp in ISO 8601 format
      'lastModified': lastModified.toIso8601String(),  // last modified timestamp in ISO 8601 format
    };
  }  // end of 'toMap' method

  // create a 'Conversation' object from a map fetched from Firestore
  factory Conversation.fromMap(String id, Map<String, dynamic> map) {

    return Conversation(
      id: id,  // unique identifier of the conversation
      title: map['title'],  // title of the conversation
      messages: List<String>.from(map['messages']),  // list of messages in the conversation
      createdAt: DateTime.parse(map['createdAt']),  // creation timestamp parsed from string
      lastModified: DateTime.parse(map['lastModified']),  // last modified timestamp parsed from string
    );

  }  // end of 'fromMap' factory constructor

  // create a 'Conversation' object from a Firestore document snapshot
  factory Conversation.fromDocument(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;  // extract data from document snapshot
    return Conversation(
      id: doc.id,  // unique identifier of the document
      title: data['title'] ?? '',  // title of the conversation (default to empty string if null)
      messages: List<String>.from(data['messages'] ?? []),  // list of messages (default to empty list if null)
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),  // creation timestamp (default to current time if null)
      lastModified: data['lastModified'] != null ? DateTime.parse(data['lastModified']) : DateTime.now(),  // last modified timestamp (default to current time if null)
    );

  }  // end of 'fromDocument' factory constructor

  // getter for the last message in the conversation
  String get lastMessage {

    if (messages.isEmpty) {
      return '';  // return an empty string if no messages are present
    }

    return messages.last;  // return the last message in the list

  }  // end of 'lastMessage' getter method

}  // end of 'Conversation' class