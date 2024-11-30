import 'package:cloud_firestore/cloud_firestore.dart';  // Import for Timestamp


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
      'createdAt': Timestamp.fromDate(createdAt),  // store as Firestore Timestamp
      'lastModified': Timestamp.fromDate(lastModified),  // store as Firestore Timestamp
    };
  }  // end of 'toMap' method

  // create a 'Conversation' object from a map fetched from Firestore
  factory Conversation.fromMap(String id, Map<String, dynamic> map) {
    // Helper function to handle different timestamp formats
    DateTime getDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();  // convert Firestore Timestamp to DateTime
      } else if (value is String) {
        return DateTime.parse(value);  // parse ISO 8601 string to DateTime
      }
      return DateTime.now();  // fallback to current time if format is invalid
    }

    return Conversation(
      id: id,  // unique identifier of the conversation
      title: map['title'] ?? '',  // title of the conversation (default to empty if null)
      messages: List<String>.from(map['messages'] ?? []),  // list of messages (default to empty if null)
      createdAt: getDateTime(map['createdAt']),  // handle both Timestamp and String formats
      lastModified: getDateTime(map['lastModified']),  // handle both Timestamp and String formats
    );

  }  // end of 'fromMap' factory constructor

  // create a 'Conversation' object from a Firestore document snapshot
  factory Conversation.fromDocument(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;  // extract data from document snapshot
    return Conversation.fromMap(doc.id, data);  // use fromMap to handle the conversion

  }  // end of 'fromDocument' factory constructor

  // getter for the last message in the conversation
  String get lastMessage {

    if (messages.isEmpty) {
      return '';  // return an empty string if no messages are present
    }

    return messages.last;  // return the last message in the list

  }  // end of 'lastMessage' getter method

  // method to create a copy of the conversation with a new title
  Conversation copyWith({
    String? title,  // new title to update (if provided)
  }) {
    return Conversation(
      id: this.id,  // retain existing id
      title: title ?? this.title,  // use new title if provided, otherwise retain current title
      messages: this.messages,  // retain existing messages
      createdAt: this.createdAt,  // retain existing creation timestamp
      lastModified: DateTime.now(),  // update last modified timestamp to current time
    );
  }  // end of 'copyWith' method

}  // end of 'Conversation' class