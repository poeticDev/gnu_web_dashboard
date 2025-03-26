import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/component/custom_toggle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';

class StateRow extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  double? fontSize;

  StateRow({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    fontSize ??= height / 1.7;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width - 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: WHITE_TEXT_COLOR,
                    fontSize: fontSize,
                    fontVariations: const [FontVariation('wght', 200)],
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CustomToggle(isOn: true),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   width: width / 2 - 24,
          //   child: Center(child: Text('시계열')),
          // )
        ],
      ),
    );
  }
}
