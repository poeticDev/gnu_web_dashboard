import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';

class CustomToggle extends StatefulWidget {
  bool isOn;
  Function? onChanged;

  CustomToggle({
    required this.isOn,
    this.onChanged,
    super.key,
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.dual(
      current: widget.isOn,
      first: true,
      second: false,
      spacing: 20.0,
      animationDuration: const Duration(milliseconds: 600),
      style: const ToggleStyle(
        borderColor: Colors.transparent,
        indicatorColor: Color(0xFFFDF8F8),
        backgroundColor: Colors.black,
      ),
      customStyleBuilder: (context, local, global) {
        if (global.position <= 0.0) {
          return ToggleStyle(backgroundColor: TOGGLE_TRUE_COLOR);
        }
        return ToggleStyle(
            backgroundGradient: LinearGradient(
          colors: [TOGGLE_FALSE_COLOR, TOGGLE_TRUE_COLOR],
          stops: [
            global.position - (1 - 2 * max(0, global.position - 0.5)) * 0.7,
            global.position + max(0, 2 * (global.position - 0.5)) * 0.7,
          ],
        ));
      },
    );
  }
}
