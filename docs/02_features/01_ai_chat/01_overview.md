# 3. AI Chat System Documentation

## Reading Order Context
- Previous: [2. System Architecture (01_architecture/01_overview.md)](../../01_architecture/01_overview.md)
- Next: [4. Authentication System (02_features/02_authentication/01_overview.md)](../02_authentication/01_overview.md)

## Overview
The AI Chat system is powered by Google's Generative AI, providing real-time AI-powered conversations with Firebase-based persistence and state management.

## Architecture Components

### 1. Data Layer
```dart
lib/components/ai_tool/features/chat/data/
├── ai_repository.dart       // Google Generative AI integration
└── conversation_repository.dart // Firebase-based chat persistence
```

#### AIRepository
```dart
class AIRepository {
  GenerativeModel? _model;
  late final Future<void> _initialization;

  AIRepository() {
    _initialization = _initializeModel();
  }

  Future<void> _initializeModel() async {
    const String? apiKey = String.fromEnvironment('API_KEY');
    const String? modelVersion = String.fromEnvironment('MODEL_VERSION');

    if (apiKey != null && modelVersion != null) {
      _model = GenerativeModel(
          model: modelVersion,
          apiKey: apiKey);
    }
  }
}
```

#### ConversationRepository
```dart
class ConversationRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<Conversation>> _conversationsStream;

  Stream<List<Conversation>> getConversationsStream(String userEmail) {
    _conversationsStream = _firestore
        .collection('users')
        .doc(userEmail)
        .collection('conversations')
        .orderBy('lastModified', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
            .map((doc) => Conversation.fromDocument(doc))
            .toList();
        });
    
    _conversationsStream.listen((_) {
      notifyListeners();
    });

    return _conversationsStream;
  }
}
```

### 2. Domain Layer
```dart
lib/components/ai_tool/features/chat/domain/
└── conversation.dart     // Conversation model
```

#### Conversation Model
The `Conversation` class represents a chat session with:
- Conversation ID
- User email
- Messages history
- Timestamps
- Metadata

### 3. Core Components
```dart
lib/components/ai_tool/core/
├── widgets/             // Reusable UI components
└── utils/              // Helper functions
```

## Key Features

### 1. AI Integration
- Google Generative AI integration
- Environment-based configuration
- Error handling and retries
- Model initialization management

### 2. Data Persistence
- Firebase Firestore integration
- Real-time updates via streams
- Ordered conversation history
- User-specific data isolation

### 3. State Management
- ChangeNotifier-based state
- Real-time UI updates
- Stream-based data flow
- Error state handling

## Error Handling

### 1. AI Service Errors
```dart
try {
  // Model initialization and API calls
} catch (e) {
  if (kDebugMode) {
    print('Error initializing model: $e');
  }
}
```

### 2. Firebase Errors
```dart
_conversationsStream
  .handleError((error) {
    if (kDebugMode) {
      print('Error fetching conversations: $error');
    }
  })
```

## Data Structure

### 1. Firestore Schema
```
users/
└── {userEmail}/
    └── conversations/
        └── {conversationId}/
            ├── lastModified
            ├── title
            └── messages/
                └── {messageId}/
                    ├── content
                    ├── timestamp
                    └── role
```

### 2. Message Flow
1. User input captured
2. AI response generated via Google Generative AI
3. Conversation persisted to Firestore
4. UI updated via stream listeners

## Security Considerations

### 1. API Security
- Environment-based API key management
- Model version control
- Request validation

### 2. Data Security
- User-scoped data access
- Firebase security rules
- Error logging in debug mode only

## Future Improvements
1. Enhanced error recovery
2. Offline support
3. Message caching
4. Performance optimization
5. Advanced AI features
