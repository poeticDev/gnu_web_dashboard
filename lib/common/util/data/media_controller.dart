import 'dart:convert';

import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/test/test_data.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_controller.g.dart';

@Riverpod(keepAlive: true)
class MediaController extends _$MediaController {
  List<MediaItem> get _initialState => [];

  final WsManager _ws = WsManager();

  @override
  List<MediaItem> build() {
    return _initialState;
  }

  Future<void> getAliveMediaItemList() async {}

  Future<void> getFullMediaItemList() async {}

  Future<int> createMediaItem({required MediaItem mediaItem}) async {
    return 0;
  }

  Future<int> updateMediaItem() async {
    return 0;
  }

  Future<int> insertMediaItemToServer(
      {required List<MediaItem> mediaItemList}) async {
    List<Map> dataList = [];

    for (var mediaItem in sampleMediaList) {
      dataList = [
        ...dataList,
        mediaItem.getMediaItemMap(),
      ];
    }

    final dataMap = {
      "mediaData": dataList,
    };

    print(dataMap);
    print(jsonEncode(dataMap));

    try {
      _ws.sendStringMessage(jsonEncode(dataMap));
    } catch (e) {
      eLog('미디어 아이템 추가 실패 : $e');
      return 1;
    }

    return 0;
  }

  void uploadSampleMedia() {
    state = [
      ...state,
      ...sampleMediaList,
    ];
  }
}
