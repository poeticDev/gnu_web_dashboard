import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/router.dart';
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
              color: colors.primaryContainer,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                topLeft: Radius.circular(borderRadius),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2, -2),
                  blurRadius: 8,
                  spreadRadius: 2,
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
                      color: colors.onSurface,
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
