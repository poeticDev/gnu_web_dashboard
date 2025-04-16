import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gnu_web_dashboard/common/util/network/http_manager.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';

part 'state_manager.g.dart';

@Riverpod(keepAlive: true)
class StateManager extends _$StateManager {
  static bool _isConnected = false;
  WsManager ws = WsManager();
  HttpManager _http = HttpManager();

  Map<String, dynamic> initialState = {
    'selectedRoom': [initialRooms.first.roomId],
    'temperature': null,
    'humidity': null,
    'power': null,
    'profPc': null,
    'lights': null,
    'studentScreens': null,
    'airConditioner': null,
  };

  Map<String, dynamic> periodDataMap = {
    "roomId": [
      {"timestamp": "2025-04-15 00:00:11", "온도": null, "습도": null},
    ],
  };

  @override
  Map<String, dynamic> build() {
    // dLog('StateManager Build!');
    // try {
    //   final List<String> selectedRoom = initialState['selectedRoom'];
    // } catch (e) {
    //   eLog('스테이트 매니저 빌드 실패 :\n$e');
    // }

    return initialState;
  }

  void replaceRoomId(String roomId) {
    _announceRoomList([roomId]);
    state = {
      ...state,
      'selectedRoom': [roomId],
    };
  }

  void registerRoomId(String roomId) {
    final List<String> selectedRoomList = state['selectedRoom'];
    selectedRoomList.add(roomId);

    _announceRoomList(selectedRoomList);
    state = {...state, 'selectedRoom': selectedRoomList};
  }

  void deleteRoomId(String roomId) {
    final List<String> selectedRoomList = state['selectedRoom'];
    selectedRoomList.remove(roomId);
    _announceRoomList(selectedRoomList);
    state = {...state, 'selectedRoom': selectedRoomList};
  }

  /// Post:
  Future toggleState(String stateName) async {
    final currentState = state[stateName];
    if (currentState == 'on') {
      state[stateName] = 'off';
    }
  }

  Future<void> getPeriodData({required String roomId}) async {
    final Response? response = await _http.post(
      path: '$serverHttpApiIp/read',
      queryParameters: {'type': 'sensorData'},
      data: {'selectedRoom': state['selectedRoom']},
    );

    dLog('getPeriodData res code: ${response?.statusCode}');
    dLog('getPeriodData res data: ${response?.data}');

    if (response?.data != null) {
      final Map<String, dynamic> dataMap = response!.data;

      for (String roomId in dataMap.keys) {
        periodDataMap = {...periodDataMap, roomId: dataMap[roomId]};
      }
    }
  }

  /// WS
  Future<void> _announceRoomList(List<String> roomIdList) async {
    final map = {'selectedRoom': roomIdList};
    final message = jsonEncode(map);
    ws.sendStringMessage(message);
  }

  // ws데이터 수신 시, roomId를 키로 stateData 등록
  void stateDataHandler(dynamic data) {
    final Map<String, dynamic> dataMap = data;

    // 해당 roomId의 현재 데이터를 등록
    for (String roomId in dataMap.keys) {
      state = {...state, roomId: dataMap[roomId]};
    }
  }

  /// 기존 구독 목록을 없애고, 새 구독 요청
  // void replaceRooms({required List<String> roomIdList}) {
  //   final List<String> currentList = state['currentRoomIdList'];
  //
  //   try {
  //     /// 모든 구독 해제
  //     for (String roomId in currentList) {
  //       ws.stopStream(roomId);
  //     }
  //
  //     /// 새로운 구독 추가
  //     for (String roomId in roomIdList) {
  //       ws.requestStream(roomId);
  //     }
  //
  //     state = {...state, 'currentRoomIdList': roomIdList};
  //   } catch (e) {
  //     eLog('구독 교체 실패 : $e');
  //   }
  // }
}
