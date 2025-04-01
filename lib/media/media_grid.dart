import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/component/splash_circle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/data/grid_manager.dart';
import 'package:gnu_web_dashboard/common/util/data/media_controller.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:uuid/v4.dart';

import '../common/util/data/model/trina_columns.dart';

class MediaGrid extends ConsumerStatefulWidget {
  final String roomId;

  MediaGrid({required this.roomId, super.key});

  @override
  ConsumerState<MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends ConsumerState<MediaGrid> {
  final GridManager gridManager = GridManager();
  late TrinaGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    /// watcher는 나중에 상위 위젯으로 올리기로?
    // final mediaWatcher = ref.watch(mediaControllerProvider);
    final mediaNotifier = ref.read(mediaControllerProvider.notifier);

    return FutureBuilder(
      future: mediaNotifier.requestMediaItemList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SplashCircle();
        }

        final List<TrinaRow> mediaItemRows =
            mediaNotifier
                .getSingleRoomMediaList(widget.roomId)
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
          onChanged: (event) async {
            final key = event.row.cells['key']!.value;
            final field = event.column.field;
            final value = event.value;

            await mediaNotifier.handleFieldChange(
              key: key,
              field: field,
              value: value,
            );
          },
        );
      },
    );
  }
}