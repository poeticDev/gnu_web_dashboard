import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:uuid/uuid.dart';

class Message {
  /// 1) 식별 키
  final String key;

  /// 2) 대상 강의실
  final List<String> roomId;

  /// 3) 메세지 내용
  final String content;

  /// 4) 대상 기기
  final List<String> target;

  /// 4) 표출 기간
  final DateTime until;

  /// 5) 메세지 타입
  final MessageType type;

  /// 6) 최종 수정일
  DateTime? lastUpdated;

  Message({
    required this.key,
    required this.roomId,
    required this.content,
    required this.target,
    required this.until,
    required this.type,
    this.lastUpdated,
  }) {
    lastUpdated ??= DateTime.now();
  }

  factory Message.withoutKey({
    required List<String> roomIdList,
    required String content,
    required List<String> target,
    required DateTime until,
    required MessageType type,
    DateTime? lastUpdated,
  }) {
    return Message(
      key: _generateKey(),
      roomId: roomIdList,
      content: content,
      target: target,
      until: until,
      type: type,
      lastUpdated: lastUpdated,
    );
  }

  factory Message.fromMap(Map<String, dynamic> messageDataMap) {
    final List roomIdList = messageDataMap["roomId"];
    final List<String> roomIdListTypeCasted =
        roomIdList.cast<String>().toList();


    final List targetList = messageDataMap['target'];
    final List<String> targetListTypeCasted = targetList.cast<String>().toList();

    final DateTime until =
        DateTime.tryParse(messageDataMap["until"]) ??
        DateTime.now().add(Duration(days: 1));


    final MessageType type = MessageType.values.byName(messageDataMap['type']);


    final DateTime? lastUpdated = DateTime.tryParse(
      messageDataMap["lastUpdated"],
    );


    return Message(
      key: messageDataMap['key'],
      roomId: roomIdListTypeCasted,
      content: messageDataMap['content'],
      target: targetListTypeCasted,
      until: until,
      type: type,
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> getMessageMap() {
    final Map<String, dynamic> result = {
      "key": key,
      "roomId": roomId,
      "content": content,
      "target": target,
      "until": until.toString(),
      "type": type.name,
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

MessageType messageTypeFromLabel(String label) {
  return MessageType.values.firstWhere(
        (e) => e.label == label,
    orElse: () => MessageType.normal,
  );
}
