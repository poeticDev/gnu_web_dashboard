import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:go_router/go_router.dart';

class RoomTab extends StatelessWidget {
  final double height;
  final double fontSize;

  const RoomTab({
    super.key,
    required this.height,
    this.fontSize = 24,
  });

  static const double borderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: () {
        // context.go('/fixedName');
        dLog('탭 정보 입력하기');
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
              ]),
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
                    '000동 0000호',
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
