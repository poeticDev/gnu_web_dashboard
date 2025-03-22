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
      backgroundColor: colors.surface,
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 8,
      toolbarHeight: height,
      titleSpacing: 0,
      title: currentDevice == Device.DESKTOP
          ? _buildDesktopLayout(colors)
          : currentDevice == Device.TABLET
              ? _buildTabletLayout(colors)
              : _buildMobileLayout(colors),
    );
  }

  Widget _buildDesktopLayout(AppColors colors) {
    const double upperPadding = 12;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2, 2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: upperPadding,
          ),
          SizedBox(
            height: (height - upperPadding) / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRoomButtons(colors, buttonCount: 3),
                SizedBox(width: 600, child: _buildTabButtons()),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: (height - upperPadding) / 2,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
            ),
            child: Center(
              child: Text(
                '(아이콘?) (강의실명) | {강의명} {교수명}님 수업 중입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomButtons(AppColors colors, {required int buttonCount}) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(width: 40.0),
      ...List.generate(
        buttonCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
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
            height: height - 20,
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
                      '${currentDevice.name} ${index + 1}',
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
      ),
    ]);
  }

  Widget _buildTabButtons() {
    const double width = 600;

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      bool isExpanded = maxWidth > width;

      /// 주어진 너비가 충분하지 않으면 햄버거 버튼으로 바꾸기
      return SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('강의실 현황'),
            Text('메세지/미디어 관리'),
            Text('시간표 관리'),
          ],
        ),
      );
    });
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
