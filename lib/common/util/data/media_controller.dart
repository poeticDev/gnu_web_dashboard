import 'dart:convert';

import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/test/test_data.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_controller.g.dart';

@Riverpod(keepAlive: true)
class MediaController extends _$MediaController {
  Map<String, MediaItem> get _initialState => {};

  final WsManager _ws = WsManager();

  @override
  Map<String, MediaItem> build() {
    return _initialState;
  }

  Future<void> requestAliveMediaItemList(String roomId) async {
    final Map req = {"topic": "mediaItem_alive", "payload": roomId};
    final String encodedReq = jsonEncode(req);

    _ws.sendStringMessage(encodedReq);
  }

  Future<void> requestEveryMediaItemList(String roomId) async {
    final Map req = {"topic": "mediaItem_every", "payload": roomId};
    final String encodedReq = jsonEncode(req);

    _ws.sendStringMessage(encodedReq);
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

  Future<int> upsertMediaItemToServer(
      {required List<MediaItem> mediaItemList}) async {
    List<Map> dataList = [];

    for (MediaItem mediaItem in mediaItemList) {
      dataList = [
        ...dataList,
        mediaItem.getMediaItemMap(),
      ];
    }

    final dataMap = {
      "mediaData": dataList,
    };

    try {
      _ws.sendStringMessage(jsonEncode(dataMap));
    } catch (e) {
      eLog('미디어 아이템 추가 실패 : $e');
      return 1;
    }

    return 0;
  }

  void uploadSampleMedia() {
    for (MediaItem mediaItem in sampleMediaList)
      state = {
        ...state,
        mediaItem.key: mediaItem,
      };
  }
}
