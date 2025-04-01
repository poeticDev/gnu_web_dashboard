import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';

void showCustomToast({required FToast fToast, required String toastMsg}) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: TOAST_BG_COLOR,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(width: 12.0),
        Text(
          toastMsg,
          style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: 16.0),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    toastDuration: Duration(seconds: 1),
  );
}
