import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towers/components/ai_tool/features/chat/data/conversation_repository.dart';
import 'package:towers/components/ai_tool/features/chat/domain/conversation.dart';
import 'package:towers/components/ai_tool/features/chat/presentation/chat_screen.dart';
import 'package:towers/components/ai_tool/core/widgets/edit_conversation_dialog.dart'; // import the new dialog file

class SavedConversationsTab extends StatefulWidget {
  final String userEmail;  // Add userEmail as a parameter

  const SavedConversationsTab({super.key, required this.userEmail});  // constructor with required userEmail

  @override
  _SavedConversationsTabState createState() => _SavedConversationsTabState();
}

class _SavedConversationsTabState extends State<SavedConversationsTab> {

  late final ConversationRepository _conversationRepository;
  late final ScrollController _scrollController;
  List<Conversation> _conversations = [];  // list of conversations
  bool _isLoading = false;  // loading state
  bool _hasMore = true;  // flag to check if more data is available
  int _offset = 0;  // current offset for pagination
  final int _limit = 15;  // number of conversations to load per request
  bool _isMounted = false; // Flag to check if the widget is mounted

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
    _loadInitialConversations();
  }

  Future<void> _loadInitialConversations() async {
    if (_isLoading) return;  // return if already loading

    setState(() {
      _isLoading = true;
    });

    try {
      final initialConversations = await _conversationRepository.loadConversations(
        widget.userEmail,
        offset: _offset,
        limit: _limit,
      );
      if (_isMounted) { // check if the widget is still mounted
        setState(() {
          _conversations = initialConversations;
          _offset += initialConversations.length;
          _hasMore = initialConversations.length == _limit;  // if fewer conversations returned, no more data
        });
      }
    } catch (e) {
      // handle error (if needed)
      if (kDebugMode) {
        print('Error loading initial conversations: $e');
      }
    } finally {
      if (_isMounted) { // check if the widget is still mounted
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          _conversations.addAll(newConversations);
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

  @override
  void dispose() {
    _isMounted = false; // set the flag to 'false' when disposing the widget
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

      controller: _scrollController,
      itemCount: _conversations.length + 1,  // number of items in the list + 1 for the loading indicator
      itemBuilder: (context, index) {

        if (index == _conversations.length) {
          // show a loading indicator at the end of the list
          return _isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          )
              : const SizedBox.shrink();  // empty widget when not loading
        } // end IF

        final conversation = _conversations[index];  // get conversation at index

        return Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 2.5, 2.0, 2.5,),

          child: ListTile(

            title: Text(
              // display only the first 50 characters & add an ellipsis if needed
              conversation.title.length > 50
                  ? '${conversation.title.substring(0, 50)}...'  // truncate & add ellipsis
                  : conversation.title,  // full title
              overflow: TextOverflow.ellipsis,  // ensure ellipsis if text overflows
              maxLines: 1,  // limit text to one line
            ),

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
              );
            }, // end 'onTap'

            onLongPress: () {
              // show a dialog to edit the title using the extracted logic
              showEditConversationDialog(
                context: context,
                userEmail: widget.userEmail,
                conversationId: conversation.id,
                initialTitle: conversation.title,

              );
            }, // end 'onLongPress'

          ),
        );
      }, // end 'builder' method
    );
  } // end 'build' overridden method

} // end of 'SavedConversationsTab' widget class