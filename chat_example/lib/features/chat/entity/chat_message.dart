import 'dart:convert';

class ChatMessage {
  final String message;
  ChatMessage({
    required this.message,
  });

  ChatMessage copyWith({
    String? message,
  }) {
    return ChatMessage(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));

  @override
  String toString() => 'ChatMessage(message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
