import 'dart:html';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/device.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/media/media_add_dialog.dart';
import 'package:gnu_web_dashboard/media/media_grid.dart';
import 'package:gnu_web_dashboard/message/message_add_dialog.dart';
import 'package:gnu_web_dashboard/message/message_grid.dart';
import 'package:gnu_web_dashboard/state/component/custom_line_chart.dart';
import 'package:gnu_web_dashboard/state/component/state_row.dart';
import 'package:gnu_web_dashboard/test/test_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';

class StateView extends ConsumerStatefulWidget {
  final String roomId;

  const StateView({required this.roomId, super.key});

  @override
  ConsumerState<StateView> createState() => _StateViewState();
}

class _StateViewState extends ConsumerState<StateView> {
  late Future mediaItemList;
  double fontSize = 24;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentDevice != Device.DESKTOP) {
      fontSize = 16;
    } else {
      fontSize = 22;
    }

    final colors = AppColors.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double globalPadding = 20;
        const double betweenPadding = 60;
        // 전체 화면 크기 가져오기
        final double mWidth = constraints.maxWidth - globalPadding * 2;
        final double mHeight = constraints.maxHeight - globalPadding * 2;

        // Desktop 기준 minWidth
        final double cameraBoxMinWidth = 520;
        final double mediaBoxMinWidth = 520;
        final double stateBoxMinWidth = 520;

        final double stateBoxWidth = 520;
        final double mediaBoxWidth = 520;
        final double cameraBoxWidth =
            mWidth - stateBoxWidth - mediaBoxWidth - betweenPadding * 2;

        return Padding(
          padding: const EdgeInsets.all(globalPadding),
          child: SizedBox(
            width: mWidth,
            height: mHeight,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: betweenPadding,
                runSpacing: betweenPadding,
                children: [
                  _RenderCameraBox(
                    width: cameraBoxWidth,
                    height: mHeight,
                    minWidth: cameraBoxMinWidth,
                  ),
                  _RenderStateBox(
                    width: stateBoxWidth,
                    height: mHeight,
                    minWidth: stateBoxMinWidth,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: betweenPadding,
                    runSpacing: betweenPadding,
                    children: [
                      _RenderMessageBox(
                        width: mediaBoxWidth,
                        minWidth: mediaBoxMinWidth,
                      ),
                      _RenderMediaBox(
                        width: mediaBoxWidth,
                        minWidth: mediaBoxMinWidth,
                      ),
                    ],
                  ),

                  TestWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _RenderCameraBox({
    required double width,
    required double height,
    required double minWidth,
  }) {
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: 600, minWidth: minWidth),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: PRIMARY_CONTAINER_COLOR,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              '클릭하여 강의실 카메라 보기\n(30초)',
              textAlign: TextAlign.center,
              style: TERTIARY_TITLE_TEXT_STYLE.copyWith(
                fontSize: fontSize * 1,
                color: WHITE_TEXT_COLOR,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _RenderStateBox({
    required double width,
    required double height,
    required double minWidth,
  }) {
    const double verticalPadding = 20;

    final double stateRowWidth = width / 2.3;

    final double weatherHeight = 120;

    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: PRIMARY_CONTAINER_COLOR,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 16),
                      Text(
                        '강의실 상태',
                        style: TERTIARY_TITLE_TEXT_STYLE.copyWith(
                          color: WHITE_TEXT_COLOR,
                          fontSize: fontSize * 0.85,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child:
                        // LoadingIndicator(
                        //   indicatorType: Indicator.circleStrokeSpin,
                        //   colors: [Colors.orangeAccent, Colors.yellowAccent],
                        // ),
                        LoadingIndicator(
                          indicatorType: Indicator.ballClipRotatePulse,
                          colors: const [Colors.yellow, Colors.green],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: DIVIDER_COLOR, height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          StateRow(
                            width: stateRowWidth,
                            height: fontSize * 1.6,
                            title: 'All On/Off',
                          ),
                          StateRow(
                            width: stateRowWidth,
                            height: fontSize * 1.6,
                            title: '조명',
                          ),
                          StateRow(
                            width: stateRowWidth,
                            height: fontSize * 1.6,
                            title: '냉난방기',
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          StateRow(
                            width: stateRowWidth,
                            height: fontSize * 1.6,
                            title: '교수 PC',
                          ),
                          StateRow(
                            width: stateRowWidth,
                            height: fontSize * 1.6,
                            title: 'PBL 스크린',
                          ),
                          StateRow(
                            width: stateRowWidth,
                            height: fontSize * 1.6,
                            title: '학생 PC',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: verticalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: weatherHeight,
                decoration: BoxDecoration(
                  color: PRIMARY_CONTAINER_COLOR,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '현재 온도',
                        style: TextStyle(
                          color: WHITE_TEXT_COLOR,
                          fontSize: fontSize * 0.85,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Divider(color: DIVIDER_COLOR, height: 10),
                      ),
                      Text(
                        '21°C',
                        style: TextStyle(
                          color: WHITE_TEXT_COLOR,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Container(
                  height: weatherHeight,
                  decoration: BoxDecoration(
                    color: PRIMARY_CONTAINER_COLOR,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: CustomLineChart(
                    yName: '°C',
                    minX: 8,
                    maxX: 20,
                    minY: 0,
                    maxY: 38,
                    spots: [
                      FlSpot(8, 16.44),
                      FlSpot(9, 12),
                      FlSpot(10, 15),
                      FlSpot(11, 4),
                      FlSpot(12, 20),
                      FlSpot(13, 25.44),
                      FlSpot(14, 22.44),
                      FlSpot(16, 18.44),
                      FlSpot(18, 37),
                      FlSpot(19, 24),
                      FlSpot(20, 10.44),
                    ],
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: verticalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: weatherHeight,
                decoration: BoxDecoration(
                  color: PRIMARY_CONTAINER_COLOR,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Text(
                          '현재 습도',
                          style: TERTIARY_TITLE_TEXT_STYLE.copyWith(
                            color: WHITE_TEXT_COLOR,
                            fontSize: fontSize * 0.85,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Divider(color: DIVIDER_COLOR, height: 10),
                      ),
                      Text(
                        '48%',
                        style: TextStyle(
                          color: WHITE_TEXT_COLOR,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Container(
                  height: weatherHeight,
                  decoration: BoxDecoration(
                    color: PRIMARY_CONTAINER_COLOR,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: CustomLineChart(
                    yName: '%',
                    minX: 8,
                    maxX: 20,
                    minY: 0,
                    maxY: 100,
                    horizontalInterval: 25,
                    gradientColors: [
                      Colors.yellow,
                      Colors.lightBlue,
                      Colors.lightBlue,
                      Colors.indigo,
                    ],
                    spots: [
                      FlSpot(8, 10),
                      FlSpot(9, 30),
                      FlSpot(10, 40),
                      FlSpot(11, 50),
                      FlSpot(12, 35),
                      FlSpot(13, 40),
                      FlSpot(14, 70),
                      FlSpot(16, 100),
                      FlSpot(18, 100),
                      FlSpot(19, 80),
                      FlSpot(20, 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _RenderMessageBox({required double width, required double minWidth}) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: PRIMARY_CONTAINER_COLOR,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async{
                      await showDialog(
                      context: context,
                      builder: (context) {
                        final width = MediaQuery.of(context).size.width * 0.9;
                        final height = MediaQuery.of(context).size.height * 0.5;

                        return MessageAddDialog(
                          width: width,
                          height: height,
                          ref: ref,
                        );
                      },
                      );
                      setState(() {});

                    },
                    icon: Icon(Icons.add),
                    iconSize: fontSize * 0.7,
                  ),
                  Text(
                    '메세지 관리',
                    style: TextStyle(
                      color: WHITE_TEXT_COLOR,
                      fontSize: fontSize * 0.85,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final width = MediaQuery.of(context).size.width * 0.9;
                          final height = MediaQuery.of(context).size.height * 0.5;
                          return Dialog(
                            backgroundColor: BG_COLOR,
                            child: Container(
                              height: height,
                              width: width,
                              constraints: BoxConstraints(
                                minWidth: 400
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: Text(
                                        '메세지 관리',
                                        style: TextStyle(
                                          color: WHITE_TEXT_COLOR,
                                          fontSize: fontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Divider(
                                      color: DIVIDER_COLOR,
                                      height: 10,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MessageGrid(roomId: widget.roomId),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                    },
                    icon: Icon(Icons.photo_size_select_small),
                    iconSize: fontSize * 0.7,
                  ),
                ],
              ),
              SizedBox(
                // width: 100,
                child: Divider(color: DIVIDER_COLOR, height: 10),
              ),
              SizedBox(height: 300, child: MessageGrid(roomId: widget.roomId)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _RenderMediaBox({required double width, required double minWidth}) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      width: width,
      decoration: BoxDecoration(
        color: PRIMARY_CONTAINER_COLOR,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        final width = MediaQuery.of(context).size.width * 0.9;
                        final height = MediaQuery.of(context).size.height * 0.5;

                        return MediaAddDialog(
                          width: width,
                          height: height,
                          ref: ref,
                        );
                      },
                    );
                    setState(() {});
                  },
                  icon: Icon(Icons.add),
                  iconSize: fontSize * 0.7,
                ),
                Text(
                  '미디어 관리',
                  style: TextStyle(
                    color: WHITE_TEXT_COLOR,
                    fontSize: fontSize * 0.85,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.photo_size_select_small),
                  iconSize: fontSize * 0.7,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final width = MediaQuery.of(context).size.width * 0.9;
                        final height = MediaQuery.of(context).size.height * 0.5;
                        return Dialog(
                          backgroundColor: BG_COLOR,
                          child: Container(
                            height: height,
                            width: width,
                            constraints: BoxConstraints(
                                minWidth: 400
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: Text(
                                      '미디어 관리',
                                      style: TextStyle(
                                        color: WHITE_TEXT_COLOR,
                                        fontSize: fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Divider(
                                    color: DIVIDER_COLOR,
                                    height: 10,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MediaGrid(roomId: widget.roomId),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              // width: 100,
              child: Divider(color: DIVIDER_COLOR, height: 10),
            ),
            SizedBox(height: 300, child: MediaGrid(roomId: widget.roomId)),
          ],
        ),
      ),
    );
  }
}
