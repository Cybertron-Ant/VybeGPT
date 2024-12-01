import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/features/background_color/providers/background_color_provider.dart';
import 'package:towers/components/ai_tool/features/chat/controllers/chat_controller.dart';
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';
import 'package:towers/components/ai_tool/core/widgets/edit_conversation_dialog.dart'; // import the new dialog file

class SavedConversationsTab extends StatefulWidget {
  final String userEmail;  // Add userEmail as a parameter
  final List<Conversation> conversations; // accept conversations as a parameter

  const SavedConversationsTab({
    super.key,
    required this.userEmail,
    required this.conversations, // constructor with required userEmail and conversations
  });

  @override
  _SavedConversationsTabState createState() => _SavedConversationsTabState();
}

class _SavedConversationsTabState extends State<SavedConversationsTab> {

  late final ConversationRepository _conversationRepository;
  late final ScrollController _scrollController;
  List<Conversation> _conversations = [];  // list of conversations
  List<Conversation> _filteredConversations = []; // list of filtered conversations
  bool _isLoading = false;  // loading state
  bool _hasMore = true;  // flag to check if more data is available
  int _offset = 0;  // current offset for pagination
  final int _limit = 15;  // number of conversations to load per request
  bool _isMounted = false; // Flag to check if the widget is mounted
  final TextEditingController _searchController = TextEditingController(); // search input controller

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Set the flag to true when initializing
    _conversationRepository = Provider.of<ConversationRepository>(context, listen: false);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _loadMoreConversations();
        }
      });
    _searchController.addListener(_filterConversations); // add listener for search input

    // Initialize conversations with the provided list and sort them
    _conversations = List.from(widget.conversations)
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
    _filteredConversations = _conversations; // initialize filtered conversations
    _offset = _conversations.length; // Set initial offset to current list length
  }

  Future<void> _loadMoreConversations() async {
    if (_isLoading || !_hasMore) return;  // 'return' if already loading or no more data

    setState(() {
      _isLoading = true;
    });

    try {
      final newConversations = await _conversationRepository.loadConversations(
        widget.userEmail,
        offset: _offset,
        limit: _limit,
      );
      if (_isMounted) { // check if the widget is still mounted
        setState(() {
          // Use a Set to avoid duplicates when adding new conversations
          final existingIds = _conversations.map((c) => c.id).toSet();
          final uniqueNewConversations = newConversations.where((c) => !existingIds.contains(c.id));
          
          _conversations.addAll(uniqueNewConversations);
          _conversations.sort((a, b) => b.lastModified.compareTo(a.lastModified));
          _filterConversations(); // update filtered list with search query
          _offset += newConversations.length;
          _hasMore = newConversations.length == _limit;  // if fewer conversations returned, no more data
        });
      }
    } catch (e) {
      // handle error (if needed)
      if (kDebugMode) {
        print('Error loading more conversations: $e');
      }
    } finally {
      if (_isMounted) { // check if the widget is still mounted
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterConversations() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredConversations = _conversations.where((conversation) {
        return conversation.title.toLowerCase().contains(query);
      }).toList()
        ..sort((a, b) => b.lastModified.compareTo(a.lastModified)); // Sort filtered results
    });
  } // end '_filterConversations' method

  void _clearSearch() {
    _searchController.clear(); // clear the text field
    _filterConversations(); // reset the filtered list
  }

  Future<void> _refreshConversations() async {
    setState(() {
      _offset = 0; // reset the offset for loading from the beginning
      _isLoading = true; // set loading state
    });

    try {
      final conversations = await _conversationRepository.loadConversations(
        widget.userEmail,
        offset: 0,
        limit: _limit,
      );

      if (_isMounted) {
        setState(() {
          _conversations = conversations;
          _conversations.sort((a, b) => b.lastModified.compareTo(a.lastModified));
          _filterConversations();
          _offset = conversations.length;
          _hasMore = conversations.length == _limit;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing conversations: $e');
      }
      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _isMounted = false; // set the flag to 'false' when disposing the widget
    _scrollController.dispose();
    _searchController.dispose(); // dispose the search controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(context, listen: true);

    return Scaffold(
     
      appBar: AppBar(
        backgroundColor: backgroundColorProvider.backgroundColor,
        automaticallyImplyLeading: false,
        title: const Text(''),
       
        leading: IconButton(
          iconSize: 30.0,
          hoverColor: Colors.black,
          tooltip: "New Chat",
          icon: const Icon(Icons.edit_square),
          onPressed: () {
            final chatController = context.read<ChatController>();

            // create a new conversation & navigate to it
            chatController.createNewConversation(context);  // pass 'context' to 'createNewConversation'
          },
        ),
      ),
      
      body: SafeArea( // ensure content is within safe area on smartphones
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        
          children: [
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600, // adjust max width for larger screens
                ),
              
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Conversations',
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : const Icon(Icons.search),
                  ),
                ),
              ),
            ),
           
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredConversations.length + 1,  // number of items in the list + 1 for the loading indicator
                itemBuilder: (context, index) {
                   // show a loading indicator at the end of the list
                  if (index == _filteredConversations.length) {
                    return _isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();  // empty widget when not loading
                  } // end IF

                  final conversation = _filteredConversations[index];  // get conversation at index

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.5, 2.0, 2.5,),
                    
                    child: ListTile(
                       // display only the first 50 characters & add an ellipsis if needed
                      title: Text(
                        conversation.title.length > 50
                            ? '${conversation.title.substring(0, 50)}...'  // truncate & add ellipsis
                            : conversation.title,  // full title
                        overflow: TextOverflow.ellipsis,  // ensure ellipsis if text overflows
                        maxLines: 1,  // limit text to one line
                      ),
                      // subtitle: Text(conversation.lastModified.toString()), // display last modified timestamp
                      subtitle: const Text(""),
                      
                      onTap: () {
                        
                        // navigate to 'ChatScreen' & pass the conversation data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // pass 'conversation' & 'userEmail' to 'ChatScreen'
                            builder: (context) => ChatScreen(
                              conversation: conversation,
                              userEmail: widget.userEmail,
                            ),
                          ),
                        ).then((_) => _refreshConversations()); // Refresh the list after returning from ChatScreen
                      }, // end 'onTap'

                      onLongPress: () {
                        // show a dialog to edit the title using the extracted logic
                        showEditConversationDialog(
                          context: context,
                          userEmail: widget.userEmail,
                          conversationId: conversation.id,
                          initialTitle: conversation.title,
                        
                        ).then((_) {
                          // refresh conversations list after editing
                          _refreshConversations();
                        });
                      }, // end 'onLongPress'
                    ),
                  );
                }, // end 'itemBuilder'
              ),
            ),

          ], // end 'children' widget array

        ),
      ),
    );
  } // end 'build' overridden method

} // end '_SavedConversationsTabState' state class