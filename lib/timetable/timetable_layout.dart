import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/common/component/splash_circle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/data/model/lecture.dart';
import 'package:gnu_web_dashboard/common/util/data/model/weekday.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/network/google_sheets.dart';
import 'package:gnu_web_dashboard/state/util/state_manager.dart';
import 'package:gnu_web_dashboard/timetable/component/lecture_box.dart';
import 'package:gnu_web_dashboard/timetable/component/lecture_dialog.dart';
import 'package:gsheets/gsheets.dart';

List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];

enum WeekendOption { none, included }

const weekendRowLengths = {WeekendOption.none: 5, WeekendOption.included: 7};

class TimetableLayout extends ConsumerStatefulWidget {
  final double width;
  final double minWidth;
  final double fontSize;
  final String roomId;
  int columnLength;
  WeekendOption weekendOption;

  TimetableLayout({
    required this.roomId,
    this.columnLength = 10,
    this.weekendOption = WeekendOption.none,
    super.key,
    required this.width,
    required this.minWidth,
    this.fontSize = 24,
  });

  @override
  ConsumerState<TimetableLayout> createState() => _TimetableLayoutState();
}

class _TimetableLayoutState extends ConsumerState<TimetableLayout> {
  late GoogleSheets gSheet;
  bool isInitialized = false;
  int idInteger = 0;
  Timer? _updateTimer;

  @override
  void initState() {
    initGSheet();
    super.initState();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void setTimerForCurrentLecture(List<Lecture> lectureList) {
    // 1. 즉시 1회 실행
    _checkLectureAndUpdate(lectureList);

    // 2. 다음 HH:00 또는 HH:30까지 기다렸다가 이후 30분 주기 타이머 실행
    final now = DateTime.now();
    final int nextMinute = now.minute < 30 ? 30 : 60;

    final DateTime nextRun = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + (nextMinute == 60 ? 1 : 0),
      nextMinute == 60 ? 0 : 30,
    );

    final Duration initialDelay = nextRun.difference(now);

    // 일정 지연 후 30분 주기 타이머 시작
    _updateTimer = Timer(initialDelay, () {
      _checkLectureAndUpdate(lectureList);

      _updateTimer = Timer.periodic(const Duration(minutes: 30), (_) {
        _checkLectureAndUpdate(lectureList);
      });
    });
  }

  void _checkLectureAndUpdate(List<Lecture> lectureList) {
    final Lecture? oldLecture =
        ref.read(stateManagerProvider)['currentLecture'];
    final Lecture? newLecture = getCurrentLecture(lectureList);

    if (oldLecture?.id != newLecture?.id) {
      ref.read(stateManagerProvider.notifier).updateCurrentLecture(newLecture);
    }
  }

  Future<void> initGSheet() async {
    gSheet = GoogleSheets(sheetName: widget.roomId);
    await gSheet.initialize();
    isInitialized = true;
    await gSheet.loadSheets();
  }

