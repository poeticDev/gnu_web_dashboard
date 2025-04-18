import 'dart:convert';

import 'package:gnu_web_dashboard/common/util/data/model/weekday.dart';
import 'package:gnu_web_dashboard/common/util/data/model/lecture.dart';
import 'package:gnu_web_dashboard/common/util/data/model/message_model.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:trina_grid/trina_grid.dart';

import 'model/media_item_model.dart';

class GridManager {
  // 싱글톤
  // static final GridManager _instance = GridManager._internal();
  //
  // GridManager._internal();
  //
  // factory GridManager() {
  //   return _instance;
  // }

  GridManager();

  TrinaRow getRowFromMediaItemModel(MediaItem mediaItem) {
    final String parsedRoomId = jsonEncode(mediaItem.roomId);

    return TrinaRow(
      cells: {
        'key': TrinaCell(value: mediaItem.key),
        'roomId': TrinaCell(value: parsedRoomId),
        'title': TrinaCell(value: mediaItem.title),
        'type': TrinaCell(value: mediaItem.type.label),
        'url': TrinaCell(value: mediaItem.url),
        'fileName': TrinaCell(value: mediaItem.fileName),
        'from': TrinaCell(value: mediaItem.from.label),
        'fit': TrinaCell(value: mediaItem.fit.label),
        'orderNum': TrinaCell(value: mediaItem.orderNum),
        'lastUpdated': TrinaCell(value: mediaItem.lastUpdated),
        'isDead': TrinaCell(value: mediaItem.isDead),
      },
    );
  }

  TrinaRow getRowFromMessageModel(Message message) {
    final String parsedRoomId = jsonEncode(message.roomId);

    return TrinaRow(
      cells: {
        'key': TrinaCell(value: message.key),
        'roomId': TrinaCell(value: parsedRoomId),
        'content': TrinaCell(value: message.content),
        'until': TrinaCell(value: message.until),
        'type': TrinaCell(value: message.type.label),
        'lastUpdated': TrinaCell(value: message.lastUpdated),
      },
    );
  }

  TrinaRow getRowFromLectureModel(Lecture lecture) {
    iLog('id:${lecture.id}');
    iLog('weekday:${getWeekdayInKR(lecture.weekday)}');
    iLog('startAt:${lecture.startAt.hour}:${lecture.startAt.minute}');
    iLog('endAt:${lecture.endAt.hour}:${lecture.endAt.minute}');

    return TrinaRow(cells: {
      'id': TrinaCell(value: lecture.id),
      'weekday': TrinaCell(value: getWeekdayInKR(lecture.weekday)),
      'startAt': TrinaCell(value: '${lecture.startAt.hour.toString().padLeft(2,'0')}:${lecture.startAt.minute.toString().padLeft(2,'0')}'),
      'endAt': TrinaCell(value: '${lecture.endAt.hour.toString().padLeft(2,'0')}:${lecture.endAt.minute.toString().padLeft(2,'0')}'),
    });

  }
}
