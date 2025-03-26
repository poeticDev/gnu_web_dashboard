import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class MediaItem {
  /// 1) 식별 키
  final String key;

  /// 대상 강의실
  final List<String> roomId;

  /// 대상 기기
  final List<String> target;

  /// 2) 미디어 이름
  final String title;

  /// 3) 미디어 타입
  final MediaType type;

  /// 4) 주소
  final String url;

  /// 5) 파일명
  /// - 없으면 url 마지막 부분에서 파일명 추출
  final String? fileName;

  /// 6) 저장위치
  final MediaFrom from;

  /// 7) 미디어 표출 방식
  /// - cover(기본): 꽉 채움
  /// - contain: 여백이 있더라도 다 나오게)
  final BoxFit fit;

  /// 8) 표출 순서 : 기본 생성순
  final int orderNum;

  DateTime? lastUpdated;

  /// 9) 미디어 상태(표출 중, 미표출)
  final bool isDead;

  MediaItem({
    required this.key,
    required this.roomId,
    required this.target,
    required this.title,
    required this.type,
    required this.url,
    this.fileName,
    required this.from,
    this.fit = BoxFit.cover,
    this.orderNum = 0,
    this.lastUpdated,
    this.isDead = false,
  }) {
    lastUpdated ??= DateTime.now();
  }

  factory MediaItem.withoutKey({
    required List<String> roomId,
    required List<String> target,
    required String title,
    required MediaType type,
    required String url,
    String? fileName,
    required MediaFrom from,
    BoxFit fit = BoxFit.cover,
    int orderNum = 0,
    DateTime? lastUpdated,
    bool isDead = false,
  }) {
    return MediaItem(
      key: _generateKey(),
      roomId: roomId,
      target: target,
      title: title,
      type: type,
      url: url,
      from: from,
      fit: fit,
      orderNum: orderNum,
      lastUpdated: lastUpdated,
      isDead: isDead,
    );
  }

  /// 데이터타입과 uuid를 통해 키 생성
  static String _generateKey() {
    return 'mediaItem_${Uuid().v4()}';
  }

  factory MediaItem.fromMap(Map<String, dynamic> mediaDataMap) {
    return MediaItem(
      key: mediaDataMap["key"],
      roomId: mediaDataMap["roomId"],
      target: mediaDataMap["target"],
      title: mediaDataMap["title"],
      type: mediaDataMap["type"],
      url: mediaDataMap["url"],
      from: mediaDataMap["from"],
      fit: mediaDataMap["fit"],
      orderNum: mediaDataMap["orderNum"],
      lastUpdated: mediaDataMap["lastUpdated"],
      isDead: mediaDataMap["isDead"],
    );
  }

  /// 현재 인스턴스의 데이터 맵을 반환
  Map<String, dynamic> getMediaItemMap() {
    final Map<String, dynamic> result = {
      "key": key,
      "roomId": roomId,
      "target": target,
      "title": title,
      "type": type.name,
      "url": url,
      "fileName": fileName,
      "from": from.name,
      "fit": fit.name,
      "orderNum": orderNum,
      "lastUpdated": lastUpdated.toString(),
      "isDead": isDead
    };

    return result;
  }
}

enum MediaType { image, video, webView }

enum MediaFrom { gDrive, etc, webView }
