import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gnu_web_dashboard/state/util/room_selector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnu_web_dashboard/common/util/network/http_manager.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';

import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';

part 'state_manager.g.dart';

@Riverpod(keepAlive: true)
class StateManager extends _$StateManager {
  WsManager ws = WsManager();
  HttpManager _http = HttpManager();
  Timer? _timer;

  // final List<String> selectedRoom = [initialRooms.first.roomId];

  Map<String, dynamic> initialState = {
    // 'selectedRoom': [initialRooms.first.roomId],
    // 'roomId' : {
    //   'temperature': null,
    //   'humidity': null,
    //   'power': null,
    //   'profPc': null,
    //   'lights': null,
    //   'studentScreens': null,
    //   'airConditioner': null,
    // }
    'lastUpdated': null,
  };

  static Map<String, dynamic> _periodDataMap = {
    "roomId": [
      {"timestamp": "2025-04-15 00:00:11", "온도": null, "습도": null},
    ],
  };

  static Map<String, Map<String, List<FlSpot>>> _periodSpotMap = {
    "roomId": {"temperSpotList": [], "humidSpotList": []},
  };

  @override
  Map<String, dynamic> build() {
    // dLog('StateManager Build!');
    // try {
    //   final List<String> selectedRoom = initialState['selectedRoom'];
    // } catch (e) {
    //   eLog('스테이트 매니저 빌드 실패 :\n$e');
    // }
    _timer = Timer.periodic(Duration(minutes: 15), (timer) async {
      await getPeriodData();

      List<String> selectedRoomList = ref.read(roomSelectorProvider);

      for (String roomId in selectedRoomList) {
        Map<String, List<FlSpot>> spotMap = _getSpotFromState(roomId);

        _periodSpotMap = {..._periodSpotMap, roomId: spotMap};
      }
    });

    return initialState;
  }

  Future<void> updatePeriodSpotMap() async {
    await getPeriodData();

    List<String> selectedRoomList = ref.read(roomSelectorProvider);

    for (String roomId in selectedRoomList) {
      Map<String, List<FlSpot>> spotMap = _getSpotFromState(roomId);

      _periodSpotMap = {..._periodSpotMap, roomId: spotMap};
    }
  }

  // void replaceRoomId(String roomId) {
  //   _announceRoomList([roomId]);
  //   state = {
  //     ...state,
  //     'selectedRoom': [roomId],
  //   };
  // }
  //
  // void registerRoomId(String roomId) {
  //   final List<String> selectedRoomList = state['selectedRoom'];
  //   selectedRoomList.add(roomId);
  //
  //   _announceRoomList(selectedRoomList);
  //   state = {...state, 'selectedRoom': selectedRoomList};
  // }
  //
  // void deleteRoomId(String roomId) {
  //   final List<String> selectedRoomList = state['selectedRoom'];
  //   selectedRoomList.remove(roomId);
  //   _announceRoomList(selectedRoomList);
  //   state = {...state, 'selectedRoom': selectedRoomList};
  // }

  /// Post:
  Future toggleState(String stateName) async {
    final currentState = state[stateName];
    if (currentState == 'on') {
      state[stateName] = 'off';
    }
  }

  Future<void> getPeriodData() async {
    List<String> selectedRoomList = ref.read(roomSelectorProvider);

    final Response? response = await _http.post(
      path: '$serverHttpApiIp/read',
      queryParameters: {'type': 'sensorData'},
      data: {'selectedRoom': selectedRoomList},
    );

    dLog('getPeriodData res code: ${response?.statusCode}');
    dLog('getPeriodData res data: ${response?.data}');

    if (response?.data != null) {
      final Map<String, dynamic> dataMap = response!.data;

      for (String roomId in dataMap.keys) {
        _periodDataMap = {..._periodDataMap, roomId: dataMap[roomId]};
      }
    }
  }

  static double _getTimeDoubleFromTimestamp(String timestamp) {
    final DateTime? parsedTimestamp = DateTime.tryParse(timestamp);
    double timeDouble = 0.0;
    if (parsedTimestamp != null) {
      final int hour = parsedTimestamp.hour;
      final int min = parsedTimestamp.minute;

      timeDouble = hour + min / 60;
    }

    return timeDouble;
  }

  static Map<String, List<FlSpot>> _getSpotFromState(String roomId) {
    // Map<String, dynamic> periodDataMap = {
    //   "roomId": [
    //     {"timestamp": "2025-04-15 00:00:11", "온도": null, "습도": null},
    //   ],
    // };
    final List<dynamic> dataList = _periodDataMap[roomId];

    final List<Map<String, dynamic>> dataMapList =
        dataList.map((e) => e as Map<String, dynamic>).toList();

    final List<FlSpot> temperSpotList = [];
    final List<FlSpot> humidSpotList = [];

    for (Map<String, dynamic> dataMap in dataMapList) {
      final double time = _getTimeDoubleFromTimestamp(dataMap["timestamp"]);
      if (time > 8 && time < 20) {
        final double temperature = dataMap["온도"] ?? 0;
        final double humidity = dataMap["습도"] ?? 0;

        final FlSpot temperSpot = FlSpot(time, temperature);
        final FlSpot humidSpot = FlSpot(time, humidity);

        temperSpotList.add(temperSpot);
        humidSpotList.add(humidSpot);
      }
    }

    return {"temperSpotList": temperSpotList, "humidSpotList": humidSpotList};
  }

  Map<String, Map<String, List<FlSpot>>> getPeriodSpotMap() => _periodSpotMap;

  /// WS
  // Future<void> _announceRoomList(List<String> roomIdList) async {
  //   final map = {'selectedRoom': roomIdList};
  //   final message = jsonEncode(map);
  //   ws.sendStringMessage(message);
  // }

  // ws데이터 수신 시, roomId를 키로 stateData 등록
  void stateDataHandler(dynamic data) {
    try {
      final Map<String, dynamic> dataMap = data;

      // 해당 roomId의 현재 데이터를 등록
      for (String roomId in dataMap.keys) {
        dLog('$roomId 현재 데이터 등록!');
        final Map<String, dynamic> statesMap = dataMap[roomId]['states'];
        dLog('statesMap: $statesMap');
        state = {...state, roomId: statesMap, 'lastUpdated': DateTime.now()};
      }
    } catch (e) {
      eLog('stateDataHandler 실패 : $e');
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
