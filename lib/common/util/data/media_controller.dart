import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/common/util/network/http_manager.dart';
import 'package:gnu_web_dashboard/test/test_data.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_controller.g.dart';

@Riverpod(keepAlive: true)
class MediaController extends _$MediaController {
  static String _serverHttpApiIp = 'https://192.168.219.137/api/v1/';

  Map<String, MediaItem> get _initialState => {};

  final WsManager _ws = WsManager();
  final HttpManager _http = HttpManager();

  @override
  Map<String, MediaItem> build() {
    return _initialState;
  }

  /// 현재 등록된 미디어 목록
  List<MediaItem> getSingleRoomMediaList(String roomId) {
    final List<MediaItem> mediaList =
        state.values.where((e) => e.roomId.contains(roomId)).toList();

    return mediaList;
  }

  /// 현재 상태에 반영
  void updateSingleState(MediaItem mediaItem) {
    state = {...state, mediaItem.key: mediaItem};
  }

  /// -> 서버 : 목록 요청
  Future<void> requestMediaItemList({bool isDead = false}) async {
    final deadMap = {"isDead": isDead};

    Response? response;

    try {
      response = await _http.post(
        path: '/read',
        queryParameters: {"type": "mediaData"},
        data: deadMap,
        options: Options(contentType: Headers.jsonContentType),
      );

      dLog('미디어 목록 alive res: $response');
    } catch (e) {
      eLog('미디어 목록 요청 실패: $e');
    }

    try {
      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<MediaItem> decodedData =
            data
                .map((e) => MediaItem.fromMap(e as Map<String, dynamic>))
                .toList();

        for (MediaItem mediaItem in decodedData) {
          updateSingleState(mediaItem);
        }

        return;
      }
      eLog('미디어 목록 응답 불량: ${response?.statusCode ?? '응답 없음'}');
    } catch (e) {
      eLog('미디어 목록 갱신 실패: $e');
    }
  }

  /// -> 서버 : 업서트
  Future<int> upsertSingleMediaItemToServer({
    required MediaItem mediaItem,
  }) async {
    Response? response;
    late final String jsonData;

    final mediaItemMap = mediaItem.getMediaItemMap();
    final dataMap = {"mediaData": [mediaItemMap]};

    try {
      jsonData = jsonEncode(dataMap);
    } catch (e) {
      eLog('미디어 아이템 json 변환 실패 : $e');
      return 1;
    }

    try {
      response = await _http.post(
        path: '$_serverHttpApiIp/edit',
        queryParameters: {"type": "messageData"},
        data: jsonData,
      );

      if (response?.statusCode != 200)
        throw Exception(
          'res status: ${response?.statusCode} | statusMessage: ${response?.statusMessage}',
        );

      dLog('미디어 upsert res: $response');
    } catch (e) {
      eLog('미디어 upsert http 요청 실패 : $e');
      return 1;
    }

    if (response != null && response.statusCode == 200) {
      updateSingleState(mediaItem);
      return 0;
    } else {
      iLog('미디어 upsert 성공, but 상태 반영 실패');
    }

    return 1;
  }

  /// 미디어아이템 필드가 수정됐을 때 호출
  Future<void> handleFieldChange({
    required String key,
    required String field,
    required dynamic value,
  }) async {
    /// 1. key로 미디어 데이터 불러오기
    Map<String, dynamic> mediaItemMap = state[key]!.getMediaItemMap();
    dLog('1. 기존 미디어아이템 맵 불러오기 : $mediaItemMap');

    /// 2. 불러온 미디어 데이터의 field와 value 수정
    switch (field) {
      case 'type':
        mediaItemMap[field] = mediaTypeFromLabel(value).name;
        break;
      case 'from':
        mediaItemMap[field] = mediaFromFromLabel(value).name;
        break;
      case 'fit':
        mediaItemMap[field] = boxFitFromLabel(value).name;
        break;
      case 'lastUpdated':
        mediaItemMap[field] = value.toString();
        break;
      default:
        mediaItemMap[field] = value;
    }

    dLog('2. 미디어아이템 맵 수정 : $mediaItemMap');

    /// 3. 수정된 미디어 데이터 전송 + 4. 응답 수신 후, state 반영
    final updated = MediaItem.fromMap(mediaItemMap);
    final result = await upsertSingleMediaItemToServer(mediaItem: updated);
    dLog('3. 미디어아이템 맵 전송 : $result');

    /// 업데이트 실패 시, 현재 목록을 서버로부터 다시 받아와 복구
    if (result != 0) {
      dLog('미디어 목록 갱신 요청');
      await requestMediaItemList();
    }
  }

  /// depricated
  Future<int> upsertMediaItemToServer({
    required List<MediaItem> mediaItemList,
  }) async {
    List<Map> dataList = [];

    for (MediaItem mediaItem in mediaItemList) {
      dataList = [...dataList, mediaItem.getMediaItemMap()];
    }

    final dataMap = {"mediaData": dataList};

    try {
      _ws.sendStringMessage(jsonEncode(dataMap));
    } catch (e) {
      eLog('미디어 아이템 추가 실패 : $e');
      return 1;
    }

    return 0;
  }

  Future<int> createMediaItem({required MediaItem mediaItem}) async {
    return 0;
  }

  /// ws_manager 연결 시 등록. 수신한 미디어 아이템 처리
  void updateStateMediaItem(var mediaItemList) {
    if (mediaItemList is List) {
      for (var item in mediaItemList) {
        if (item is Map<String, dynamic>) {
          try {
            final newItem = MediaItem.fromMap(item);
            state = {...state, newItem.key: newItem};
            dLog('미디어 아이템 탑재 성공: ${newItem.key}');
          } catch (e) {
            eLog('미디어 아이템 탑재 실패 : $e');
          }
        }
      }
    } else {
      eLog('수신한 mediaItemList가 리스트가 아닙니다. : ${mediaItemList.runtimeType}');
    }
  }

  void uploadSampleMedia() {
    for (MediaItem mediaItem in sampleMediaList)
      state = {...state, mediaItem.key: mediaItem};
  }
}
