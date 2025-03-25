import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/component/custom_toggle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/device.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/state/component/state_row.dart';

class StateView extends StatefulWidget {
  const StateView({super.key});

  @override
  State<StateView> createState() => _StateViewState();
}

class _StateViewState extends State<StateView> {
  double fontSize = 24;

  @override
  Widget build(BuildContext context) {
    if (currentDevice != Device.DESKTOP) {
      fontSize = 16;
    } else {
      fontSize = 24;
    }

    final colors = AppColors.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      const double globalPadding = 20;
      const double betweenPadding = 80;
      // 전체 화면 크기 가져오기
      final double mWidth = constraints.maxWidth - globalPadding * 2;
      final double mHeight = constraints.maxHeight - globalPadding * 2;
      final double rightBoxWidth = 520;
      final double leftBoxWidth = mWidth - rightBoxWidth - betweenPadding / 2;

      return Padding(
        padding: const EdgeInsets.all(globalPadding),
        child: SizedBox(
          width: mWidth,
          height: mHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RenderLeftBox(width: leftBoxWidth, height: mHeight),
              _RenderRightBox(width: rightBoxWidth, height: mHeight),
            ],
          ),
        ),
      );
    });
  }

  Widget _RenderLeftBox({
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(

                decoration: BoxDecoration(color: PRIMARY_CONTAINER_COLOR),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: PRIMARY_CONTAINER_COLOR,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '강의실 스케쥴',
                    style:
                        TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: PRIMARY_CONTAINER_COLOR,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '키오스크/태블릿 관리',
                    style:
                        TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _RenderRightBox({
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: PRIMARY_CONTAINER_COLOR,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '강의실 상태',
                        style: TERTIARY_TITLE_TEXT_STYLE.copyWith(
                          color: WHITE_TEXT_COLOR,
                          fontSize: fontSize * 0.85,
                        ),
                      ),
                    ),
                    Divider(
                      color: DIVIDER_COLOR,
                    ),
                    Column(
                      children: [
                        StateRow(
                          width: width,
                          height: fontSize * 1.6,
                          title: 'All On/Off',
                        ),
                        StateRow(
                          width: width,
                          height: fontSize * 1.6,
                          title: '조명',
                        ),
                        StateRow(
                          width: width,
                          height: fontSize * 1.6,
                          title: '냉난방기',
                        ),
                        StateRow(
                          width: width,
                          height: fontSize * 1.6,
                          title: '교수 PC',
                        ),
                        StateRow(
                          width: width,
                          height: fontSize * 1.6,
                          title: 'PBL 스크린',
                        ),
                        StateRow(
                          width: width,
                          height: fontSize * 1.6,
                          title: '학생 PC',
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: PRIMARY_CONTAINER_COLOR,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '온도 21.2도\n습도 50%',
                    style:
                        TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: PRIMARY_CONTAINER_COLOR,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '온도습도\n그래프',
                      style: TextStyle(
                          color: WHITE_TEXT_COLOR, fontSize: fontSize),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
