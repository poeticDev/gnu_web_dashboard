import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/common/util/data/model/message_model.dart';
import 'package:trina_grid/trina_grid.dart';

import 'weekday.dart';

final List<TrinaColumn> mediaItemColumns = [
  TrinaColumn(
    title: 'key',
    field: 'key',
    type: TrinaColumnType.text(),
    hide: true,
  ),

  TrinaColumn(
    title: 'roomId',
    field: 'roomId',
    type: TrinaColumnType.text(),
    hide: true,
  ),

  TrinaColumn(title: '미디어 이름', field: 'title', type: TrinaColumnType.text()),

  TrinaColumn(
    title: '미디어 타입',
    field: 'type',
    type: TrinaColumnType.select([...MediaType.values.map((e) => e.label)]),
    width: 120,
    // suppressedAutoSize:
  ),

  TrinaColumn(
    title: 'URL',
    field: 'url',
    type: TrinaColumnType.text(),
    // width: 250,
  ),

  TrinaColumn(
    title: '파일명',
    field: 'fileName',
    type: TrinaColumnType.text(),
    width: 120,
  ),

  TrinaColumn(
    title: '저장 위치',
    field: 'from',
    type: TrinaColumnType.select([...MediaFrom.values.map((e) => e.label)]),
    width: 150,
  ),

  TrinaColumn(
    title: 'Fit',
    field: 'fit',
    type: TrinaColumnType.select(['채우기', '큰 폭에 맞춤']),
    width: 120,
  ),

  TrinaColumn(
    title: '표출 순서',
    field: 'orderNum',
    type: TrinaColumnType.number(negative: false),
    width: 120,
  ),

  TrinaColumn(
    title: '최종 수정일',
    field: 'lastUpdated',
    type: TrinaColumnType.date(format: 'yy.MM.dd  hh시 mm분'),
    width: 150,
    enableEditingMode: false,
    readOnly: true,
  ),

  TrinaColumn(
    title: '지울까요?',
    field: 'isDead',
    type: TrinaColumnType.boolean(),
    width: 150,
    // hide: true,
  ),
];

final List<TrinaColumn> messageColumns = [
  TrinaColumn(
    title: 'key',
    field: 'key',
    type: TrinaColumnType.text(),
    hide: true,
  ),

  TrinaColumn(
    title: 'roomId',
    field: 'roomId',
    type: TrinaColumnType.text(),
    hide: true,
  ),

  TrinaColumn(title: '메세지', field: 'content', type: TrinaColumnType.text()),
  TrinaColumn(
    title: '표출기간(-까지)',
    field: 'until',
    type: TrinaColumnType.dateTime(format: 'yy.MM.dd  hh시 mm분'),
    width: 180,
  ),
  TrinaColumn(
    title: '메세지 타입',
    field: 'type',
    type: TrinaColumnType.select([...MessageType.values.map((e) => e.label)]),
    width: 120,
    // suppressedAutoSize:
  ),

  TrinaColumn(
    title: '최종 수정일',
    field: 'lastUpdated',
    type: TrinaColumnType.date(format: 'yy.MM.dd  hh시 mm분'),
    width: 150,
    enableEditingMode: false,
    readOnly: true,
  ),
];

final List<TrinaColumn> lectureColumns = [
  TrinaColumn(title: 'id', field: 'id', type: TrinaColumnType.number(format: '###.#'), hide: false),
  TrinaColumn(
    title: '요일',
    field: 'weekday',
    type: TrinaColumnType.select(weekdays),
    width: 80,
  ),
  TrinaColumn(
    title: '시작시간',
    field: 'startAt',
    type: TrinaColumnType.time(),
    width: 120,
  ),
  TrinaColumn(
    title: '종료시간',
    field: 'endAt',
    type: TrinaColumnType.time(),
    width: 120,
  ),
];