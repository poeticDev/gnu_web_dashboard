import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/state/util/room_selector.dart';
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
    final List<String> selectedRoomList = ref.watch(roomSelectorProvider);
    bool isSelected = selectedRoomList.contains(roomData.roomId);

    return GestureDetector(
      onTap: () {
        ref.read(roomSelectorProvider.notifier).replaceRoomId(roomData.roomId);
        ref.read(stateManagerProvider.notifier).updatePeriodSpotMap();
        // context.go('/fixedName');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected
                    ? PRIMARY_CONTAINER_COLOR
                    : SECONDARY_CONTAINER_COLOR,
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
                spacing: 4,
                children: [
                  FaIcon(
                    roomData.roomName.contains('큐브')
                        ? FontAwesomeIcons.cube
                        : FontAwesomeIcons.battleNet,
                    size: fontSize,
                    color:
                        isSelected
                            ? colors.onSurface
                            : colors.onSecondaryContainer,
                  ),
                  // Container(
                  //   width: 16,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: Colors.lightGreen,
                  //     border: Border.all(color: Colors.grey),
                  //   ),
                  // ),
                  SizedBox(width: 4),
                  Text(
                    roomData.roomName,
                    style: TextStyle(
                      color:
                          isSelected
                              ? colors.onSurface
                              : colors.onSecondaryContainer,
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
