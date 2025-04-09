import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';

part 'state_manager.g.dart';

@Riverpod(keepAlive: true)
class StateManager extends _$StateManager {
  static bool _isConnected = false;
  WsManager ws = WsManager();

  Map<String, dynamic> initialState = {
    'currentRoomIdList': [initialRooms.first.roomId],
    'temperature': null,
    'humidity': null,
    'power': null,
    'profPc': null,
    'lights': null,
    'studentScreens': null,
    'airConditioner': null,
  };

  @override
  Map<String, dynamic> build() {
    dLog('StateManager Build!');

    dLog('StateManager 빌드 시, MQTT로 현재 상태 받아오는 메서드 필요');

    try {
      final List<String> currentRoomIdList = initialState['currentRoomIdList'];

      ws.requestStream(currentRoomIdList.first);
    } catch (e) {
      eLog('스테이트 매니저 빌드 실패 :\n$e');
    }

    return initialState;
  }

  /// 기존 구독 목록을 없애고, 새 구독 요청
  void replaceRooms({required List<String> roomIdList}) {
    final List<String> currentList = state['currentRoomIdList'];

    try {
      /// 모든 구독 해제
      for (String roomId in currentList) {
        ws.stopStream(roomId);
      }

      /// 새로운 구독 추가
      for (String roomId in roomIdList) {
        ws.requestStream(roomId);
      }

      state = {...state, 'currentRoomIdList': roomIdList};
    } catch (e) {
      eLog('구독 교체 실패 : $e');
    }
  }
}
