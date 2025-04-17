import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:gnu_web_dashboard/common/util/log_helper.dart';

const serverIp = 'wss://192.168.219.137/api/v1/ws';

class WsManager {
  static WebSocket? _ws;
  static bool _isConnected = false;
  Timer? _pingTimer;
  Map<String, Function(dynamic data)> jsonEventHandlerMap = {};

  // 싱글톤 클래스
  static final WsManager _instance = WsManager._internal();

  WsManager._internal();

  factory WsManager() {
    return _instance;
  }

  bool isConnected() {
    return _isConnected;
  }

  Future<void> connectWS({required String serverIp}) async {
    if (_ws != null) {
      disConnect();
    }

    try {
      _ws = WebSocket(serverIp);

      _ws!.onOpen.listen((event) {
        print('✅ 웹소켓 연결 성공');
        startPing();
      });

      _isConnected = true;

      _ws!.onMessage.listen((event) {
        final data = event.data;

        dLog('📩 웹소켓 메세지 수신 : $data');
        if (data.runtimeType == String && data != 'ping') {
          try {
            final Map<String, dynamic> decodedData = jsonDecode(data);

            /// 수신된 key에 해당하는 이벤트 핸들러가 있으면 처리
            for (String key in decodedData.keys) {
              if (jsonEventHandlerMap.keys.contains(key)) {
                final eventHandler = jsonEventHandlerMap[key]!;
                eventHandler(decodedData[key]);
              }
            }
          } catch (e) {}
        }
      });

      _ws!.onError.listen((event) {
        _isConnected = false;
        print('❌ 웹소켓 오류 발생: $event');
        stopPing();
        // 웹소켓 오류는 이벤트 객체에서 직접적인 메시지를 제공하지 않을 수 있음.
        // 네트워크 콘솔에서 추가 디버깅 필요.
      });

      _ws!.onClose.listen((event) {
        print('🔌 웹소켓 연결 종료');
        stopPing();
        _isConnected = false;
      });
    } catch (e) {
      print('❌ 웹소켓 연결 실패 : $e');
      _isConnected = false;
    }
  }

  void disConnect() {
    _ws?.close();
    stopPing();
    _isConnected = false;
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

  void addJsonEventHandler(
    String key,
    void Function(dynamic data) onDataReceived,
  ) {
    jsonEventHandlerMap = {...jsonEventHandlerMap, key: onDataReceived};
    dLog('등록된 핸들러 키 : ${jsonEventHandlerMap.keys}');
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

  void stopStream(String roomId) {
    sendStringMessage('/realtime/stop/$roomId');
  }

  void requestTodayData(String roomId) {
    sendStringMessage('/today/$roomId');
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