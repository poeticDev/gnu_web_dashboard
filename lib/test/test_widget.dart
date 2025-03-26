import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';

class TestWidget extends ConsumerWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            WsManager().connectWS(serverIp: serverIp);
          },
          child: Text('웹소켓 연결'),
        ),
        ElevatedButton(
          onPressed: () async {
            String testJson =
                await rootBundle.loadString('test/json_sample.json');
            WsManager().sendStringMessage(testJson);
          },
          child: Text('웹소켓 발송'),
        ),
      ],
    );
  }
}
