import 'package:uuid/uuid.dart';

class Message {
  final String key;
  final DateTime until;
  final MessageType type;
  final String content;
  final DateTime lastUpdated;

  Message({
    required this.key,
    required this.until,
    required this.type,
    required this.content,
    required this.lastUpdated,
  });

  factory Message.fromMap(Map<String, dynamic> messageDataMap) {
    return Message(
      key: messageDataMap['key'],
      until: DateTime.parse(messageDataMap['until']),
      type: MessageType.values.byName(messageDataMap['type']),
      content: messageDataMap['content'],
      lastUpdated: messageDataMap['lastUpdated'],
    );
  }

  /// 데이터타입과 uuid를 통해 키 생성
  static String _generateKey() {
    return 'message_${Uuid().v4()}';
  }
}

enum MessageType {
  normal,
  warning,
  check,
  announce,
}
