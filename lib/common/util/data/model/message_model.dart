import 'package:uuid/uuid.dart';

class Message {
  /// 1) 식별 키
  final String key;

  /// 2) 대상 강의실
  final List<String> roomId;

  final DateTime until;
  final MessageType type;
  final String content;
  DateTime? lastUpdated;

  Message({
    required this.key,
    required this.roomId,
    required this.until,
    required this.type,
    required this.content,
    this.lastUpdated,
  }) {
    lastUpdated ??= DateTime.now();
  }

  factory Message.withoutKey({
    required List<String> roomIdList,
    required DateTime until,
    required MessageType type,
    required String content,
    DateTime? lastUpdated,
  }) {
    return Message(
      key: _generateKey(),
      roomId: roomIdList,
      until: until,
      type: type,
      content: content,
      lastUpdated: lastUpdated,
    );
  }

  factory Message.fromMap(Map<String, dynamic> messageDataMap) {
    final List roomIdList = messageDataMap["roomId"];
    final List<String> roomIdListTypeCasted =
        roomIdList.cast<String>().toList();

    final DateTime until =
        DateTime.tryParse(messageDataMap["util"]) ??
        DateTime.now().add(Duration(days: 1));

    final MessageType type = MessageType.values.byName(messageDataMap['type']);

    final DateTime? lastUpdated = DateTime.tryParse(
      messageDataMap["lastUpdated"],
    );

    return Message(
      key: messageDataMap['key'],
      roomId: roomIdListTypeCasted,
      until: until,
      type: type,
      content: messageDataMap['content'],
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> getMessageMap() {
    final Map<String, dynamic> result = {
      "key": key,
      "roomId": roomId,
      "until": until,
      "type": type.name,
      "content": content,
      "lastUpdated": lastUpdated.toString(),
    };

    return result;
  }

  /// 데이터타입과 uuid를 통해 키 생성
  static String _generateKey() {
    return 'message_${Uuid().v4()}';
  }
}

enum MessageType { normal, warning, check, announce }

extension MessageTypeLabel on MessageType {
  String get label {
    switch (this) {
      case MessageType.normal:
        return '일반';
      case MessageType.warning:
        return '경고';
      case MessageType.check:
        return '체크';
      case MessageType.announce:
        return '공지사항';
    }
  }
}
