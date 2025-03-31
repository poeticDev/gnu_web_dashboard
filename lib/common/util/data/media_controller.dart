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
        queryParameters: {"type": "messageData"},
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

    try {
      jsonData = jsonEncode(mediaItem.getMediaItemMap());
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

    return 0;
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
