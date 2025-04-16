import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/state/util/state_manager.dart';

class RoomTab extends ConsumerWidget {
  final Room roomData;
  final double height;
  final double fontSize;

  const RoomTab({
    super.key,
    required this.roomData,
    required this.height,
    this.fontSize = 24,
  });

  static const double borderRadius = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: () {
        ref.read(stateManagerProvider.notifier).replaceRoomId(roomData.roomId);
        // context.go('/fixedName');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: PRIMARY_CONTAINER_COLOR,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(borderRadius),
              topLeft: Radius.circular(borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.onInverseSurface,
                offset: Offset(2, 2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: colors.shadow,
                offset: Offset(-2, -2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Row(
                children: [
                  Container(
                    width: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightGreen,
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    roomData.roomName,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
