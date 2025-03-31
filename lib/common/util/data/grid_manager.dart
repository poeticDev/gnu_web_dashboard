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
    return TrinaRow(
      cells: {
        'key': TrinaCell(value: mediaItem.key),
        'title': TrinaCell(value: mediaItem.title),
        'type': TrinaCell(value: mediaItem.type.label),
        'url': TrinaCell(value: mediaItem.url),
        'fileName': TrinaCell(value: mediaItem.fileName),
        'from': TrinaCell(value: mediaItem.from.label),
        'fit': TrinaCell(value: mediaItem.fit.label),
        'orderNum': TrinaCell(value: mediaItem.orderNum),
        'lastUpdated': TrinaCell(value: mediaItem.lastUpdated),
      },
    );
  }
}
