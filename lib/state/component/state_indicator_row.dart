import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/component/custom_toggle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';

class StateIndicatorRow extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final bool isOn;
  double? fontSize;

  StateIndicatorRow({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.isOn,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    fontSize ??= height / 1.7;
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
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
              width: width / 3,
              height: height,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: CustomToggle(isOn: isOn, onChanged: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
