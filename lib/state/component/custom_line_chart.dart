import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';

class CustomLineChart extends StatefulWidget {
  final List<Color>? gradientColors;
  final String? xName;
  final String? yName;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final Map<double, String>? xTitleMap;
  final Map<double, String>? yTitleMap;

  const CustomLineChart({
    super.key,
    this.gradientColors,
    this.xName,
    this.yName,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    this.xTitleMap,
    this.yTitleMap,
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  late List<Color> gradientColors;
  double fontSize = 12;

  @override
  void initState() {
    gradientColors = widget.gradientColors ??
        [
          Colors.blue,
          Colors.green,
          Colors.green,
          Colors.green,
          Colors.yellow,
          Colors.red,
        ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /// chart
        Padding(
          padding: EdgeInsets.only(
            right: 12,
            left: fontSize,
            top: 20,
            bottom: 4,
          ),
          child: LineChart(
            mainData(),
          ),
        ),

        /// Y축 단위
        if (widget.yName != null)
          SizedBox(
            width: 60,
            height: 24,
            child: Center(
              child: Text(
                widget.yName!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    Text textWidget = Text('', style: style);

    String? text;
    if (widget.xTitleMap != null) {
      text = widget.xTitleMap![value];
      if (text != null) {
        textWidget = Text(text, style: style);
      }
    } else {
      if (value == widget.minX)
        textWidget = Text(
          widget.minX.toString(),
          style: style,
        );
      else if (value == widget.maxX)
        textWidget = Text(
          widget.maxX.toString(),
          style: style,
        );
      else if (value == (widget.maxX + widget.minX) / 2)
        textWidget = Text(
          ((widget.maxX + widget.minX) / 2).toString(),
          style: style,
        );
    }

    // switch (value.toInt()) {
    //   case 2:
    //     textWidget = const Text('MAR', style: style);
    //     break;
    //   case 5:
    //     textWidget = const Text('JUN', style: style);
    //     break;
    //   case 8:
    //     textWidget = const Text('SEP', style: style);
    //     break;
    //   default:
    //     textWidget = const Text('', style: style);
    //     break;
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: textWidget,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    String? text;
    if (widget.yTitleMap != null) {
      text = widget.yTitleMap![value];
    } else {
      if (value == widget.minY)
        text = widget.minY.toString();
      else if (value == widget.maxY)
        text = widget.maxY.toString();
      else if (value == (widget.maxY + widget.minY) / 2)
        text = ((widget.maxY + widget.minY) / 2).toString();
    }

    if (text == null) return Container();

    // switch (value.toInt()) {
    //   case 0:
    //     text = '0';
    //     break;
    //   case 10:
    //     text = '10';
    //     break;
    //   case 20:
    //     text = '20';
    //     break;
    //   case 30:
    //     text = '30';
    //     break;
    //   case 40:
    //     text = '40';
    //     break;
    //   default:
    //     return Container();
    // }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white70,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white70,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: fontSize * 2,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: fontSize * 2,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: widget.minX,
      maxX: widget.maxX,
      minY: widget.minY,
      maxY: widget.maxY,
      lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 16.0,
              getTooltipItems: (spotList) {
                return spotList
                    .map(
                      (spot) => LineTooltipItem(
                        spot.y.toString(),
                        TextStyle(
                            color: BODY_TEXT_COLOR,
                            fontVariations: [FontVariation.weight(600)]),
                      ),
                    )
                    .toList();
              },
              getTooltipColor: (spotData) {
                return COMPONENT_BG_COLOR;
              }),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    Color dotColor = Colors.green;

                    if (spot.y < 10)
                      dotColor = Colors.blue;
                    else if (spot.y > 25 && spot.y < 30)
                      dotColor = Colors.orange;
                    else if (spot.y >= 30) dotColor = Colors.red;

                    return FlDotCirclePainter(
                      radius: 6,
                      color: dotColor, // ✅ 강조 dot 색상
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              );
            }).toList();
          }),
      lineBarsData: [
        LineChartBarData(
          spots: const [
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
          isCurved: true,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors:
                  gradientColors.map((color) => color.withAlpha(80)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
