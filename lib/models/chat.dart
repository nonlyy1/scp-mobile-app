class Chat {
  final int id;
  final int supplierId;
  final String supplierName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isActive;

  Chat({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.lastMessage,
    required this.lastMessageAt,
    this.unreadCount = 0,
    this.isActive = true,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      supplierId: json['supplier_id'],
      supplierName: json['supplier_name'] ?? 'Unknown Supplier',
      lastMessage: json['last_message'] ?? '',
      lastMessageAt: DateTime.parse(json['last_message_at'] ?? DateTime.now().toIso8601String()),
      unreadCount: json['unread_count'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'supplier_name': supplierName,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt.toIso8601String(),
      'unread_count': unreadCount,
      'is_active': isActive,
    };
  }
}

class ChatMessage {
  final int id;
  final int chatId;
  final int senderId;
  final String senderName;
  final String senderRole; // 'consumer', 'sales', 'manager', 'owner'
  final String message;
  final String? fileUrl;
  final String? audioUrl;
  final DateTime sentAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    this.fileUrl,
    this.audioUrl,
    required this.sentAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      senderName: json['sender_name'] ?? 'Unknown',
      senderRole: json['sender_role'] ?? 'consumer',
      message: json['message'] ?? '',
      fileUrl: json['file_url'],
      audioUrl: json['audio_url'],
      sentAt: DateTime.parse(json['sent_at']),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'message': message,
      'file_url': fileUrl,
      'audio_url': audioUrl,
      'sent_at': sentAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}
