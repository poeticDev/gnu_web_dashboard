import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/data/model/lecture.dart';
import 'package:gnu_web_dashboard/timetable/component/lecture_dialog.dart';

class LectureBox extends StatelessWidget {
  final double width;
  final double height;

  final double headerHeight;
  final String lectureName;
  final String instructorName;

  // final String weekday;
  final TimeOfDay startAt;
  final TimeOfDay endAt;
  final int colorIndex;

  final Function? onTap;

  const LectureBox({
    super.key,
    required this.width,
    required this.height,

    required this.headerHeight,
    required this.lectureName,
    required this.instructorName,
    // required this.weekday,
    required this.startAt,
    required this.endAt,
    this.colorIndex = 0,
    this.onTap,
  });

  factory LectureBox.fromModel({
    required Lecture lecture,
    required width,
    required height,
    required headerHeight,
    Function? onTap,
  }) {
    return LectureBox(
      width: width,
      height: height,
      headerHeight: headerHeight,
      lectureName: lecture.lectureName,
      instructorName: lecture.instructorName,
      startAt: lecture.startAt,
      endAt: lecture.endAt,
      colorIndex: lecture.colorIndex,
      // weekday: lecture.getWeekdayInKR(),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height * (startAt.hour - 9 + startAt.minute / 60) + headerHeight + 1,
      left: 1,
      child: GestureDetector(
        onTap: () async {
          if(onTap != null) {
            await onTap!();
          }

        },
        child: Container(
          width: width,
          height:
              height *
                  ((endAt.hour + endAt.minute / 60) -
                      (startAt.hour + startAt.minute / 60)) -
              1,
          color: LECTURE_BG_COLORS[colorIndex],
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lectureName,
                      style: SECONTDARY_TITLE_TEXT_STYLE.copyWith(
                        fontSize: height * 0.22,
                        color: BODY_TEXT_COLOR,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      instructorName,
                      style: TERTIARY_TITLE_TEXT_STYLE.copyWith(
                        fontSize: height * 0.2,
                        color: BODY_TEXT_COLOR,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
