import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/component/top_navigator.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/device.dart';
import 'package:gnu_web_dashboard/state/state_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DefaultLayout extends ConsumerWidget {
  final Color? backgroundColor;

  DefaultLayout({super.key, this.backgroundColor});

  // final TabController _tabController = TabController(length: length, vsync: vsync);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor ?? BG_COLOR,
        appBar: TopNavigator(
          height: topNaviHeight,
        ),
        resizeToAvoidBottomInset: false,
        body: StateView(roomId: '0-004-0111',),
      ),
    );
  }
}