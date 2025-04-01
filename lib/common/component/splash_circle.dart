import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashCircle extends StatelessWidget {
  String? statusMsg;

  SplashCircle({this.statusMsg, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mWidth = constraints.maxWidth;
        final mHeight = constraints.maxHeight;

        final maxWidth = mWidth > mHeight ? mHeight : mWidth;

        return SizedBox(
          width: maxWidth,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: maxWidth * 2/3,
                    height: maxWidth * 2/3,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballSpinFadeLoader,
                      colors: [DIVIDER_COLOR],
                    ),
                  ),
                ),
                if (statusMsg != null) Text(statusMsg!),
              ],
            ),
          ),
        );
      }
    );
  }
}
