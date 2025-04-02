import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gnu_web_dashboard/common/util/data/model/message_model.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/network/http_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_controller.g.dart';

@Riverpod(keepAlive: true)
class MessageController extends _$MessageController {
  static String _serverHttpApiIp = 'https://192.168.219.137/api/v1/';

  final HttpManager _http = HttpManager();

  Map<String, Message> get _initialState => {};

  @override
  Map<String, Message> build() {
    return _initialState;
  }

  /// 현재 등록된 메세지 목록
  List<Message> getSingleRoomMessageList(String roomId) {
    final List<Message> messageList =
        state.values.where((e) => e.roomId.contains(roomId)).toList();

    return messageList;
  }

  /// 현재 상태에 반영
  void updateSingleState(Message message) {
    state = {...state, message.key: message};
  }

  /// -> 서버 : 목록 요청
  Future<void> requestMessageItemList({bool expired = false}) async {
    final expiredMap = {"expired": expired};

    Response? response;

    try {
      response = await _http.post(
        path: '/read',
        queryParameters: {"type": "messageData"},
        data: expiredMap,
        options: Options(contentType: Headers.jsonContentType),
      );

      dLog('메세지 목록 alive res: $response');
    } catch (e) {
      eLog('메세지 목록 요청 실패: $e');
    }

    try {
      iLog('response: $response');
      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Message> decodedData =
            data
                .map((e) => Message.fromMap(e as Map<String, dynamic>))
                .toList();


        state = _initialState;

        for (Message message in decodedData) {
          updateSingleState(message);
        }

        return;
      } else {
        eLog('메세지 목록 응답 불량: ${response?.statusCode ?? '응답 없음'}');
      }
    } catch (e) {
      eLog('메세지 목록 갱신 실패: $e');
    }
  }

  /// -> 서버 : 업서트
  Future<int> upsertSingleMessageToServer({required Message message}) async {
    Response? response;
    late final String jsonData;

    final messageItemMap = message.getMessageMap();
    final dataMap = {
      "messageData": [messageItemMap],
    };

    try {
      jsonData = jsonEncode(dataMap);
    } catch (e) {
      eLog('메세지 json 변환 실패 : $e');
      return 1;
    }

    try {
      response = await _http.post(
        path: '$_serverHttpApiIp/edit',
        queryParameters: {"type": "messageData"},
        data: jsonData,
      );

      if (response?.statusCode != 200)
        throw Exception(
          'res status: ${response?.statusCode} | statusMessage: ${response?.statusMessage}',
        );

      dLog('메세지 upsert res: $response');
    } catch (e) {
      eLog('메세지 upsert http 요청 실패 : $e');
      return 1;
    }

    if (response != null && response.statusCode == 200) {
      updateSingleState(message);
      return 0;
    } else {
      iLog('메세지 upsert 성공, but 상태 반영 실패');
    }

    return 1;
  }

  /// 메세지 필드가 수정됐을 때 호출
  Future<void> handleFieldChange({
    required String key,
    required String field,
    required dynamic value,
  }) async {
    /// 1. key로 메세지 데이터 불러오기
    Map<String, dynamic> messageMap = state[key]!.getMessageMap();
    dLog('1. 기존 메세지 맵 불러오기 : $messageMap');

    /// 2. 불러온 메세지 데이터의 field와 value 수정
    switch (field) {
      case 'until':
        iLog('until: $value');
        messageMap[field] = value.toString();
        break;
      case 'type':
        messageMap[field] = messageTypeFromLabel(value).name;
        break;
      default:
        messageMap[field] = value;
    }

    messageMap['lastUpdated'] = DateTime.now().toString();

    dLog('2. 메세지 맵 수정 : $messageMap');

    /// 3. 수정된 메세지 데이터 전송 + 4. 응답 수신 후, state 반영
    final updated = Message.fromMap(messageMap);
    final result = await upsertSingleMessageToServer(message: updated);
    dLog('3. 메세지 맵 전송 : $result');

    /// 업데이트 실패 시, 현재 목록을 서버로부터 다시 받아와 복구
    if (result != 0) {
      dLog('메세지 목록 갱신 요청');
      await requestMessageItemList();
    }
  }
}
