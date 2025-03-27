import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/util/data/media_controller.dart';
import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/test/test_data.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';

class TestWidget extends ConsumerWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                WsManager().connectWS(serverIp: serverIp);
              },
              child: Text('웹소켓 연결'),
            ),
            ElevatedButton(
              onPressed: () async {
                WsManager().addJsonEventHandler(
                    "mediaData",
                    ref
                        .read(mediaControllerProvider.notifier)
                        .updateStateMediaItem);
              },
              child: Text('미디어아이템 수신 핸들러 등록'),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                ref.read(mediaControllerProvider.notifier).uploadSampleMedia();
              },
              child: Text('미디어 샘플 데이터 웹앱 업로드'),
            ),
            ElevatedButton(
              onPressed: () async {
                ref
                    .read(mediaControllerProvider.notifier)
                    .upsertMediaItemToServer(mediaItemList: sampleMediaList);
              },
              child: Text('미디어 샘플 데이터 리스트 서버 추가 요청'),
            ),
            ElevatedButton(
              onPressed: () {
                final MediaItem test = MediaItem(
                  key: "ediaItem_9536c46e-86c0-45bc-927d-989d87caf827",
                  roomId: ['룸 아이디 바꿨음'],
                  target: ['wall_hub'],
                  title: '미디어: 이미지 샘플',
                  type: MediaType.image,
                  url:
                      'https://www.gnu.ac.kr/upload/main/na/bbs_5171/ntt_2264748/img_44ab9c58-a741-4b93-bd7b-ddeee17c0ac11736728581323.png',
                  from: MediaFrom.etc,
                  isDead: false,
                );

                ref
                    .read(mediaControllerProvider.notifier)
                    .upsertMediaItemToServer(mediaItemList: [test]);
              },
              child: Text('미디어 데이터 수정'),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                ref.read(mediaControllerProvider.notifier).uploadSampleMedia();
              },
              child: Text('메세지 샘플 데이터 웹앱 업로드'),
            ),
            ElevatedButton(
              onPressed: () async {
                ref
                    .read(mediaControllerProvider.notifier)
                    .upsertMediaItemToServer(mediaItemList: sampleMediaList);
              },
              child: Text('메세지 샘플 데이터 리스트 서버 추가 요청'),
            ),
          ],
        )
      ],
    );
  }
}
