import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:gnu_web_dashboard/common/util/data/grid_manager.dart';

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
    return const Placeholder();
  }
}
