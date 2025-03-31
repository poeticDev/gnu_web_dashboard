import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/data/grid_manager.dart';
import 'package:gnu_web_dashboard/common/util/data/media_controller.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/test/test_data.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:uuid/v4.dart';

import '../common/util/data/model/trina_columns.dart';

class MediaGrid extends ConsumerWidget {
  final String roomId;

  MediaGrid({required this.roomId, super.key});


  final GridManager gridManager = GridManager();
  late final TrinaGridStateManager stateManager;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// watcher는 나중에 상위 위젯으로 올리기로?
    final mediaWatcher = ref.watch(mediaControllerProvider);
    final mediaNotifier = ref.read(mediaControllerProvider.notifier);


    final List<TrinaRow> mediaItemRows =
        mediaNotifier
            .getSingleRoomMediaList(roomId)
            .map((e) => gridManager.getRowFromMediaItemModel(e))
            .toList();

    // gridKey 강제할당하여, riverpod state가 변할 때마다 TrinaGrid 재생성
    Key gridKey = ValueKey(UuidV4());

    return TrinaGrid(
      key: gridKey,
      columns: mediaItemColumns,
      rows: mediaItemRows,
      onLoaded: (event) {
        stateManager = event.stateManager;
      },
      configuration: TrinaGridConfiguration(
        style: TrinaGridStyleConfig.dark(
          rowColor: BG_COLOR,
          gridBackgroundColor: GRID_BG_COLOR,
          borderColor: Colors.grey,
          oddRowColor: BG_COLOR,
          evenRowColor: GRID_BG_COLOR,
          iconColor: GRID_ICON_COLOR,
        ),
        scrollbar: TrinaGridScrollbarConfig(isAlwaysShown: true),
      ),
      onChanged: (event) {
        final key = event.row.cells['key']!.value;
        final field = event.column.field;
        final value = event.value;
        dLog('key: $key | field: $field | value: $value');

        /// 1. key로 미디어 데이터 불러오기
        /// 2. 불러온 미디어 데이터의 field와 value 수정
        /// 3. 수정된 미디어 데이터 전송
        /// 4. 응답 수신 후, state 반영
      },
    );
  }
}