  @override
  Widget build(BuildContext context) {
    if (gSheet.sheetName != widget.roomId) {
      isInitialized = false;
      initGSheet();
    }

    return Container(
      constraints: BoxConstraints(minWidth: widget.minWidth),
      width: widget.width,
      height: 600,
      decoration: BoxDecoration(
        color: PRIMARY_CONTAINER_COLOR,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        int integer = idInteger;

                        return LectureDialog(
                          gSheet: gSheet,
                          idInteger: integer,
                        );
                      },
                    );
                    setState(() {});
                  },
                  icon: Icon(Icons.add),
                  iconSize: widget.fontSize * 0.7,
                ),
                Text(
                  '강의시간표',
                  style: TextStyle(
                    color: WHITE_TEXT_COLOR,
                    fontSize: widget.fontSize * 0.85,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {});
                  },
                  icon: Icon(Icons.refresh),
                  iconSize: widget.fontSize * 0.7,
                ),
              ],
            ),
            Divider(color: DIVIDER_COLOR, height: 10),
            Expanded(child: _RenderTimeTable()),
          ],
        ),
      ),
    );
  }

  Widget _RenderTimeTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mWidth = constraints.maxWidth;
        final mHeight = constraints.maxHeight;

        final double headerHeight = mHeight * 0.04;
        final double boxHeight = (mHeight - headerHeight) / widget.columnLength;
        final rowLength = weekendRowLengths[widget.weekendOption]!;

        if (!isInitialized || !gSheet.isLoaded) {
          Future.delayed(Duration(seconds: 2), () {
            setState(() {});
          });
          return SplashCircle(statusMsg: '시간표 불러오는 중');
        }

        Future<List<Lecture>> lectures = gSheet.fetchAllLectures();

        return FutureBuilder<List<Lecture>>(
          future: lectures,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '에러가 발생했습니다. 관리자에게 문의하세요.\nError: ${snapshot.error.toString()}',
                ),
              );
            }

            if (snapshot.data == null ||
                snapshot.connectionState != ConnectionState.done) {
              return Center(child: SplashCircle(statusMsg: '시간표 불러오는 중'));
            }

            double maxId = 0;

            for (Lecture lecture in snapshot.data!) {
              double id = lecture.id;
              maxId = maxId < id ? id : maxId;
            }

            idInteger = maxId.floor() + 1;

            // 현재 강의 업데이트
            setTimerForCurrentLecture(snapshot.data!);

            return SizedBox(
              width: mWidth,
              height: mHeight,
              child: Row(
                children: [
                  _buildTimeColumn(
                    headerHeight: headerHeight,
                    boxHeight: boxHeight,
                    timeLength: widget.columnLength,
                  ),

                  ...List.generate(
                    rowLength,
                    (index) => _buildDayColumn(
                      weekdayIndex: index,
                      headerHeight: headerHeight,
                      boxHeight: boxHeight,
                      timeLength: widget.columnLength,
                      lectures: snapshot.data!,
                    ),
                  ).expand((widgetList) => widgetList),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeColumn({
    required double headerHeight,
    required double boxHeight,
    required int timeLength,
  }) {
    return Flexible(
      child: Column(
        children: [
          SizedBox(height: headerHeight),
          ...List.generate(timeLength * 2, (index) {
            if (index % 2 == 0) {
              return const Divider(color: TIMETABLE_DIVIDER_COLOR, height: 1);
            }

            final String string =
                (index ~/ 2 + 9) < 13
                    ? (index ~/ 2 + 9).toString()
                    : (index ~/ 2 - 3).toString();

            return SizedBox(
              height: boxHeight - 1,
              child: Center(
                child: Text(
                  string,
                  style: SECONTDARY_TITLE_TEXT_STYLE.copyWith(
                    fontSize: (boxHeight - 1) * 0.22,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildDayColumn({
    required int weekdayIndex,
    required double headerHeight,
    required double boxHeight,
    required int timeLength,
    required List<Lecture> lectures,
  }) {
    return [
      const VerticalDivider(color: TIMETABLE_DIVIDER_COLOR, width: 0),
      Expanded(
        flex: 3,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boxWidth = constraints.maxWidth - 2;

            List lectureBoxes = [];

            for (Lecture lecture in lectures) {
              if (lecture.weekday.index == weekdayIndex) {
                lectureBoxes = [
                  ...lectureBoxes,
                  LectureBox.fromModel(
                    lecture: lecture,
                    width: boxWidth,
                    height: boxHeight,
                    headerHeight: headerHeight,
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          final int idInteger = lecture.id.floor();

                          List<Lecture> lectureList =
                              lectures
                                  .where((e) => e.id.floor() == idInteger)
                                  .toList();

                          return LectureDialog(
                            lectureList: lectureList,
                            idInteger: idInteger,
                            gSheet: gSheet,
                          );
                        },
                      );

                      setState(() {
                        Future.delayed(Duration(seconds: 3));
                      });
                    },
                  ),
                ];
              }
            }

            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: headerHeight,
                      child: Text(
                        weekdays[weekdayIndex],
                        style: SECONTDARY_TITLE_TEXT_STYLE.copyWith(
                          fontSize: headerHeight * 0.65,
                        ),
                      ),
                    ),
                    ...List.generate(timeLength * 2, (index) {
                      if (index % 2 == 0) {
                        return DottedLine(
                          dashColor: TIMETABLE_DIVIDER_COLOR,
                          dashGapLength: index == 0 ? 0 : 4,
                          lineThickness: 1,
                        );
                      }

                      return SizedBox(height: boxHeight - 1);
                    }),
                  ],
                ),
                ...lectureBoxes,
              ],
            );
          },
        ),
      ),
    ];
  }
}

Lecture? getCurrentLecture(List<Lecture> lectureList) {
  final now = DateTime.now();
  final today = getWeekdayFromDateTime(now);
  final TimeOfDay time = TimeOfDay.fromDateTime(now);

  try {
    return lectureList.firstWhere(
      (lecture) =>
          lecture.weekday == today &&
          isBetween(time, lecture.startAt, lecture.endAt),
    );
  } catch (_) {
    return null;
  }
}

bool isBetween(TimeOfDay time, TimeOfDay startAt, TimeOfDay endAt) {
  int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  final int timeMinutes = toMinutes(time);
  final int startMinutes = toMinutes(startAt);
  final int endMinutes = toMinutes(endAt);

  return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
}
