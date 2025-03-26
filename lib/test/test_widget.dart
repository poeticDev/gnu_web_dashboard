import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/util/data/media_controller.dart';
import 'package:gnu_web_dashboard/test/test_data.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';

class TestWidget extends ConsumerWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        ElevatedButton(
          onPressed: () {
            WsManager().connectWS(serverIp: serverIp);
          },
          child: Text('웹소켓 연결'),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                ref.read(mediaControllerProvider.notifier).uploadSampleMedia();
              },
              child: Text('미디어 샘플 데이터 업로드'),
            ),
            ElevatedButton(
              onPressed: () async {
                ref
                    .read(mediaControllerProvider.notifier)
                    .insertMediaItemToServer(mediaItemList: sampleMediaList);
              },
              child: Text('샘플 미디어 데이터 리스트 추가'),
            ),
          ],
        ),
      ],
    );
  }
}
