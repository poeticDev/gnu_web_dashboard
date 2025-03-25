import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class StateManager {
  static bool _isConnected = false;
  Map<String, bool> initialState = {

  };


  @override
  dynamic build() {
    dLog('StateManager Build!');
    dLog('StateManager 빌드 시, MQTT로 현재 상태 받아오는 메서드 필요');

    try {
      _isConnected = true;
    } catch (e) {
      eLog('스테이트 매니저 빌드 실패 :\n$e');
    }
  }
}
