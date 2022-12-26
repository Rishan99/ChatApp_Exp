import 'dart:convert';

import 'package:chat_example/config/enum.dart';

class SocketMessage {
  final ConnectionState connectionState;
  final String message;
  SocketMessage({
    required this.connectionState,
    required this.message,
  });

  SocketMessage copyWith({
    ConnectionState? connectionState,
    String? message,
  }) {
    return SocketMessage(
      connectionState: connectionState ?? this.connectionState,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'connectionState': connectionState,
      'message': message,
    };
  }

  factory SocketMessage.fromMap(Map<String, dynamic> map) {
    return SocketMessage(
      connectionState: (map['connectionState']),
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SocketMessage.fromJson(String source) => SocketMessage.fromMap(json.decode(source));

  @override
  String toString() => 'SocketMessage(connectionState: $connectionState, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocketMessage && other.connectionState == connectionState && other.message == message;
  }

  @override
  int get hashCode => connectionState.hashCode ^ message.hashCode;
}
