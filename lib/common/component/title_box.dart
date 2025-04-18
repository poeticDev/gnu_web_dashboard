import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/util/data/model/lecture.dart';
import 'package:gnu_web_dashboard/state/util/state_manager.dart';

class TitleBox extends ConsumerWidget {
  final double height;
  final double fontSize;
  final String roomName;

  const TitleBox({
    super.key,
    required this.height,
    required this.roomName,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Lecture? lecture = ref.watch(stateManagerProvider)['currentLecture'];
    String string = '공강입니다';
    if (lecture != null) {
      final startAt = lecture.startAt;
      final endAt = lecture.endAt;
      final instructorName = lecture.instructorName;
      final lectureName = lecture.lectureName;

      string =
          '${startAt.hour}:${startAt.minute.toString().padLeft(2, '0')} ~ ${endAt.hour}:${endAt.minute.toString().padLeft(2, '0')} $instructorName $lectureName 수업 중입니다';
    }

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(color: PRIMARY_CONTAINER_COLOR),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            '$roomName | $string',
            textAlign: TextAlign.center,
            style: TextStyle(color: WHITE_TEXT_COLOR, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
