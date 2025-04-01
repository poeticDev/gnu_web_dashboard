import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/component/splash_circle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/data/message_controller.dart';
import 'package:gnu_web_dashboard/common/util/data/model/trina_columns.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:gnu_web_dashboard/common/util/data/grid_manager.dart';
import 'package:uuid/v4.dart';

class MessageGrid extends ConsumerStatefulWidget {
  final String roomId;

  const MessageGrid({required this.roomId, super.key});

  @override
  ConsumerState<MessageGrid> createState() => _MessageGridState();
}

class _MessageGridState extends ConsumerState<MessageGrid> {
  final GridManager gridManager = GridManager();
  late TrinaGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    final messageNotifier = ref.read(messageControllerProvider.notifier);

    return FutureBuilder(
      future: messageNotifier.requestMessageItemList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SplashCircle();
        }

        final List<TrinaRow> messageItemRows =
            messageNotifier
                .getSingleRoomMessageList(widget.roomId)
                .map((e) => gridManager.getRowFromMessageModel(e))
                .toList();

        // gridKey 강제할당하여, riverpod state가 변할 때마다 TrinaGrid 재생성
        Key gridKey = ValueKey(UuidV4());

        return TrinaGrid(
            key: gridKey,
            columns: messageColumns, rows: messageItemRows,
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

            await messageNotifier.handleFieldChange(
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
