import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).loadMockChats();
    });
  }

  void _openNewChatDialog(BuildContext context) {
    final supplierLinkProvider = Provider.of<SupplierLinkProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    final suppliers = supplierLinkProvider.connectedSuppliers;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFFFF),
          title: const Text(
            'Start New Chat',
            style: TextStyle(
              color: Color(0xFF3F6533),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: suppliers.isEmpty
              ? const Text(
            'No approved suppliers yet.',
            style: TextStyle(color: Color(0xFF3F6533)),
          )
              : SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];

                return ListTile(
                  leading: const Icon(Icons.store, color: Color(0xFF6B8E23)),
                  title: Text(
                    supplier.supplierName,
                    style: const TextStyle(
                      color: Color(0xFF3F6533),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    // Start new chat
                    final newChatId = await chatProvider.startChatWithSupplier(
                      supplier.supplierId,
                      supplier.supplierName,
                    );

                    Navigator.pop(context); // close dialog

                    // Open new chat directly
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _ChatDetailScreen(
                          chat: Chat(
                            id: newChatId,
                            supplierId: supplier.supplierId,
                            supplierName: supplier.supplierName,
                            lastMessage: '',
                            lastMessageAt: DateTime.now(),
                            unreadCount: 0,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFF3F6533)),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
  // ChatScreen build
        try {
          if (chatProvider.chats.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Messages',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                backgroundColor: const Color(0xFF6B8E23),
                foregroundColor: Colors.white,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_outlined, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'No chats yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect with suppliers to start messaging',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xFF6B8E23),
                child: const Icon(Icons.add_comment_rounded, color: Colors.white),
                onPressed: () {
                  _openNewChatDialog(context);
                },
              ),
            );
          }

          // We no longer render the detail screen here based on provider state.
          // Navigation to the detail screen is handled explicitly in the onTap handler
          // to avoid lifecycle races on web that can immediately clear selection.

          // Показываем список чатов
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Messages',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              backgroundColor: const Color(0xFF6B8E23),
              foregroundColor: Colors.white,
            ),
            body: ListView.builder(
              itemCount: chatProvider.chats.length,
              itemBuilder: (context, index) {
                final chat = chatProvider.chats[index];
                return _ChatListTile(
                  chat: chat,
                  onTap: () async {
                    try {
                      // Load messages first, then navigate to detail screen.
                      // Capture navigator before awaiting to avoid using `context` across async gap.
                      final navigator = Navigator.of(context);
                      await chatProvider.selectChat(chat.id);

                      // Push detail screen. When it returns, clear selection.
                      await navigator.push(MaterialPageRoute(
                        builder: (_) => _ChatDetailScreen(chat: chat),
                      ));

                      // After returning from detail, clear selection to reset provider state.
                      chatProvider.clearSelectedChat();
                    } catch (e, st) {
                      // Protective handling: show message and stay on list
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Unable to open chat right now')),
                      );
                    }
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF6B8E23),
              child: const Icon(Icons.add_comment_rounded, color: Colors.white),
              onPressed: () {
                _openNewChatDialog(context);
              },
            ),
          );
        } catch (e, st) {
          // Если ошибка всё же произошла — показываем безопасный экран с кнопкой возврата
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Messages',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              backgroundColor: const Color(0xFF6B8E23),
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('An error occurred while loading chats.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      chatProvider.clearSelectedChat();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF6B8E23),
              child: const Icon(Icons.add_comment_rounded, color: Colors.white),
              onPressed: () {
                _openNewChatDialog(context);
              },
            ),
          );
        }
      },
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const _ChatListTile({
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF6B8E23).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.store,
          color: Color(0xFF6B8E23),
        ),
      ),
      title: Text(
        chat.supplierName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chat.lastMessageAt),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          if (chat.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: Color(0xFF6B8E23),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}

class _ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const _ChatDetailScreen({required this.chat});

  @override
  State<_ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<_ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  // ChatDetailScreen init

    // Ensure we scroll to bottom after messages are built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      } catch (e, st) {
        // If scrolling fails, ignore silently (safe guard)
      }
    });
  }

  @override
  void dispose() {
  // ChatDetailScreen dispose
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(ChatProvider chatProvider) async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final success = await chatProvider.sendMessage(
        widget.chat.id,
        _messageController.text.trim(),
      );

      if (success) {
        _messageController.clear();
        ErrorHandler.showSuccessSnackBar(context, 'Message sent');
        
        // Scroll to bottom
        await Future.delayed(const Duration(milliseconds: 100));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        ErrorHandler.showErrorSnackBar(
          context,
          chatProvider.errorMessage ?? 'Failed to send message',
        );
      }
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.chat.supplierName),
            backgroundColor: const Color(0xFF6B8E23),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Clear selected chat and go back to chat list
                chatProvider.clearSelectedChat();
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              // Messages List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.selectedChatMessages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.selectedChatMessages[index];
                    final isOwn = message.senderRole == 'consumer';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: isOwn
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isOwn)
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B8E23).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.store,
                                color: Color(0xFF6B8E23),
                                size: 18,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: isOwn
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isOwn
                                        ? const Color(0xFF6B8E23)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                      color: isOwn ? Colors.white : Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatMessageTime(message.sentAt),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isOwn) const SizedBox(width: 8),
                          if (isOwn)
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B8E23),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Message Input
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_file),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('File upload coming soon'),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.mic),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Audio recording coming soon'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () => _sendMessage(chatProvider),
                      mini: true,
                      backgroundColor: const Color(0xFF6B8E23),
                      child: const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatMessageTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
