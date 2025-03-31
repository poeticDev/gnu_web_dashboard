import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:trina_grid/trina_grid.dart';

final List<TrinaColumn> mediaItemColumns = [
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
    type: TrinaColumnType.number(negative: false,),
    width: 120,
  ),

  TrinaColumn(
    title: '최종 수정일',
    field: 'lastUpdated',
    type: TrinaColumnType.date(
      format: 'yy.MM.dd  hh시 mm분'
    ),
    width: 150,
    enableEditingMode: false,
    readOnly: true,
  ),
];
