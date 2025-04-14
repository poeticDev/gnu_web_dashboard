import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/component/splash_circle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/data/model/lecture.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:gnu_web_dashboard/common/util/network/google_sheets.dart';
import 'package:gnu_web_dashboard/timetable/component/lecture_box.dart';

List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];

enum WeekendOption { none, included }

const weekendRowLengths = {WeekendOption.none: 5, WeekendOption.included: 7};

class TimetableLayout extends StatefulWidget {
  final String roomId;
  int columnLength;
  WeekendOption weekendOption;
  final List<Lecture> lectures;

  TimetableLayout({
    required this.roomId,
    this.columnLength = 10,
    this.weekendOption = WeekendOption.none,
    super.key,
    required this.lectures,
  });

  @override
  State<TimetableLayout> createState() => _TimetableLayoutState();
}

class _TimetableLayoutState extends State<TimetableLayout> {
  late final gSheet;
  bool isInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initGSheet();
  }

  Future<void> initGSheet() async {
    dLog('구글 시트 이닛 시작');
    dLog('구글 시트 인스턴스 생성 시작');
    gSheet = GoogleSheets(sheetName: widget.roomId);
    dLog('구글 시트 인스턴스 생성 완료');
    dLog('구글 시트 이니셜라이즈 시작');
    await gSheet.initialize();
    dLog('구글 시트 이니셜라이즈 완료');
    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mWidth = constraints.maxWidth;
        final mHeight = constraints.maxHeight;

        final double headerHeight = mHeight * 0.04;
        final double boxHeight = (mHeight - headerHeight) / widget.columnLength;
        final rowLength = weekendRowLengths[widget.weekendOption]!;

        if(!isInitialized){
          return SplashCircle();
        }

        Future<List<Lecture>> lectures = gSheet.fetchAllLectures();

        return FutureBuilder<Object>(
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
                      // Column(
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         final Lecture lecture = Lecture(
                      //           id: 1,
                      //           lectureName: '강의명',
                      //           instructorName: '교수명',
                      //           weekday: Weekday.monday,
                      //           startAt: TimeOfDay(hour: 10, minute: 30),
                      //           endAt: TimeOfDay(hour: 12, minute: 0),
                      //         );
                      //
                      //         gSheet.insertLecture(lecture);
                      //       },
                      //       child: Text('1 업댓'),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         final lecture = await gSheet.fetchLecture(3);
                      //
                      //         print(lecture.id);
                      //         print(lecture.lectureName);
                      //         print(lecture.instructorName);
                      //         print(lecture.startAt);
                      //         print(lecture.endAt);
                      //         print(lecture.weekday);
                      //         print(lecture.colorIndex);
                      //
                      //         // print(await gSheet.getRow(3));
                      //       },
                      //       child: Text('프린트'),
                      //     ),
                      //   ],
                      // ),
                      ...List.generate(
                        rowLength,
                        (index) => _buildDayColumn(
                          weekdayIndex: index,
                          headerHeight: headerHeight,
                          boxHeight: boxHeight,
                          timeLength: widget.columnLength,
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
  }) {
    return [
      const VerticalDivider(color: TIMETABLE_DIVIDER_COLOR, width: 0),
      Expanded(
        flex: 3,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boxWidth = constraints.maxWidth - 2;

            List lectureBoxes = [];

            for (Lecture lecture in widget.lectures) {
              if (lecture.weekday.index == weekdayIndex) {
                lectureBoxes = [
                  ...lectureBoxes,
                  LectureBox.fromModel(
                    lecture: lecture,
                    width: boxWidth,
                    height: boxHeight,
                    headerHeight: headerHeight,
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
