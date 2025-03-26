import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:gnu_web_dashboard/common/util/log_helper.dart';

const serverIp = 'wss://192.168.219.137/api/v1/ws';

class WsManager {
  static WebSocket? _ws;
  Timer? _pingTimer;

// 싱글톤 클래스
  static final WsManager _instance = WsManager._internal();

  WsManager._internal();

  factory WsManager() {
    return _instance;
  }

  // bool isConnected() {
  //   if
  // }

  void connectWS({required String serverIp}) {
    if(_ws != null) {
      disConnect();
    }

    try {
      _ws = WebSocket(serverIp);

      _ws!.onOpen.listen((event) {
        print('✅ 웹소켓 연결 성공');
        startPing();
      });

      _ws!.onMessage.listen((event) {
        print('📩 웹소켓 메세지 수신 : ${event.data}');
      });

      _ws!.onError.listen((event) {
        print('❌ 웹소켓 오류 발생: $event');
        stopPing();
        // 웹소켓 오류는 이벤트 객체에서 직접적인 메시지를 제공하지 않을 수 있음.
        // 네트워크 콘솔에서 추가 디버깅 필요.
      });

      _ws!.onClose.listen((event) {
        print('🔌 웹소켓 연결 종료');
        stopPing();
      });
    } catch (e) {
      print('❌ 웹소켓 연결 실패 : $e');
    }
  }

  void disConnect() {
    _ws?.close();
    stopPing();
  }

  void startPing() {
    _ws?.send('ping');
    _pingTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _ws?.send('ping');
      print('📡 Ping sent to keep connection alive');
    });
  }

  void stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> sendStringMessage(String message) async {
    if (_ws == null) {
      eLog('❌ 웹소켓 연결 안 됨');
      return;
    }
    try {
      _ws!.sendString(message);
      dLog('📤 웹소켓 발송 : $message');
    } catch (e) {
      eLog('❌ 웹소켓 발송 실패 : $e');
    }
  }

  String jsonFromMap(Map mapData) {
    String result = '';
    try {
      result = jsonEncode(mapData);
    } catch (e) {
      eLog('json 인코딩 실패 : $e');
      result = 'json 인코딩 실패';
    }
    return result;
  }
}
