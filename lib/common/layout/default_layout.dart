import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/component/top_navigator.dart';
import 'package:gnu_web_dashboard/common/const/device.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;

  DefaultLayout({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    const double globalPadding = 60.0;
    double topNaviHeight = 100;

    if (!ResponsiveBreakpoints.of(context).isDesktop) {
      topNaviHeight = 60;
      if (ResponsiveBreakpoints.of(context).isTablet)
        currentDevice = Device.TABLET;
      else if (ResponsiveBreakpoints.of(context).isMobile)
        currentDevice = Device.MOBILE;
    } else if (currentDevice != Device.DESKTOP) {
      currentDevice = Device.DESKTOP;
    }

    return Scaffold(
      // backgroundColor: backgroundColor ?? BG_COLOR,
      appBar: TopNavigator(
        height: topNaviHeight,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text('아직 아무것도 없는 홈페이지'),
        ),
      ),
    );
  }
}
