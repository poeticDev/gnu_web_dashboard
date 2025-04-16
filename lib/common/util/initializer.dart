import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';
import 'package:gnu_web_dashboard/state/util/state_manager.dart';

class AppInitializer {
  static bool _isInitialized = false;

  /// 싱글턴 패턴
  static final AppInitializer _instance = AppInitializer._internal();

  factory AppInitializer() => _instance;

  AppInitializer._internal();

  static bool getInitializedStatus() {
    return _isInitialized;
  }

  static String state = '';

  static Stream<String> initialize(WidgetRef ref) async* {
    if (_isInitialized) {
      yield 'done';
      return;
    }

    /// 1. 네트워크 세팅
    /// 1.1 웹소켓 연결
    yield '서버 연결 중';
    await _initWs(ref);

    _isInitialized = true;
    return;
  }

  /// 1.1 웹소켓 연결
  static Future<void> _initWs(WidgetRef ref) async {
    final WsManager ws = WsManager();
    ws.addJsonEventHandler(
      'latestSensorData',
      ref.read(stateManagerProvider.notifier).stateDataHandler,
    );
    await ws.connectWS(serverIp: serverIp);
  }
}
