import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/device.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';

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
      // 전체 화면 크기 가져오기
      final mWidth = constraints.maxWidth - globalPadding * 2;
      final mHeight = constraints.maxHeight - globalPadding * 2;

      return Padding(
        padding: const EdgeInsets.all(globalPadding),
        child: SizedBox(
          width: mWidth,
          height: mHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _RenderLeftBox(),
              ),
              SizedBox(width: 40),
              Expanded(
                child: _RenderRightBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _RenderLeftBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // width: 800,
          height: 450,
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
                style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: PRIMARY_CONTAINER_COLOR,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                '키오스크/태블릿 관리',
                style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _RenderRightBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                color: PRIMARY_CONTAINER_COLOR,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: DIVIDER_COLOR,
                  ),
                  Center(
                    child: Text(
                      '강의실 상태',
                      style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize * 0.85),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              decoration: BoxDecoration(
                color: PRIMARY_CONTAINER_COLOR,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All On/Off',
                          style: TextStyle(
                              color: WHITE_TEXT_COLOR, fontSize: fontSize),
                        ),
                        Text(
                          '토글',
                          style: TextStyle(
                              color: WHITE_TEXT_COLOR, fontSize: fontSize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
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
                '온도 21.2도\n습도 50%',
                style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
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
                  style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
