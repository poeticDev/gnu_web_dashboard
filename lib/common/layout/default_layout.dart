import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;

  DefaultLayout({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    const double globalPadding = 60.0;

    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor ?? BG_COLOR,
      resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Text('아직 아무것도 없는 홈페이지'),
          ),
        ),
    );
  }
}
