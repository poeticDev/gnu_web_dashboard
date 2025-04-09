import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/component/room_tab.dart';
import 'package:gnu_web_dashboard/common/const/device.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';
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
    // final colors = AppColors.of(context);

    if (currentDevice != Device.DESKTOP) {
      fontSize = 16;
      containerWidth = 80;
    } else {
      fontSize = 24;
    }

    return AppBar(
      backgroundColor: BG_COLOR,
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 8,
      toolbarHeight: height,
      titleSpacing: 0,
      title:
          currentDevice == Device.DESKTOP
              ? _buildDesktopLayout()
              : currentDevice == Device.TABLET
              ? _buildTabletLayout()
              : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    const double upperPadding = 12;
    return Container(
      decoration: BoxDecoration(
        color: BG_COLOR,
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
          SizedBox(height: upperPadding),
          SizedBox(
            height: (height - upperPadding) / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildRoomButtons(roomList: initialRooms)],
            ),
          ),
          Container(
            width: double.infinity,
            height: (height - upperPadding) / 2,
            decoration: BoxDecoration(color: PRIMARY_CONTAINER_COLOR),
            child: Center(
              child: Text(
                '(아이콘?) (강의실명) | {시작 시간} ~ {종료시간} {강의명} {교수명}님 수업 중입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomButtons({required List<Room> roomList}) {
    /// 주어진 너비가 충분하지 않으면 햄버거 버튼으로 바꾸기
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 왼쪽 여백
        SizedBox(width: 40.0),
        ...roomList.map((room) => RoomTab(roomData: room, height: height - 20)),
      ],
    );
  }

  Widget _buildTabButtons() {
    const double width = 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        bool isExpanded = maxWidth > width;

        /// 주어진 너비가 충분하지 않으면 햄버거 버튼으로 바꾸기
        return SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text('강의실 현황'), Text('메세지/미디어 관리'), Text('시간표 관리')],
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Center(
      child: Text(
        '강의 중',
        style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '강의과목 교수명\n수업 중입니다.',
          textAlign: TextAlign.start,
          style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
        ),
        // _buildRoomButtons(colors, buttonCount: 2),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
