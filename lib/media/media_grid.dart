import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/data/grid_manager.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/test/test_data.dart';
import 'package:trina_grid/trina_grid.dart';

import '../common/util/data/model/trina_columns.dart';

class MediaGrid extends StatelessWidget {
  MediaGrid({super.key});

  final GridManager gridManager = GridManager();
  late final TrinaGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    final List<TrinaRow> mediaItemRows =
        sampleMediaList
            .map((e) => gridManager.getRowFromMediaItemModel(e))
            .toList();

    return TrinaGrid(
      columns: mediaItemColumns,
      rows: mediaItemRows,
      onLoaded: (event) {
        stateManager = event.stateManager;
      },
      configuration: TrinaGridConfiguration(
        style: TrinaGridStyleConfig.dark(
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
      },
    );
  }
}
