import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];
  Map<int, List<ChatMessage>> _chatMessages = {}; // chatId -> messages
  int? _selectedChatId;
  bool _isLoading = false;
  String? _errorMessage;

  List<Chat> get chats => List.unmodifiable(_chats);
  List<ChatMessage> get selectedChatMessages {
    if (_selectedChatId == null) return [];
    return _chatMessages[_selectedChatId] ?? [];
  }

  int? get selectedChatId => _selectedChatId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalUnread => _chats.fold(0, (sum, chat) => sum + chat.unreadCount);

  // Загрузить все чаты
  Future<void> loadChats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

  // starting loadChats

    try {
      final chatsData = await ApiService.getChats();
      _chats = chatsData.map((json) => Chat.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
  // finished loadChats
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      // ignore: avoid_print
      print('ChatProvider.loadChats error: $e');
    }
  }

  // Выбрать чат и загрузить сообщения
  Future<void> selectChat(int chatId) async {
    try {
  // selecting chat

      _selectedChatId = chatId;

      // Если сообщения уже загружены, просто переключаемся
      if (_chatMessages.containsKey(chatId)) {
        notifyListeners();
        return;
      }

      // Загружаем сообщения для нового чата
      await loadChatMessages(chatId);
    } catch (e, st) {
      // record error internally and clear selection
      // Ensure we don't leave a dangling selection that may break UI
      _selectedChatId = null;
      notifyListeners();
      rethrow;
    }
  }

  // Загрузить сообщения для конкретного чата
  Future<void> loadChatMessages(int chatId) async {
    try {
  // loading messages for chatId

      // TODO: Add API endpoint for getting messages
      // For now, load mock messages
      _chatMessages[chatId] = _generateMockMessages(chatId);
      notifyListeners();
    } catch (e, st) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Отправить сообщение
  Future<bool> sendMessage(int chatId, String message, {String? fileUrl}) async {
    try {
      final result = await ApiService.sendMessage(
        chatId: chatId,
        message: message,
        fileUrl: fileUrl,
      );

      // Добавляем сообщение в локальный список
      final newMessage = ChatMessage(
        id: result['id'] ?? DateTime.now().millisecondsSinceEpoch,
        chatId: chatId,
        senderId: result['sender_id'] ?? 1,
        senderName: result['sender_name'] ?? 'You',
        senderRole: 'consumer',
        message: message,
        fileUrl: fileUrl,
        sentAt: DateTime.now(),
        isRead: true,
      );

      if (!_chatMessages.containsKey(chatId)) {
        _chatMessages[chatId] = [];
      }

      _chatMessages[chatId]!.add(newMessage);

      // Обновляем last_message в чате
      final chatIndex = _chats.indexWhere((c) => c.id == chatId);
      if (chatIndex != -1) {
        final updatedChat = _chats[chatIndex];
        _chats[chatIndex] = Chat(
          id: updatedChat.id,
          supplierId: updatedChat.supplierId,
          supplierName: updatedChat.supplierName,
          lastMessage: message,
          lastMessageAt: DateTime.now(),
          unreadCount: 0,
          isActive: updatedChat.isActive,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<int> startChatWithSupplier(int supplierId, String supplierName) async {
    // Try to parse supplierId to int (keeps compatibility with Chat model).
    final intSupplierId = supplierId;

    // Look for existing chat safely (no firstWhere(orElse: () => null) misuse).
    Chat? existingChat;
    for (final c in _chats) {
      if (c.supplierId == intSupplierId) {
        existingChat = c;
        break;
      }
    }

    if (existingChat != null) {
      // Return existing chat id — do not create duplicate
      return existingChat.id;
    }

    // If supplierId couldn't be parsed, you might want to handle that case.
    // Here we still create a new chat but set supplierId to -1.
    final newChat = Chat(
      id: DateTime.now().millisecondsSinceEpoch,
      supplierId: intSupplierId,
      supplierName: supplierName,
      lastMessage: 'Chat created',
      lastMessageAt: DateTime.now(),
      unreadCount: 0,
    );

    _chats.add(newChat);
    notifyListeners();

    return newChat.id;
  }



  // Отметить сообщение как прочитанное
  void markMessageAsRead(int chatId, int messageId) {
    if (_chatMessages.containsKey(chatId)) {
      final messageIndex =
          _chatMessages[chatId]!.indexWhere((m) => m.id == messageId);
      if (messageIndex != -1) {
        final message = _chatMessages[chatId]![messageIndex];
        _chatMessages[chatId]![messageIndex] = ChatMessage(
          id: message.id,
          chatId: message.chatId,
          senderId: message.senderId,
          senderName: message.senderName,
          senderRole: message.senderRole,
          message: message.message,
          fileUrl: message.fileUrl,
          audioUrl: message.audioUrl,
          sentAt: message.sentAt,
          isRead: true,
        );
        notifyListeners();
      }
    }
  }

  // Сбросить выбранный чат
  void clearSelectedChat() {
    // clear selected chat
    _selectedChatId = null;
    notifyListeners();
  }

  // Очистить ошибку
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Mock данные для тестирования
  List<ChatMessage> _generateMockMessages(int chatId) {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: 1,
        chatId: chatId,
        senderId: 100,
        senderName: 'Fresh Farm Supplies',
        senderRole: 'sales',
        message: 'Hello! Thanks for your order. We have fresh tomatoes available.',
        sentAt: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessage(
        id: 2,
        chatId: chatId,
        senderId: 1,
        senderName: 'You',
        senderRole: 'consumer',
        message: 'Great! How much would 10kg cost?',
        sentAt: now.subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      ChatMessage(
        id: 3,
        chatId: chatId,
        senderId: 100,
        senderName: 'Fresh Farm Supplies',
        senderRole: 'sales',
        message: '10kg would be 15,000 KZT. Delivery available tomorrow.',
        sentAt: now.subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: 4,
        chatId: chatId,
        senderId: 1,
        senderName: 'You',
        senderRole: 'consumer',
        message: 'Perfect! Let\'s proceed with the order.',
        sentAt: now.subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
    ];
  }

  // Для тестирования - загрузить mock чаты
  void loadMockChats() {
  // populate mock chats
    _chats = [
      Chat(
        id: 1,
        supplierId: 1,
        supplierName: 'Fresh Farm Supplies',
        lastMessage: 'Perfect! Let\'s proceed with the order.',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 0,
      ),
      Chat(
        id: 2,
        supplierId: 2,
        supplierName: 'Organic Vegetables Co.',
        lastMessage: 'We\'ll have cucumbers in stock on Friday.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 2,
      ),
    ];
    notifyListeners();
  // done populating mock chats
  }
}
