import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/common/util/data/model/test_data.dart';
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

  List<MediaItem> uploadSampleMedia() {
    final List<MediaItem> sampleMediaList = [
      mediaItemSampleImage,
      mediaItemSampleImageFromG,
      mediaItemSampleVideo,
    ];

    state = [
      ...state,
      sampleMediaList,
    ];

    return [
      mediaItemSampleImage,
      mediaItemSampleImageFromG,
      mediaItemSampleVideo,
    ];
  }
}
