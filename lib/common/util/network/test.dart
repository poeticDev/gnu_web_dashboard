
import 'dart:html';

WebSocket? ws;

void connectWS() {
  try {
    ws = WebSocket('wss://192.168.219.137/api/v1/ws/example');

    ws!.onOpen.listen((event) {
      print('✅ 웹소켓 연결 성공');
    });

    ws!.onMessage.listen((event) {
      print('📩 웹소켓 메세지 : ${event.data}');
    });

    ws!.onError.listen((event) {
      print('❌ 웹소켓 오류 발생: $event');
      // 웹소켓 오류는 이벤트 객체에서 직접적인 메시지를 제공하지 않을 수 있음.
      // 네트워크 콘솔에서 추가 디버깅 필요.
    });

    ws!.onClose.listen((event) {
      print('🔌 웹소켓 연결 종료');
    });
  } catch (e) {
    print('❌ 웹소켓 연결 실패 : $e');
  }
}