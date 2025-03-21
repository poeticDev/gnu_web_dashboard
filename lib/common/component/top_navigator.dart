import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/device.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';

class TopNavigator extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  TopNavigator({super.key, required this.height});

  double fontSize = 24;
  double containerWidth = 120;

  @override
  Widget build(BuildContext context) {
    // 나중에 initilizer나 어디로 넣자.
    final colors = AppColors.of(context);

    if (currentDevice != Device.DESKTOP) {
      fontSize = 16;
      containerWidth = 80;
    } else {
      fontSize = 24;
    }

    return AppBar(
      backgroundColor: colors.primary,
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: height,
      title: currentDevice == Device.DESKTOP
          ? _buildDesktopLayout(colors)
          : currentDevice == Device.TABLET
              ? _buildTabletLayout(colors)
              : _buildMobileLayout(colors),
    );
  }

  Widget _buildDesktopLayout(AppColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '{강의과목} {교수명}님 수업 중입니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: fontSize,
            ),
          ),
        ),
        _buildRoomButtons(colors, buttonCount: 3),
      ],
    );
  }

  Widget _buildRoomButtons(AppColors colors, {required int buttonCount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        buttonCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(16.0),
            ),
            height: height - 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  '강의실 ${index + 1}',
                  style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(AppColors colors) {
    return Center(
      child: Text(
        '강의 중',
        style: TextStyle(
          color: colors.onPrimary,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget _buildTabletLayout(AppColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '강의과목 교수명\n수업 중입니다.',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: fontSize,
          ),
        ),
        _buildRoomButtons(colors, buttonCount: 2),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
