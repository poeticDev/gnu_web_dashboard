import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/component/splash_circle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/state/component/custom_line_chart.dart';
import 'package:gnu_web_dashboard/state/util/state_manager.dart';
import 'package:loading_indicator/loading_indicator.dart';

class StateBox extends ConsumerStatefulWidget {
  final String roomId;
  final double width;
  final double height;
  final double minWidth;
  final double fontSize;

  const StateBox({
    required this.roomId,
    required this.fontSize,
    required this.width,
    required this.height,
    required this.minWidth,
    super.key,
  });

  @override
  ConsumerState<StateBox> createState() => _StateBoxState();
}

class _StateBoxState extends ConsumerState<StateBox> {
  @override
  void initState() {
    ref.read(stateManagerProvider.notifier).updatePeriodSpotMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double verticalPadding = 20;
    final double stateRowWidth = widget.width / 2.3;
    final double weatherHeight = 120;

    final state = ref.watch(stateManagerProvider)[widget.roomId];
    final notifier = ref.read(stateManagerProvider.notifier);

    String temperature = '-';
    String humidity = '-';

    if (state != null) {
      temperature = state['온도'].toString() ?? '-';
      humidity = state['습도'].toString() ?? '-';
    }

    iLog('state: $state');

    // final Map<String, List<FlSpot>> periodSpotList =
    //     notifier.getPeriodSpotMap()[roomId] ?? {};

    Map<String, List<FlSpot>> periodSpotList = {};

    periodSpotList = {
      ...periodSpotList,
      ...?notifier.getPeriodSpotMap()[widget.roomId],
    };

    List<FlSpot> temperSpotList = periodSpotList['temperSpotList'] ?? [];
    List<FlSpot> humidSpotList = periodSpotList['humidSpotList'] ?? [];

    iLog('temperSpotList: $temperSpotList');
    iLog('humidSpotList: $humidSpotList');

    return Container(
      constraints: BoxConstraints(minWidth: widget.minWidth),
      width: widget.width,
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
                          fontSize: widget.fontSize * 0.85,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: LoadingIndicator(
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
                      state == null
                          ? SizedBox(
                            width: 120,
                            height: 120,
                            child: SplashCircle(statusMsg: '상태 불러오는 중'),
                          )
                          : SizedBox(),
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
                          fontSize: widget.fontSize * 0.85,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Divider(color: DIVIDER_COLOR, height: 10),
                      ),
                      Text(
                        '$temperature°C',
                        style: TextStyle(
                          color: WHITE_TEXT_COLOR,
                          fontSize: widget.fontSize,
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
                    spots: temperSpotList,
                  ),
                ),
              ),
            ],
          ),

          /// 온/습도
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
                            fontSize: widget.fontSize * 0.85,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Divider(color: DIVIDER_COLOR, height: 10),
                      ),
                      Text(
                        '$humidity%',
                        style: TextStyle(
                          color: WHITE_TEXT_COLOR,
                          fontSize: widget.fontSize,
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
                    spots: humidSpotList,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
