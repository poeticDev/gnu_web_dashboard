import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/util/data/model/weekday.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';


class Lecture {
  final double id;
  final String lectureName;
  final String instructorName;
  final Weekday weekday;
  final TimeOfDay startAt;
  final TimeOfDay endAt;
  final int colorIndex;

  Lecture({
    required this.id,
    required this.lectureName,
    required this.instructorName,
    required this.weekday,
    required this.startAt,
    required this.endAt,
    this.colorIndex = 0,
  });

  /// 📌 **스프레드시트 → Lecture 객체 변환**
  factory Lecture.fromGsheets(Map<String, String> json) {
    return Lecture(
      id: double.tryParse(json['id'] ?? '0') ?? 0,
      lectureName: json['lectureName'] ?? '불러오기 실패',
      instructorName: json['instructorName'] ?? '',
      weekday: getWeekDayFromKr(json['weekday'] ?? ''),
      startAt: getTimeFromString(json['startAt'] ?? '00:00'),
      endAt: getTimeFromString(json['endAt'] ?? '00:00'),
      colorIndex: int.tryParse(json['colorIndex'] ?? '0') ?? 0,
    );
  }

  /// 📌 **Lecture 객체 → 스프레드시트 데이터 변환**
  Map<String, String> toGsheets() {
    return {
      'id': id.toString(),
      'lectureName': lectureName,
      'instructorName': instructorName,
      'weekday': getWeekdayInKR(weekday),
      'startAt': getTimeToString(startAt),
      'endAt': getTimeToString(endAt),
      'colorIndex': colorIndex.toString(),
    };
  }

  /// 📌 **String → TimeOfDay 변환 (스프레드시트에서 읽을 때)**


  /// 📌 **TimeOfDay → String 변환 (스프레드시트에 저장할 때)**
  static String getTimeToString(TimeOfDay timeOfDay) {
    final String time = timeOfDay.hour.toString().padLeft(2, '0');
    final String min = timeOfDay.minute.toString().padLeft(2, '0');

    return "'$time:$min";
  }


}

TimeOfDay getTimeFromString(String string) {
  final splitedString = string.split(':');
  final timeOfDay = TimeOfDay(
      hour: int.tryParse(splitedString[0]) ?? 0,
      minute: int.tryParse(splitedString[1]) ?? 0);

  return timeOfDay;
}