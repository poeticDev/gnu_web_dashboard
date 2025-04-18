import 'dart:convert';

import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';
import 'package:gnu_web_dashboard/common/util/network/ws_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_selector.g.dart';

@Riverpod(keepAlive: true)
class RoomSelector extends _$RoomSelector {
  List<String> initialRoomId = [initialRooms.first.roomId];
  WsManager ws = WsManager();

  List<String> build() {

    return initialRoomId;
  }


  void replaceRoomId(String roomId) {
    _announceRoomList([roomId]);
    state = [roomId];
  }

  void registerRoomId(String roomId) {
    final List<String> selectedRoomList = state;
    selectedRoomList.add(roomId);

    _announceRoomList(selectedRoomList);
    state = selectedRoomList;
  }

  void deleteRoomId(String roomId) {
    final List<String> selectedRoomList = state;
    selectedRoomList.remove(roomId);
    _announceRoomList(selectedRoomList);
    state = selectedRoomList;
  }


  Future<void> _announceRoomList(List<String> roomIdList) async {
    final map = {'selectedRoom': roomIdList};
    final message = jsonEncode(map);
    ws.sendStringMessage(message);
  }
}