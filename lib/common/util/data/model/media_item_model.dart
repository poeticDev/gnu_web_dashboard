import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class MediaItem {
  /// 1) 식별 키
  final String key;

  /// 2) 대상 강의실
  final List<String> roomId;

  /// 3) 미디어 이름
  final String title;

  /// 4) 미디어 타입
  final MediaType type;

  /// 5) 주소
  final String url;

  /// 6) 파일명
  /// - 없으면 url 마지막 부분에서 파일명 추출
  final String? fileName;

  /// 7) 저장위치
  final MediaFrom from;

  /// 8) 미디어 표출 방식
  /// - cover(기본): 꽉 채움
  /// - contain: 여백이 있더라도 다 나오게)
  final BoxFit fit;

  /// 9) 표출 순서 : 기본 생성순
  final int orderNum;

  /// 10) 마지막 수정 일시
  DateTime? lastUpdated;

  /// 11) 미디어 상태(표출 중, 미표출)
  final bool isDead;

  MediaItem({
    required this.key,
    required this.roomId,
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
    required List<String> roomIdList,
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
      roomId: roomIdList,
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
    final List roomIdList = mediaDataMap["roomId"];
    final List<String> roomIdListTypeCasted =
        roomIdList.cast<String>().toList();

    final MediaType type = MediaType.values.byName(mediaDataMap["type"]);
    final MediaFrom from = MediaFrom.values.byName(mediaDataMap["from"]);
    final BoxFit fit = BoxFit.values.byName(mediaDataMap["fit"]);
    final DateTime lastUpdated =
        DateTime.tryParse(mediaDataMap["lastUpdated"]) ?? DateTime.now();

    return MediaItem(
      key: mediaDataMap["key"],
      roomId: roomIdListTypeCasted,
      title: mediaDataMap["title"],
      type: type,
      url: mediaDataMap["url"],
      from: from,
      fit: fit,
      orderNum: mediaDataMap["orderNum"],
      lastUpdated: lastUpdated,
      isDead: mediaDataMap["isDead"],
    );
  }

  /// 현재 인스턴스의 데이터 맵을 반환
  Map<String, dynamic> getMediaItemMap() {
    final Map<String, dynamic> result = {
      "key": key,
      "roomId": roomId,
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

enum MediaType { image, video,
  // webView
}

extension MediaTypeLabel on MediaType {
  String get label {
    switch (this) {
      case MediaType.image:
        return '이미지';
      case MediaType.video:
        return '영상';
      // case MediaType.webView:
      //   return '웹페이지';
    }
  }
}

enum MediaFrom { gDrive, etc,
  // webView
}

extension MediaFromLabel on MediaFrom {
  String get label {
    switch (this) {
      case MediaFrom.gDrive:
        return '전용 구글 드라이브';
      case MediaFrom.etc:
        return '기타';
      // case MediaFrom.webView:
      //   return '웹페이지';
    }
  }
}

extension BoxFitLabel on  BoxFit {
  String get label {
    switch (this) {
      case BoxFit.cover:
        return '채우기';
      case BoxFit.contain:
        return '큰 폭에 맞춤';
      case BoxFit.fill:
        return '늘이기';
      case BoxFit.fitWidth:
        // 안 씀
        throw UnimplementedError();
      case BoxFit.fitHeight:
      // 안 씀
        throw UnimplementedError();
      case BoxFit.none:
      // 안 씀
        throw UnimplementedError();
      case BoxFit.scaleDown:
      // 안 씀
        throw UnimplementedError();
      }
    }
  }


MediaType mediaTypeFromLabel(String label) {
  return MediaType.values.firstWhere(
        (e) => e.label == label,
    orElse: () => MediaType.image,
  );
}

MediaFrom mediaFromFromLabel(String label) {
  return MediaFrom.values.firstWhere(
        (e) => e.label == label,
    orElse: () => MediaFrom.etc,
  );
}

BoxFit boxFitFromLabel(String label) {
  return BoxFit.values.firstWhere(
        (e) {
      try {
        return e.label == label;
      } catch (_) {
        return false; // UnimplementedError 던지는 항목들은 패스
      }
    },
    orElse: () => BoxFit.cover,
  );
}

